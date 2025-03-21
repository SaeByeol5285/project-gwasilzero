<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>admin main</title>
    <style>
        #app {
            display: flex;
            height: 100vh;
        }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
        }
        .sidebar {
            width: 300px;
            padding: 10px;
            background: #b0c4de;
            padding: 20px;
            height: 900px;
            margin-top: 10px;
            margin-left: 10px;
        }
        .sidebar h2 {
            text-align: center;
        }
        .sidebar button {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: none;
            background: #f7f7f7;
            cursor: pointer;
        }
        .sidebar button.active {
            background: yellow;
        }
        .logout {
            margin-top: 20px;
            width: 100%;
            background: white;
            border: 1px solid black;
        }
        .content {
            width: 1500px;
            flex: 1;
            padding: 20px;
            margin-top: 10px;
            background: #f0f0f0;
        }
        .header {
            background: #a0a0c0;
            padding: 10px;
            display: flex;
            justify-content: space-between;
        }
        .box {
            background: #d3d3d3;
            padding: 20px;
            margin: 10px 0;
            height: 200px;
        }
        .more {
            text-align: right;
            font-size: small;
            color: blue;
            cursor: pointer;
        }
    </style>
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
            <div class="box">
                <strong>최근 회원가입</strong>
                <div class="more">+더보기</div>
            </div>
            <div class="box">
                <strong>변호사 승인 대기 목록</strong>
                <div class="more">+더보기</div>
            </div>
            <div class="box">
                <strong>게시글 신고 목록</strong>
                <div class="more">+더보기</div>
            </div>
        </div>
    </div>    
        
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId : "${sessionId}",
                sessionStatus : "${sessionStatus}"
            };
        },
        methods: {
            fnAdminCheck: function(){
				var self = this;
				if (!"admin".equals(sessionId) || !"A".equals(sessionStatus)) {
                    alert("접근 권한이 없습니다. 로그인 페이지로 이동합니다.");
                    location.href = "/member/login.do"      
                }
            }    
        },
        mounted() {
            var self = this;
            self.fnAdminCheck();
        }
    });
    app.mount('#app');
</script>