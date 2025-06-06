<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
	      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
</head>
<body>
    <div id="mainApp">
        <jsp:include page="layout.jsp" />

        <div class="content">
            <h2>관리자 메인 페이지</h2>
            <div class="content-container">
                <div>
                    <h3>최근 가입 회원</h3>
                    <table>
                        <tr>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>전화번호</th>
                            <th>이메일</th>
                            <th>등급</th>
                            <th>가입일자</th>
                        </tr>
                        <tr v-for="newMem in newMemList">
                            <td>{{newMem.userName}}</td>
                            <td>{{newMem.userId}}</td>
                            <td>{{newMem.userPhone}}</td>
                            <td>{{newMem.userEmail}}</td>
                            <td>
                                <span v-if="newMem.userStatus === 'ADMIN'">관리자</span>
                                <span v-else-if="newMem.userStatus === 'NORMAL'">일반 회원</span>
                                <span v-else-if="newMem.userStatus === 'OUT'">탈퇴 회원</span>
                                <span v-else>{{ newMem.userStatus }}</span>
                            </td>
                            <td>{{newMem.cdate}}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h3>변호사 승인 대기 목록</h3>
                    <table>
                        <tr>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>전화번호</th>
                            <th>변호사 등록번호</th>
                            <th>변호사 취득일시</th>
                            <th>승인여부</th>
                        </tr>
                        <tr v-for="lawWait in lawAdminWaitList">
                            <td>{{lawWait.lawyerName}}</td>
                            <td>{{lawWait.lawyerId}}</td>
                            <td>{{lawWait.lawyerPhone}}</td>
                            <td>{{lawWait.lawyerNumber}}</td>
                            <td>{{lawWait.passYears}}</td>
                            <td>{{lawWait.lawyerPass}}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h3>게시글 신고 목록</h3>
                    <table>
                        <tr>
                            <th>신고 아이디</th>
                            <th>게시판 번호</th>
                            <th>신고상태</th>
                            <th>신고날짜</th>
                            <th>신고내용</th>
                        </tr>
                        <tr v-for="report in repoAdminList">
                            <td>{{report.userId}}</td>
                            <td>{{report.boardNo}}</td>
                            <td>
                                <span v-if="report.reportStatus === 'DELETE'">삭제 상태</span>
                                <span v-else-if="report.reportStatus === 'REJECT'">신고 기각</span>
                                <span v-else-if="report.reportStatus === 'WAIT'">처리 대기</span>
                            </td>
                            <td>{{report.cdate}}</td>
                            <td>{{report.contents}}</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        </div> <!-- 여기서 layout 닫기  -->
    </div> 
</body>
</html>
<script>
    const mainApp = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                newMemList : [],
                lawAdminWaitList : [],
                repoAdminList : []
            };
        },
        methods: {
            fnNewMemList(){
				var self = this;
				var nparmap = {
					
				};
				$.ajax({
					url:"/admin/newMemList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
                        self.newMemList = data.newMemList;
					}
				});
            },
            fnLawAdminWaitList(){
                var self = this;
				var nparmap = {
					
				};
				$.ajax({
					url:"/admin/lawAdminWaitList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        self.lawAdminWaitList = data.lawAdminWaitList;
					}
				});
            },
            fnRepoList(){
                var self = this;
				var nparmap = {
					
				};
				$.ajax({
					url:"/admin/repoAdminList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						self.repoAdminList = data.repoAdminList;
					}
				});
            }   
            
        },
        mounted() {
            var self = this;
            self.fnNewMemList();
            self.fnLawAdminWaitList();
            self.fnRepoList();
        }
    });
    mainApp.mount('#mainApp');
</script>