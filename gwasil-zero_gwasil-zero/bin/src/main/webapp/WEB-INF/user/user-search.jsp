<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
				      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
        <style>
            #app {
                display: flex;
                flex-direction: column;
                /* 세로 정렬 */
                justify-content: center;
                align-items: center;
                min-height: 70vh;
                padding: 20px;
            }

            h1 {
                text-align: center;
                width: 100%;
                /* 전체 너비 확보 */
                margin-bottom: 40px;
                /* 카드와의 간격 확보 */
                font-size: 28px;
                font-weight: bold;
                color: #FF5722;
            }

            .card-container {
                display: flex;
                gap: 30px;
                /* 카드 간 간격 확장 */
                max-width: 600px;
                /* 최대 너비 확장 */
                width: 100%;
                margin: 0 auto;
                /* 중앙 정렬 */
            }

            .card {
                flex: 1;
                background-color: #FFFFFF;
                border: 2px solid #FF5722;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                text-align: center;
                padding: 40px;
                /* 카드 내부 패딩 증가 */
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .card:hover {
                background-color: #ff5c00;
                color: #ffffff;
                transform: scale(1.05);
            }

            .title {
                font-size: 24px;
                /* 폰트 크기 확장 */
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h1>아이디/비밀번호 찾기</h1>
            <div class="card-container">
                <div class="card" @click="fnFindId">
                    <div class="title">아이디 찾기</div>
                </div>
                <div class="card" @click="fnFindPwd">
                    <div class="title">비밀번호 찾기</div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />

    </body>

    </html>
    <script>
        const app = Vue.createApp({
            methods: {
                fnFindId() {
                    location.href = "/user/userId-search.do";
                },
                fnFindPwd() {
                    location.href = "/user/userPwd-search.do";
                }
            }
        });
        app.mount('#app');
    </script>