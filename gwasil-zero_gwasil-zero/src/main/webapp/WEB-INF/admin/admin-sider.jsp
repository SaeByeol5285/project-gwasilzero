<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>admin sider</title>
    <link rel="stylesheet" href="../css/admin-style.css">
</head>
<body>
    <div id="app">
        <div class="sidebar">
            <h2>로고</h2>
            <button class="active">대시보드</button>
            <button>회원 관리</button>
            <button>변호사 관리</button>
            <button>게시글 관리</button>
            <button>통계</button>
            <button>상품관리</button>
            <button class="logout">logout</button>
        </div>
        <div class="content">
            <div class="header">
                <div>관리자페이지</div>
                <div>Admin님</div>
            </div>
        </div>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {};
				$.ajax({
					url:"login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
					}
				});
            }
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>