<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/main.css">
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
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
                box-sizing: border-box;
                font-size: 16px;
            }

            button {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                background-color: #ff5c00;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                box-sizing: border-box;
                transition: background-color 0.2s ease-in-out;
                /* 부드럽게 전환 */
            }

            button:hover {
                background-color: #ffece1;
                color: #ff5c00;
                /* 텍스트 색상도 반전하면 더 예쁨 */
            }

            .social-login {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 12px;
                margin-top: 20px;
            }

            .social-login img {
                height: 40px;
                width: 40px;
                cursor: pointer;
            }

            .social-login img:nth-child(2) {
                margin-left: 10px;
            }

            .g_id_signin {
                width: 40px !important;
                height: 40px;
                border-radius: 5px;
                margin: 0 !important;
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

            .form-group {
                text-align: left;
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <h1>로그인</h1>
            <div class="form-group">
                <label for="id">아이디</label>
                <input v-model="id" id="id" placeholder="아이디 입력">
            </div>
            <div class="form-group">
                <label for="pwd">비밀번호</label>
                <input v-model="pwd" id="pwd" type="password" placeholder="비밀번호 입력" @keyup.enter="fnLogin">
            </div>
            <div>
                <button @click="fnLogin">로그인</button>
            </div>

            <div class="social-login">
                <!-- 네이버 로그인 -->
                <img src="/img/naver-icon.png" alt="Naver" @click="naverLoginClick">

                <!-- 카카오 로그인 -->
                <img src="/img/kakao-icon.png" alt="Kakao" @click="kakaoLoginClick">

                <!-- 구글 로그인 -->
                <div id="g_id_onload"
                    data-client_id="606230365694-vdm0p79esdfp0rr0ipdpvrp0k8n44sig.apps.googleusercontent.com"
                    data-context="signin" data-ux_mode="redirect" data-login_uri="http://localhost:8080/googleCallback"
                    data-auto_prompt="false">
                </div>
                <div class="g_id_signin" data-type="icon" data-shape="square" data-theme="outline"
                    data-text="signin_with" data-size="large" data-logo_alignment="left">
                </div>
            </div>

            <div class="extra-links">
                <a href="/user/search.do">아이디/비밀번호 찾기</a>
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
                                Swal.fire({
                                    icon: "success",
                                    title: "로그인 성공",
                                    text: "환영합니다!",
                                    confirmButtonText: "확인"
                                }).then(() => {
                                    location.href = res.redirect || "/common/main.do"; // 리디렉션 URI 있으면(가이드라인에서 글쓰기)거기로, 없으면 메인
                                });
                            } else if (res.message && res.message.includes("탈퇴한 계정입니다")) {
                                Swal.fire({
                                    icon: "warning",
                                    title: "탈퇴한 계정입니다",
                                    text: "복구하시겠습니까?",
                                    showCancelButton: true,
                                    confirmButtonText: "복구하기",
                                    cancelButtonText: "취소"
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        $.ajax({
                                            url: "/user/user-login.dox",
                                            type: "POST",
                                            data: { id: self.id, pwd: self.pwd, recover: true },
                                            dataType: "json",
                                            success: function (res2) {
                                                if (res2.result === "success") {
                                                    Swal.fire({
                                                        icon: "success",
                                                        title: "복구 완료",
                                                        text: "계정이 복구되었습니다.",
                                                        confirmButtonText: "확인"
                                                    }).then(() => {
                                                        location.href = "/common/main.do";
                                                    });
                                                } else {
                                                    Swal.fire({
                                                        icon: "error",
                                                        title: "복구 실패",
                                                        text: "계정 복구에 실패했습니다.",
                                                        confirmButtonText: "확인"
                                                    });
                                                }
                                            }
                                        });
                                    }
                                });
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "로그인 실패",
                                    text: "아이디 또는 비밀번호를 확인해주세요.",
                                    confirmButtonText: "확인"
                                });
                                self.pwd = "";  // ✅ 비밀번호 초기화
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
                        success: function () {
                            location.href = "/common/main.do";
                        },
                        error: function () {
                            alert("카카오 로그인 실패");
                        }
                    });
                },
                kakaoLoginClick() {
                    window.location.href = this.location;
                },
                naverLoginClick() {
                    document.getElementById("naverIdLogin_loginButton").click();
                },
                googleLoginClick() {
                    const state = Math.random().toString(36).substr(2, 10);
                    const googleURL = "https://accounts.google.com/o/oauth2/v2/auth?" +
                        "client_id=606230365694-vdm0p79esdfp0rr0ipdpvrp0k8n44sig.apps.googleusercontent.com" +
                        "&redirect_uri=http://localhost:8080/googleCallback" +
                        "&response_type=code" +
                        "&scope=email%20profile" +
                        "&state=" + state +
                        "&access_type=offline" +
                        "&prompt=consent";
                    location.href = googleURL;
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
                    }, 300);
                }
            },
            mounted() {
                const code = new URLSearchParams(window.location.search).get("code");
                if (code) {
                    this.kakaoLoginCallback(code);
                } else {
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
            callbackHandle: true
        });
        naverLogin.init();
    </script>

    </html>