<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
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
                        <tr v-for="(item, index) in reportList" :key="item.reportNo">
                            <td>{{ item.boardNo }}</td>
                            <td>{{ item.userId }}</td>
                            <td>{{ item.contents }}</td>
                            <td>
                                <span v-if="item.reportStatus === 'DELETE'">삭제 상태</span>
                                <span v-else-if="item.reportStatus === 'REJECT'">신고 기각</span>
                                <span v-else-if="item.reportStatus === 'WAIT'">처리 대기</span>
                            </td>
                            <td>
                                <select v-model="item.actionStatus">
                                    <option disabled value="">선택</option>
                                    <option value="DELETE">게시글 삭제</option>
                                    <option value="REJECT">신고기각</option>
                                    <option value="WAIT">처리대기</option>
                                </select>&nbsp;
                                <button @click="fnHandleReport(item)">처리하기</button>
                            </td>
                        </tr>
                    </table>
                    <div class="pagination-container">
                        <button class="btn" @click="fnRepoPrevPage" :disabled="repoPage === 1">〈 이전</button>
                        <button 
                           v-for="n in repoPageCount" 
                           :key="n" 
                           @click="fnRepoPage(n)" 
                           :class="['btn', repoPage === n ? 'active' : '']">
                           {{ n }}
                        </button>
                        <button class="btn" @click="fnRepoNextPage" :disabled="repoPage === repoPageCount">다음 〉</button>
                     </div> 
                </div>
            </div>                
        </div>
        </div>  <!-- 여기서 layout 닫기  -->
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
            };
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
                    data : nparmap,
                    success: function(data) {
                        // 기본 선택값 설정
                        self.reportList = data.reportList.map(item => ({
                            ...item,
                            actionStatus: '' // 선택된 처리 옵션
                        }));
                        self.repoTotal = data.count;
                        self.repoPageCount = Math.ceil(data.count / self.repoPageSize);
                        
                        // 현재 페이지에 데이터가 하나만 있고 삭제된 경우 페이지 이동
                        if (self.reportList.length === 0 && self.repoPage > 1) {
                            self.repoPage--;
                            self.fnGetReports(); // 다시 불러오기
                        }
                    }
                });
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
                    alert("처리 상태를 선택해주세요.");
                    return;
                }
                $.ajax({
                    url: "/admin/updateReportStatus.dox",
                    type: "POST",
                    data: {
                        reportNo: item.reportNo,
                        reportStatus: item.actionStatus
                    },
                    success: (data) => {
                        alert("처리되었습니다.");
                        this.fnGetReports(); // 새로고침
                    }
                });
            }
        },
        mounted() {
            var self = this;
            self.fnGetReports();
        }
    });
    reportApp.mount("#reportApp");
</script>