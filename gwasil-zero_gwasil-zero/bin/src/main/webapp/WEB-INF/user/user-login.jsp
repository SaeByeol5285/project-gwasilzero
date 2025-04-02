<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/main.css">
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <title>로그인</title>
    </head>

    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }

        #app {
            width: 400px;
            margin: 50px auto;
        }

        h1 {
            font-size: 24px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            background-color: #FF5722;
            border: none;
            border-radius: 5px;
            font-size: 16px;
        }

        a {
            display: inline-block;
            margin: 10px;
            font-size: 14px;
            color: black;
            text-decoration: none;
        }

        .social-login {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .social-login a {
            display: inline-block;
            width: 130px;
            height: 40px;
        }

        .social-login img {
            width: 100%;
            height: 100%;
        }

        #app .link-container a {
            padding: 5px 15px;
            border: 2px solid #FF5722;
            border-radius: 20px;
            background-color: #fff5f0;
            color: #FF5722;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        #app .link-container a:hover {
            background-color: #FF5722;
            color: #ffffff;
        }

        #app button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            background-color: #FF5722;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            color: #fff;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        #app button:hover {
            background-color: #e64a00;
            transform: scale(1.05);
            /* 호버 시 약간 확대 */
        }

        #app button:active {
            transform: scale(0.95);
            /* 클릭 시 약간 눌리는 효과 */
        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp" />
        <link rel="stylesheet" href="/css/common.css">
        <div id="app">
            <h1>로그인</h1>
            <div>
                <label>아이디</label>
                <input v-model="id" placeholder="아이디를 입력해주세요">
            </div>
            <div>
                <label>비밀번호</label>
                <input v-model="pwd" type="password" placeholder="비밀번호를 입력해주세요">
            </div>
            <div>
                <button @click="fnLogin">로그인</button>
            </div>
            <div class="link-container">
                <a @click="fnJoin">회원가입</a>
                <a @click="searchUser">아이디/비밀번호 찾기</a>
            </div>
            <!-- <div>
                <a :href="location">
                    <img src="../img/naver_login.png">
                </a>
            </div> -->
            <div>
                <a :href="location">
                    <img src="../img/kakao_login.png">
                </a>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    id: "",
                    pwd: "",
                    location: "${location}"
                };
            },
            methods: {
                fnLogin() {
                    var self = this;
                    var nparmap = {
                        id: self.id,
                        pwd: self.pwd
                    };
                    $.ajax({
                        url: "/user/user-login.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
                                alert("로그인 성공");
                                location.href = "/common/main.do"
                            } else {
                                alert("아이디/비밀번호 확인해주세요");
                            }
                        }
                    });
                },
                fnJoin() {
                    location.href = "/join/select.do";
                },
                searchUser() {
                    location.href = "/user/search.do"; // 아이디/비밀번호 찾기 페이지
                }
            },
            mounted() {
                var self = this;
                console.log(this.location);
            }
        });
        app.mount('#app');
    </script>