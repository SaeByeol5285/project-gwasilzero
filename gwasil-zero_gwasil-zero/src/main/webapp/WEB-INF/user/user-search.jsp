<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>sample.jsp</title>
    </head>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        #app {
            display: flex;
            width: 80%;
            max-width: 900px;
        }

        .form-section {
            width: 50%;
            padding: 20px;
        }

        .divider {
            width: 2px;
            background-color: #000;
            height: 100%;
            margin: 0 20px;
        }

        .form-section input {
            margin: 10px 0;
            padding: 8px;
            width: 100%;
            box-sizing: border-box;
        }

        .form-section button {
            margin-top: 10px;
            padding: 8px;
            width: 100%;
            cursor: pointer;
        }
    </style>

    <body>
        <div id="app">
            <div class="form-section">
                <div>아이디 찾기</div>
                <div>이름 <input v-model="user.name" placeholder="이름 입력"></div>
                <div>
                    핸드폰 번호 : <input v-model="user.phone" placeholder="번호 입력">
                    <button @click="fnSmsAuth">인증요청</button>
                </div>
                <div>
                    <input v-model="authInputNum" :placeholder="timer">
                    <button @click="fnNumAuth">인증 확인</button>
                </div>
                <div>
                    <button @click="fnSearchId">아이디 찾기</button>
                </div>
            </div>

            <div class="divider"></div>

            <div class="form-section">
                <div>비밀번호 찾기</div>
                <div>아이디 <input v-model="user.userId" placeholder="아이디 입력"></div>
                <div>
                    핸드폰 번호 : <input v-model="user.phone" placeholder="번호 입력">
                    <button @click="fnSmsAuth">인증요청</button>
                </div>
                <div>
                    <input v-model="authInputNum" :placeholder="timer">
                    <button @click="fnNumAuth">인증 확인</button>
                </div>
                <div>
                    <button @click="fnSearchPwd">비밀번호 찾기</button>
                </div>
            </div>
        </div>

    </body>

    </html>
    <script>
        const app = Vue.createApp({
        data() {
            return {
                user: {
                    name: "", phone: "", userId: ""
                },
                authNum: "",
                authInputNum: "",
                timer: "",
                count: 180,
                foundUserId: "", 
                foundUserPwd: "" 
            };
        },
        methods: {
            fnSmsAuth() {
                var self = this;
                $.ajax({
                    url: "/user/user-search.dox",  
                    type: "POST",
                    data: { phone: self.user.phone },
                    success: function (data) {
                        if (data.status === "success") {
                            alert("문자 발송 완료");
                            self.authNum = data.authNum;
                            setInterval(self.fnTimer, 1000);
                        } else {
                            alert("문자 발송 실패");
                        }
                    }
                });
            },

            fnNumAuth() {
                if (this.authNum === this.authInputNum) {
                    alert("인증 완료");
                } else {
                    alert("인증 실패");
                }
            },

            fnTimer() {
                this.count--;
                let min = Math.floor(this.count / 60);
                let sec = this.count % 60;
                this.timer = `${min}:${sec < 10 ? '0' + sec : sec}`;
            },

            fnSearchId() {
                var self = this;
                $.ajax({
                    url: "/user/findId",  
                    type: "POST",
                    data: { name: self.user.name, phone: self.user.phone },
                    success: function (data) {
                        if (data.status === "success") {
                            self.foundUserId = data.userId;  
                        } else {
                            alert("아이디 찾기 실패");
                        }
                    }
                });
            },

            fnSearchPwd() {
                var self = this;
                $.ajax({
                    url: "/user/findPwd", 
                    type: "POST",
                    data: { userId: self.user.userId, phone: self.user.phone },
                    success: function (data) {
                        if (data.status === "success") {
                            self.foundUserPwd = data.userPwd; 
                        } else {
                            alert("비밀번호 찾기 실패");
                        }
                    }
                });
            }
        },
        mounted() {
            console.log('Vue instance mounted');
        }
    });
    app.mount('#app');
    </script>
    ​