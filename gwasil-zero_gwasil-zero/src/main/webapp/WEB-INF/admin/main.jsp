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
                        <tr v-for="item in list">
                            <td>{{item.userName}}</td>
                            <td>{{item.userId}}</td>
                            <td>{{item.userStatus}}</td>
                            <td>{{item.cdate}}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h3>변호사 승인 대기 목록</h3>
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
                list : []
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
                        self.list = data.list;
					}
				});
            },
            
        },
        mounted() {
            var self = this;
            self.fnNewMemList();
        }
    });
    mainApp.mount('#mainApp');
</script>