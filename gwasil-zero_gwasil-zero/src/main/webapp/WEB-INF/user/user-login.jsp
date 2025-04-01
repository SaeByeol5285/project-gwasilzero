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

        #app a {
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

        }

        #app button:active {

            transform: scale(0.95);

        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp" />
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
                <button v-if="!sessionId" @click="fnLogin">로그인</button>
                <a v-else href="javascript:void(0);" @click="fnLogout">로그아웃</a>
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
                    sessionId: "${sessionId}",
                    id: "",
                    pwd: "",
                    userStatus: "",
                    location: "${location}"
                };
            },
            methods: {
                fnLogin() {
                    var self = this;
                    var nparmap = {
                        id: self.id,
                        pwd: self.pwd,
                        userStatus: self.userStatus
                    };
                    $.ajax({
                        url: "/user/user-login.dox", // 기존 로그인 요청을 활용
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
                                alert("로그인 성공");
                                location.href = "/common/main.do";
                            } else if (data.message === "탈퇴한 계정입니다. 계정을 복구하시겠습니까?") {
                                if (confirm("탈퇴한 계정입니다. 계정을 복구하시겠습니까?")) {
                                    self.fnRecoverAccount(self.id); // 계정 복구 요청
                                }
                            } else {
                                alert("아이디/비밀번호를 확인해주세요");
                            }
                        }
                    });
                },

                fnRecoverAccount(userId) {
                    var self = this;
                    $.ajax({
                        url: "/user/user-login.dox", // 같은 로그인 URL 사용
                        dataType: "json",
                        type: "POST",
                        data: {
                            id: userId,
                            recover: true // 복구 요청을 구분하기 위한 추가 데이터
                        },
                        success: function (data) {
                            if (data.result == "success") {
                                alert("계정이 복구되었습니다. 다시 로그인해주세요.");
                                // 계정 복구 후, 인풋 박스를 초기화
                                self.id = "";
                                self.pwd = "";
                            } else {
                                alert("계정 복구에 실패했습니다. 관리자에게 문의하세요.");
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
                console.log("sessionId" + this.sessionId);
            }
        });
        app.mount('#app');
    </script>