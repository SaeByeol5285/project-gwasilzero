<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
		      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <style>
            #app {
                display: flex;
                flex-direction: column;
                align-items: center;
                min-height: 70vh;
                padding: 20px;
            }

            h1 {
                color: #FF5722;
                margin-bottom: 30px;
            }

            .card-container {
                display: flex;
                gap: 30px;
                max-width: 800px;
                width: 100%;
            }

            .card {
                flex: 1;
                background-color: #FFE0B2;
                border: 2px solid #FF9800;
                border-radius: 12px;
                text-align: center;
                padding: 40px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .card:hover {
                background-color: #FF9800;
                color: white;
                transform: scale(1.05);
            }

            .title {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            p {
                font-size: 16px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <h1>변호사 유형을 선택해주세요</h1>
            <div class="card-container">
                <div class="card" @click="selectLawyer('I')">
                    <div class="title">소속 변호사</div>
                    <p>법률 사무소에 소속된 변호사입니다.</p>
                </div>
                <div class="card" @click="selectLawyer('P')">
                    <div class="title">개인 변호사</div>
                    <p>개인적으로 활동 중인 변호사입니다.</p>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />

        <!-- 🔥 Vue mount는 무조건 body 끝에 둘 것 -->
        <script>
            const app = Vue.createApp({
                methods: {
                    selectLawyer(status) {
                        location.href = "/join/lawyer-join.do?status=" + status;
                    }
                }
            });
            app.mount("#app");
        </script>

    </body>

    </html>