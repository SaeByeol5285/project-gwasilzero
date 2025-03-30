<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>게시글 신고 관리</title>
</head>
<body>
<div id="reportApp">
    <div class="layout">
        <jsp:include page="layout.jsp" />

        <div class="content">
            <div class="header">
                <div>관리자페이지</div>
                <div>Admin님</div>
            </div>

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
                <div class="pagination">
                    <a v-if="repoPage != 1" href="javascript:;" @click="fnRepoPageMove('prev')" class="page-btn">&lt;</a>
                    <a href="javascript:;" v-for="num in repoPageCount" @click="fnRepoPage(num)" 
                       :class="{'active': repoPage == num}" class="page-btn">{{num}}</a>
                    <a v-if="repoPage != repoPageCount" href="javascript:;" @click="fnRepoPageMove('next')" class="page-btn">&gt;</a>
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
            fnRepoPage(num) {
                var self = this;
                self.repoPage = num;
                self.fnGetReports();
            },
            fnRepoPageMove(dir) {
                var self = this;
                if (dir === 'prev' && self.repoPage > 1) self.repoPage--;
                else if (dir === 'next' && self.repoPage < self.repoPageCount) self.repoPage++;
                self.fnGetReports();
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