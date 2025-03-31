<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <title>아이디 찾기</title>
    </head>

    <style>
        div.radio-group {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: flex-start;
        }

        input[type="radio"] {
            width: 20px;
            height: 20px;
            margin-right: 10px;
            cursor: pointer;
            appearance: none;
            border: 2px solid #e5e7eb;
            border-radius: 50%;
            background-color: #fff;
            transition: background-color 0.3s, border-color 0.3s;
        }

        input[type="radio"]:checked {
            background-color: #FF5722;
            border-color: #FF5722;
        }

        label {
            font-size: 16px;
            color: #333;
            margin-right: 20px;
            cursor: pointer;
        }

        input[type="radio"]:checked+label {
            color: #FF5722;
            font-weight: bold;
        }

        #app {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 70vh;
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
            background-color: #e64a19;
        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <div class="form-section">
                <h2>아이디 찾기</h2>

                <div class="radio-group">
                    <input type="radio" id="user" value="user" v-model="user.role">
                    <label for="user">일반 사용자</label>

                    <input type="radio" id="lawyer" value="lawyer" v-model="user.role">
                    <label for="lawyer">변호사</label>
                </div>

                <div>이름 : <input v-model="user.name" placeholder="이름 입력"></div>
                <div>핸드폰 번호 : <input v-model="user.phone" placeholder="핸드폰 번호 입력"></div>
                <button @click="requestCert()" style="margin-bottom: 10px;">인증하기</button>
                <button @click="fnSearchId">아이디 찾기</button>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </body>

    <script>
        IMP.init("imp29272276");

        const app = Vue.createApp({
            data() {
                return {
                    user: {
                        role: "",
                        name: "",
                        phone: "",
                    },
                    isAuthenticated: false,
                };
            },
            methods: {
                requestCert() {
                    IMP.certification({
                        channelKey: "channel-key-5164809c-6049-4ea1-9145-89fdfd4b17f4",
                        merchant_uid: "test_m83tgrb2",
                        min_age: 15,
                        name: this.user.name,
                        phone: this.user.phone,
                    });
                    this.isAuthenticated = true;
                },
                fnSearchId() {
                    var self = this;

                    if (!self.isAuthenticated) {
                        alert("먼저 본인 인증을 완료해주세요.");
                        return;
                    }

                    var nparmap = {
                        role: self.user.role,
                        name: self.user.name,
                        phone: self.user.phone
                    };

                    console.log("✅ 전송 데이터:", nparmap);

                    $.ajax({
                        url: "/user/userId-search.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log("✅ 서버 응답 데이터:", data);

                            // 로그로 디버깅
                            console.log("🟡 typeof data.userId:", typeof data.userId, "값:", data.userId);
                            console.log("🟡 typeof data.userName:", typeof data.userName, "값:", data.userName);

                            if (!data.userId || !data.userName) {
                                alert("❌ 서버에서 userId 또는 userName이 비어있습니다.");
                                return;
                            }

                            const userId = String(data.userId);
                            const userName = String(data.userName);
                            const role = self.user.role;

                            console.log("📦 role:", role);

                            const popupMessage =
                                role === "lawyer"
                                    ? `변호사님 ${userName}님의 아이디는 ${userId}입니다.`
                                    : `${userName}님의 아이디는 ${userId}입니다.`;

                            console.log("📨 최종 팝업 메시지:", popupMessage);

                            const popupWindow = window.open("", "_blank", "width=400,height=200");

                            if (popupWindow) {
                                popupWindow.document.open();
                                popupWindow.document.write("<!DOCTYPE html>");
                                popupWindow.document.write("<html><head>");
                                popupWindow.document.write("<meta charset='UTF-8'>");
                                popupWindow.document.write("<title>아이디 찾기</title>");
                                popupWindow.document.write("<style>body { font-family: sans-serif; padding: 20px; text-align: center; } h2 { color: #FF5722; }</style>");
                                popupWindow.document.write("</head><body>");
                                popupWindow.document.write("<h2>" + popupMessage + "</h2>");
                                popupWindow.document.write("</body></html>");
                                popupWindow.document.close();
                            } else {
                                alert("팝업 창이 차단되었습니다. 팝업을 허용해주세요.");
                            }
                        },
                        error: function () {
                            alert("❌ 서버 오류가 발생했습니다.");
                        }
                    });
                }
            },
            mounted() {
                console.log("Vue instance mounted");
            }
        });
        app.mount('#app');
    </script>

    </html>