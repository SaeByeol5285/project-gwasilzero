<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <title>게시글 신고 관리</title>
    </head>

    <body>
        <div id="reportApp">
            <jsp:include page="layout.jsp" />
            <div class="content">
                <h2>게시글 관리</h2>
                <div class="content-container">
                    <div>
                        <h3>게시글 신고 목록 (총 : {{ repoTotal }}건)</h3>
                        <table>
                            <tr>
                                <th>게시글 번호</th>
                                <th>신고자 아이디</th>
                                <th>신고내용</th>
                                <th>처리상태</th>
                                <th>처리</th>
                            </tr>

                            <!-- 하나의 template로 묶어서 요약행과 펼침행을 모두 포함 -->
                            <template v-for="item in groupedReports" :key="item.boardNo">

                                <!-- 요약 행 -->
                                <tr>
                                    <td> <a @click=fnBoardView(item)>{{ item.boardNo }}
                                            <span v-if="item.count > 1">({{ item.count }}건)</span></a>

                                    </td>
                                    <td>
                                        『{{ item.userIdList[0] }}』
                                        <span v-if="item.count > 1"> 외 {{ item.count - 1 }}명</span>
                                    </td>
                                    <td>『{{ item.contents }}』 등</td>
                                    <td>
                                        <span v-if="item.reportStatus === 'DELETE'">삭제 상태</span>
                                        <span v-else-if="item.reportStatus === 'REJECT'">신고 기각</span>
                                        <span v-else-if="item.reportStatus === 'WAIT'">처리 대기</span>
                                    </td>
                                    <td>
                                        <div class="filter-bar">
                                            <select v-model="item.actionStatus">
                                                <option disabled value="">선택</option>
                                                <option value="DELETE">게시글 삭제</option>
                                                <option value="REJECT">신고기각</option>
                                                <option value="WAIT">처리대기</option>
                                            </select>
                                            <button @click="fnHandleReport(item)">처리하기</button>
                                            <button @click="fnToggleDetails(item.boardNo)">
                                                {{ selectedBoardNo === item.boardNo ? '접기' : '자세히' }}
                                            </button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 펼침 상세 행 -->
                                <tr v-if="selectedBoardNo === item.boardNo"
                                    v-for="sub in reportList.filter(r => r.boardNo === item.boardNo)"
                                    :key="'detail-' + sub.reportNo" class="detail-row"
                                    style="background-color: #f9f9f9;">
                                    <td>{{ sub.boardNo }}</td>
                                    <td>{{ sub.userId }}</td>
                                    <td>{{ sub.contents }}</td>
                                    <td>
                                        <span v-if="sub.reportStatus === 'DELETE'">삭제 상태</span>
                                        <span v-else-if="sub.reportStatus === 'REJECT'">신고 기각</span>
                                        <span v-else-if="sub.reportStatus === 'WAIT'">처리 대기</span>
                                    </td>
                                    <td> - </td>
                                </tr>

                            </template>
                        </table>

                        <!-- 페이지네이션 -->
                        <div class="pagination-container">
                            <button class="btn" @click="fnRepoPrevPage" :disabled="repoPage === 1">〈 이전</button>
                            <button v-for="n in repoPageCount" :key="n" @click="fnRepoPage(n)"
                                :class="['btn', repoPage === n ? 'active' : '']">
                                {{ n }}
                            </button>
                            <button class="btn" @click="fnRepoNextPage" :disabled="repoPage === repoPageCount">다음
                                〉</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>

    <script>
        const reportApp = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    reportList: [],
                    repoTotal: 0,
                    repoPage: 1,
                    repoPageSize: 15,
                    repoPageCount: 0,
                    selectedBoardNo: null,
                };
            },
            computed: {
                groupedReports() {
                    const grouped = {};
                    this.reportList.forEach((item) => {
                        const key = item.boardNo;
                        if (!grouped[key]) {
                            grouped[key] = {
                                ...item,
                                count: 1,
                                userIdList: [item.userId]  // 신고자 목록
                            };
                        } else {
                            grouped[key].count++;
                            if (!grouped[key].userIdList.includes(item.userId)) {
                                grouped[key].userIdList.push(item.userId);
                            }
                        }
                    });

                    return Object.values(grouped);
                }
            },
            methods: {
                fnGetReports() {
                    var self = this;
                    var nparmap = {
                        repoPage: (self.repoPage - 1) * self.repoPageSize,
                        repoPageSize: self.repoPageSize
                    };
                    $.ajax({
                        url: "/admin/reportList.dox",
                        type: "POST",
                        dataType: "json",
                        data: nparmap,
                        success: function (data) {
                            self.reportList = data.reportList.map(item => ({
                                ...item,
                                actionStatus: '' // 초기값 설정
                            }));
                            self.repoTotal = data.count;
                            self.repoPageCount = Math.ceil(data.count / self.repoPageSize);

                            // 페이지에 내용 없을 경우 이전 페이지로 이동
                            if (self.reportList.length === 0 && self.repoPage > 1) {
                                self.repoPage--;
                                self.fnGetReports();
                            }
                        }
                    });
                },
                fnToggleDetails(boardNo) {
                    this.selectedBoardNo = this.selectedBoardNo === boardNo ? null : boardNo;
                },
                fnRepoPage(n) {
                    this.repoPage = n;
                    this.fnGetReports();
                },
                fnRepoPrevPage() {
                    if (this.repoPage > 1) {
                        this.repoPage--;
                        this.fnGetReports();
                    }
                },
                fnRepoNextPage() {
                    if (this.repoPage < this.repoPageCount) {
                        this.repoPage++;
                        this.fnGetReports();
                    }
                },
                fnHandleReport(item) {
                    if (!item.actionStatus) {
                        Swal.fire({
                            icon: 'warning',
                            title: '처리 상태 선택 필요',
                            text: '처리 상태를 선택해주세요.',
                            confirmButtonText: '확인'
                        });
                        return;
                    }
                    let boardStatus = "";
                    if (item.actionStatus == "DELETE") {
                        boardStatus = "DELETE";
                    }
                    $.ajax({
                        url: "/admin/updateReportStatus.dox",
                        type: "POST",
                        data: {
                            reportNo: item.reportNo,
                            reportStatus: item.actionStatus,
                            boardNo: item.boardNo,
                            boardStatus: boardStatus
                        },
                        success: (data) => {
                            Swal.fire({
                                icon: 'success',
                                title: '처리 완료',
                                text: '신고가 성공적으로 처리되었습니다.',
                                confirmButtonText: '확인'
                            });
                            this.fnGetReports(); // 새로고침
                        }
                    });
                },
                fnBoardView(item) {
                    pageChange("/board/view.do", { boardNo: item.boardNo });
                }
            },
            mounted() {
                this.fnGetReports();
            }
        });

        reportApp.mount("#reportApp");
    </script>