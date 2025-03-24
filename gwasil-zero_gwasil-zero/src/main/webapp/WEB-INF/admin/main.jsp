<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>admin main</title>
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
                        <tr v-for="uItem in uList">
                            <td>{{uItem.userName}}</td>
                            <td>{{uItem.userId}}</td>
                            <td>{{uItem.userStatus}}</td>
                            <td>{{uItem.cdate}}</td>
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
                        <tr v-for="lawItem in lawList">
                            <td>{{lawItem.lawyerName}}</td>
                            <td>{{lawItem.lawyerId}}</td>
                            <td>{{lawItem.lawyerPass}}</td>
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
                uList : [],
                lawList : [],
                repoList : []
            };
        },
        methods: {
            fnNewMemList(){
				var self = this;
				var nparmap = {
					
				};
				$.ajax({
					url:"/newMemList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.uList = data.uList;
					}
				});
            },
            fnLawPassList(){
                var self = this;
				var nparmap = {
					
				};
				$.ajax({
					url:"/lawPassList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.lawList = data.lawList;
					}
				});
            },
            // fnRepoList(){
            //     var self = this;
			// 	var nparmap = {
					
			// 	};
			// 	$.ajax({
			// 		url:"/repoList.dox",
			// 		dataType:"json",	
			// 		type : "POST", 
			// 		data : nparmap,
			// 		success : function(data) { 
			// 			console.log(data);
                        
			// 		}
			// 	});
            // }   ==> 추후 작업
            
        },
        mounted() {
            var self = this;
            self.fnNewMemList();
            self.fnLawPassList();
            // self.fnRepoList();
        }
    });
    mainApp.mount('#mainApp');
</script>