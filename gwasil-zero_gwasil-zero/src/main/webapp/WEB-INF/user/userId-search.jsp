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
        <title>아이디 찾기</title>
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
                <h2>아이디 찾기</h2>
                <input v-model="user.name" placeholder="이름 입력">
                <input v-model="user.phone" placeholder="핸드폰 번호 입력">
                <button @click="requestCert()" style="margin-bottom: 10px;">인증하기</button>
                <button @click="fnSearchId">아이디 찾기</button>
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
                        name: "", phone: "", userId: ""
                    },
                    authNum: "",
                    authInputNum: "",
                    count: 180,
                    foundUserId: "",
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

                fnSearchId() {
                    var self = this;
                    $.ajax({
                        url: "/user/findId",
                        type: "POST",
                        data: { name: self.user.name, phone: self.user.phone },
                        success: function (data) {
                            if (data.status === "success") {
                                self.foundUserId = data.userId;
                                self.showPopup = true; // 팝업 활성화
                            } else {
                                alert("아이디 찾기 실패");
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