<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
				      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
        <style>
            #app {
                max-width: 500px;
                margin: 80px auto;
                font-family: 'Segoe UI', sans-serif;
                font-size: 16px;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }
        
            h2 {
                text-align: center;
                color: #444;
                margin-bottom: 30px;
            }
        
            label {
                display: block;
                margin: 10px 0 6px;
                font-weight: 600;
                color: #333;
            }
        
            .full-width {
                width: 100%;
                padding: 12px 14px;
                box-sizing: border-box;
                border: 1px solid #ddd;
                border-radius: 10px;
                background-color: #fdfdfd;
                transition: border-color 0.3s;
            }
        
            .full-width:focus {
                border-color: #ff7a3d;
                outline: none;
            }
        
            .save-button {
                width: 100%;
                padding: 14px;
                background-color: #ff7a3d;
                color: #fff;
                font-size: 16px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: bold;
                margin-top: 20px;
                transition: background-color 0.3s, box-shadow 0.3s;
            }
        
            .save-button:hover {
                background-color: #ff5a1a;
                box-shadow: 0 4px 10px rgba(255, 122, 61, 0.3);
            }
        </style>        
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h2>내 정보 수정</h2>
            <div>
                <label>이름</label>
                <input v-model="info.userName" class="full-width">
            </div>
            <div>
                <label>핸드폰 번호</label>
                <input v-model="info.userPhone" class="full-width">
            </div>
            <div>
                <label>이메일</label>
                <input v-model="info.userEmail" class="full-width">
            </div>
            <button @click="fnSave" class="save-button">저장</button>
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
                this.fnGetInfo();
            }
        });
        app.mount("#app");
    </script>