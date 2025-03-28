<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>관리자 메인</title>
</head>
<body>
    <div id="mainApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />
    
            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
                <div>
                    <h3>최근 가입 회원</h3>
                    <table>
                        <tr>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>등급</th>
                            <th>가입일자</th>
                        </tr>
                        <tr v-for="newMem in newMemList">
                            <td>{{newMem.userName}}</td>
                            <td>{{newMem.userId}}</td>
                            <td>{{newMem.userStatus}}</td>
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
                            <th>승인여부</th>
                        </tr>
                        <tr v-for="lawWait in lawAdminWaitList">
                            <td>{{lawWait.lawyerName}}</td>
                            <td>{{lawWait.lawyerId}}</td>
                            <td>{{lawWait.lawyerPass}}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h3>게시글 신고 목록</h3>
                    <table>
                        <tr>
                            <th>아이디</th>
                            <th>게시판 번호</th>
                            <th>신고상태</th>
                            <th>신고날짜</th>
                            <th>신고내용</th>
                        </tr>
                        <tr v-for="report in repoAdminList">
                            <td>{{report.userId}}</td>
                            <td>{{report.boardNo}}</td>
                            <td>{{report.reportStatus}}</td>
                            <td>{{report.cdate}}</td>
                            <td>{{report.contents}}</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>  
</body>
</html>
<script>
    const mainApp = Vue.createApp({
        data() {
            return {
                newMemList : [],
                lawAdminWaitList : [],
                repoList : []
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