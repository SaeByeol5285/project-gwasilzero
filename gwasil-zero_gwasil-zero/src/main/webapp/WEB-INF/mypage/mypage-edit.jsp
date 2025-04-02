<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>내 정보 수정</title>
        <style>
            #app {
                max-width: 500px;
                margin: 80px auto;
                font-family: Arial, sans-serif;
                font-size: 16px;
            }

            label {
                display: block;
                margin: 10px 0 5px;
            }

            input {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                width: 100%;
                padding: 12px;
                background-color: #FF5722;
                color: #fff;
                font-size: 16px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
            }

            button:hover {
                background-color: #e64a00;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h2>내 정보 수정</h2>
            <div>
                <label>이름</label>
                <input v-model="info.userName">
            </div>
            <div>
                <label>핸드폰 번호</label>
                <input v-model="info.userPhone">
            </div>
            <div>
                <label>이메일</label>
                <input v-model="info.userEmail">
            </div>
            <button @click="fnSave">저장</button>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    info: {}
                };
            },
            methods: {
                fnGetInfo() {
                    const self = this;
                    $.ajax({
                        url: "/mypage/mypage-view.dox",
                        type: "POST",
                        data: { sessionId: self.sessionId },
                        dataType: "json",
                        success: function (data) {
                            self.info = data.info;
                        }
                    });
                },
                fnSave() {
                    const self = this;
                    if (!self.info.userName || !self.info.userPhone || !self.info.userEmail) {
                        alert("모든 항목을 입력해주세요.");
                        return;
                    }
                    const nparmap = {
                        userId: self.sessionId,
                        userName: self.info.userName,
                        userPhone: self.info.userPhone,
                        userEmail: self.info.userEmail
                    };
                    $.ajax({
                        url: "/mypage/mypage-edit.dox",
                        type: "POST",
                        data: nparmap,
                        dataType: "json",
                        success: function (data) {
                            if (data.result === "success") {
                                alert("수정되었습니다!");
                                location.href = "/mypage-home.do";
                            } else {
                                alert("수정 실패: " + data.message);
                            }
                        }
                    });
                }
            },
            mounted() {
            }
        });
        app.mount("#app");
    </script>