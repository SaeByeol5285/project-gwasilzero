<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
	<title>스프링 로그인</title>
</head>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f5f5f5;
        text-align: center;
        padding: 50px;
    }
    .container {
        max-width: 400px;
        margin: auto;
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .input-group {
        margin-bottom: 15px;
        text-align: left;
    }
    .input-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .input-box {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 16px;
    }
    .btn {
        background: #6a5acd;
        color: white;
        border: none;
        padding: 12px 15px;
        width: 100%;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
    }
    .btn:hover {
        background: #5a4abc;
    }
</style>
<body>
    <div id="app" class="container">
        <h2>로그인</h2>
        <div class="input-group">
            <label>아이디</label>
            <input v-model="userId" type="text" class="input-box">
        </div>
        <div class="input-group">
            <label>비밀번호</label>
            <input v-model="pwd" type="password" class="input-box">
        </div>
        <button @click="fnLogin" class="btn">로그인</button><br><br><br>
        <button @click="fnSearchPwd(userId)" class="btn">비밀번호 찾기</button>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                userId : "",
				pwd : "",
                location : "${location}"
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {
					userId : self.userId,
					pwd : self.pwd
				};
				$.ajax({
					url:"/member/login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        console.log(data.member.userStatus);
                        if (data.result == "success") {
                            if (data.member.userStatus == "A") {
                                alert(data.member.userName + "님 환영합니다!");
                                location.href = "/admin/main.do";
                            } else {
                                alert("접근 권한이 없습니다. 로그인 페이지로 이동합니다.");
                                location.href = "/member/login.do" 
                            }
                        }    
					}
				});
            },
            fnSearchPwd : function(userId){
                var self = this;
                if(self.userId == ""){
                    alert("아이디 입력하세요!");
                    return;
                }
                pageChange("/member/pwd.do", {userId : userId});
            }
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>
​