<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <title>비밀번호 찾기</title>
    </head>
    <style>
        #app {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 70vh;
            /* 전체 높이의 70%만 차지하게 설정 */
            padding: 20px;
        }

        .form-section {
            width: 100%;
            max-width: 400px;
            background: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #FF5722;
            margin-bottom: 20px;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            border: 2px solid #e5e7eb;
            border-radius: 5px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #FF5722;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #FF5722;
        }
    </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <div class="form-section">
                <h2>비밀번호 찾기</h2>
                <input v-model="user.userId" placeholder="아이디 입력">
                <button @click="fnSmsAuth" style="margin-bottom: 10px;">인증 요청</button>
                <button @click="fnSearchPwd">비밀번호 찾기</button>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>

        IMP.init("imp29272276");
        const app = Vue.createApp({
            data() {
                return {
                    user: {
                        phone: "", userId: ""
                    },
                    authNum: "",
                    authInputNum: "",
                    timer: "",
                    count: 180,
                    foundUserPwd: "",
                    showPopup: false
                };
            },
            methods: {
                requestCert() {
                    IMP.certification({
                        channelKey: "channel-key-5164809c-6049-4ea1-9145-89fdfd4b17f4",
                        merchant_uid: "test_m83tgrb2",
                        min_age: 15,
                        name: "",
                        phone: "",
                        carrier: "",
                        company: "",
                        m_redirect_url: "",
                        popup: false,
                    });
                },
                fnSearchPwd() {
                    location.href="/user/reMakePwd.do"
                }
            },
            mounted() {
                console.log('Vue instance mounted');
            }
        });
        app.mount('#app');
    </script>
    ​