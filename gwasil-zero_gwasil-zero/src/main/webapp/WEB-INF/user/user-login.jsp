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
            max-width: 120px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .social-login img {
            max-height: 100%;
            object-fit: contain;
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
        <button @click="fnLogin">로그인</button>

        <div class="social-login">
            <a href="javascript:void(0);" @click="naverLoginClick">
                <img src="/img/naver_login.png" alt="네이버 로그인">
            </a>
            <a :href="location">
                <img src="/img/kakao_login.png" alt="카카오 로그인">
            </a>
            <div id="g_id_onload"
                data-client_id="606230365694-v2t4tbt827hirorfu70f73j7mhq2t3cv.apps.googleusercontent.com"
                data-context="signin"
                data-ux_mode="redirect"
                data-login_uri="http://localhost:8080/common/main.do"
                data-auto_prompt="false">
            </div>
            <div class="g_id_signin"
                data-type="standard"
                data-shape="rectangular"
                data-theme="outline"
                data-text="signin_with"
                data-size="large"
                data-logo_alignment="left">
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
                $.post("/user/user-login.dox", { id: this.id, pwd: this.pwd }, function (res) {
                    if (res.result === "success") {
                        alert("로그인 성공");
                        location.href = "/common/main.do";
                    } else {
                        alert("로그인 실패");
                    }
                });
            },
            naverLoginClick() {
                $("#naverIdLogin_loginButton").click();
            }
        }
    });
    app.mount("#app");

    const naverLogin = new naver.LoginWithNaverId({
        clientId: "cHypMXQZj5CCSV0ShBQl",
        callbackUrl: "http://localhost:8080/user/login.do",
        isPopup: false,
        callbackHandle: true
    });
    naverLogin.init();
</script>

</html>
