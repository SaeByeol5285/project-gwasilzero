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
        <script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
        <title>로그인</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
            }

            #app {
                width: 400px;
                margin: 50px auto;
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
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
            }

            .social-login {
                display: flex;
                justify-content: space-between;
                gap: 10px;
                margin-top: 20px;
            }

            .social-login a {
                flex: 1;
                max-width: 180px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .social-login img {
                max-height: 100%;
                object-fit: contain;
            }

            .naver-logout {
                margin-top: 10px;
                font-size: 14px;
                color: #888;
                text-decoration: underline;
            }

            .extra-links {
                margin-top: 20px;
                font-size: 14px;
            }

            .extra-links a {
                margin: 0 10px;
                color: #555;
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <h1>로그인</h1>
            <div>
                <label>아이디</label>
                <input v-model="id" placeholder="아이디 입력">
            </div>
            <div>
                <label>비밀번호</label>
                <input v-model="pwd" type="password" placeholder="비밀번호 입력" @keyup.enter="fnLogin">
            </div>
            <div>
                <button @click="fnLogin">로그인</button>
            </div>

            <div class="social-login">
                <a href="javascript:void(0);" @click="naverLoginClick">
                    <img src="/img/naver_login.png" alt="네이버 로그인">
                </a>
                <a :href="location">
                    <img src="/img/kakao_login.png" alt="카카오 로그인">
                </a>
            </div>
            <div class="extra-links">
                <a href="/user/search.do">아이디/비밀번호 찾기</a>>
                <a href="/join/select.do">회원가입</a>
            </div>

            <a id="naverIdLogin_loginButton" href="javascript:void(0)" style="display: none;"></a>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </body>

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
                    const self = this;
                    $.ajax({
                        url: "/user/user-login.dox",
                        type: "POST",
                        data: { id: self.id, pwd: self.pwd },
                        dataType: "json",
                        success: function (res) {
                            if (res.result === "success") {
                                alert("로그인 성공");
                                location.href = "/common/main.do";
                            } else {
                                alert("로그인 실패");
                            }
                        }
                    });
                },
                kakaoLoginCallback(code) {
                    console.log("✅ 인가 코드 받음:", code);
                    $.ajax({
                        url: "/kakao.dox",
                        type: "POST",
                        data: { code: code },
                        success: function (res) {
                            console.log("카카오 세션 설정 성공:", res);
                            location.href = "/common/main.do";
                        },
                        error: function () {
                            alert("카카오 로그인 실패");
                        }
                    });
                },
                naverLoginClick() {
                    document.getElementById("naverIdLogin_loginButton").click();
                },
                handleNaverCallback() {
                    setTimeout(() => {
                        naverLogin.getLoginStatus(function (status) {
                            if (status) {
                                const user = naverLogin.user;
                                const email = user.getEmail();
                                const name = user.getName();
                                const id = user.getId();
                                if (!email) {
                                    alert("이메일 정보가 필요합니다. 다시 동의해주세요.");
                                    naverLogin.reprompt();
                                    return;
                                }
                                $.ajax({
                                    url: "/user/naver-session.dox",
                                    type: "POST",
                                    data: { email, name, id },
                                    success: function () {
                                        location.href = "/common/main.do";
                                    },
                                    error: function () {
                                        alert("네이버 세션 설정 실패");
                                    }
                                });
                            }
                        });
                    }, 300); // 네이버 초기화 후 약간의 딜레이 주기
                }
            },
            mounted() {
                const code = new URLSearchParams(window.location.search).get("code");
                if (code) {
                    this.kakaoLoginCallback(code);
                } else {
                    // 네이버 자동 로그인 처리
                    if (window.location.href.includes("login.do")) {
                        this.handleNaverCallback();
                    }
                }
            }
        });

        const vm = app.mount("#app");

        const naverLogin = new naver.LoginWithNaverId({
            clientId: "cHypMXQZj5CCSV0ShBQl",
            callbackUrl: "http://localhost:8080/user/login.do",
            isPopup: false,
            callbackHandle: true // 네이버에서 인가코드 받을 때 필요
        });
        naverLogin.init();
    </script>

    </html>