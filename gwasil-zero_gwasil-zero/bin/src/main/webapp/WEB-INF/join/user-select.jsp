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
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
		      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
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
                /* 타이틀과 카드 사이 여백 추가 */
            }

            .card-container {
                display: flex;
                gap: 30px;
                /* 카드 간 간격 넓힘 */
                max-width: 800px;
                /* 최대 너비 확장 */
                width: 100%;
            }

            .card {
                flex: 1;
                background-color: #FFCCBC;
                border: 2px solid #FF5722;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                text-align: center;
                padding: 40px;
                /* 카드 내부 패딩 증가 */
                cursor: pointer;
                transition: background-color 0.3s ease, color 0.3s ease, transform 0.2s ease;
            }

            .card:hover {
                background-color: #FF5722;
                color: #ffffff;
                transform: scale(1.05);
            }

            .title {
                font-size: 24px;
                /* 제목 크기 키움 */
                font-weight: bold;
                margin-bottom: 12px;
            }

            p {
                font-size: 16px;
                /* 문구 크기 키움 */
                color: #FF5722;
                transition: color 0.3s ease;
            }

            .card:hover p {
                color: #ffffff;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <link rel="stylesheet" href="/css/common.css">
        <div id="app">
            <h1>회원가입</h1>
            <div class="card-container">
                <div class="card" @click="fnUserJoin">
                    <div class="title">사용자</div>
                    <p>교통사고 해결을 위한 변호사를 찾고,<br>법률 지원을 받아보세요!</p>
                </div>
                <div class="card" @click="fnLawyerJoin">
                    <div class="title">변호사</div>
                    <p>교통사고 피해자를 돕고,<br>법률 서비스를 제공하세요!</p>
                </div>
            </div>
        </div>
        <hr>
        <jsp:include page="../common/footer.jsp" />

    </body>

    </html>
    <script>
        const app = Vue.createApp({
            methods: {
                fnUserJoin() {
                    location.href = "/join/user-join.do";
                },
                fnLawyerJoin() {
                    location.href = "/join/lawyer-select.do";
                }
            }
        });
        app.mount('#app');
    </script>