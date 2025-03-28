<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <title>첫번째 페이지</title>
    </head>
    <style>
        .simple-style {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 2px solid #ddd;
            border-radius: 8px;
            box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .simple-style input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .simple-style button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <div>
                <div>
                    비밀번호 입력 : <input v-model="pwd" type="password">
                </div>
                <div>
                    비밀번호 확인 : <input v-model="pwdConfirm" type="password">
                </div>
                <div>
                    <button @click="fnReMakePwd">비밀번호 변경</button>
                </div>
            </div>

        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const userCode = "imp63178561";
        IMP.init(userCode);
        const app = Vue.createApp({
            data() {
                return {
                    userId: "",
                    pwd: "",
                    pwdConfirm: "",
                    
                };
            },
            methods: {
                fnReMakePwd() {
                    var self = this;
                    if (self.pwd != self.pwdConfirm) {
                        alert("비밀번호 입력");
                    }
                    var nparmap = {
                        userId: self.userId,
                        pwd: self.pwd
                    };
                    $.ajax({
                        url: "/user/user-reMakePwd.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
                                alert("변경 성공");
                                location.href = "/user/user-login.do";
                            } else {
                                alert("변경 실패");
                            }
                        }
                    });
                },

            },
            mounted() {
                var self = this;
            }
        });
        app.mount('#app');
    </script>