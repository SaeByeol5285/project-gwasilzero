<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>약관 페이지</title>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f7f7f7;
                margin: 0;
                padding: 0;
            }

            .container {
                display: flex;
                width: 900px;
                margin: 50px auto;
            }

            .sidebar {
                display: flex;
                flex-direction: column;
                width: 200px;
            }

            .sidebar button {
                width: 180px;
                height: 50px;
                padding: 0 12px;
                margin-bottom: 8px;
                background-color: #FF5722;
                border: none;
                cursor: pointer;
                text-align: left;
                border-radius: 6px;
                font-size: 15px;
                color: #fff;
                transition: background 0.2s, transform 0.1s ease-in-out;
            }

            .sidebar button:hover {
                background-color: #ff8a66;
            }

            .sidebar button:active {
                transform: scale(0.95);
            }

            .sidebar button.active {
                background-color: #ff8a66;
                border: 2px solid #FF5722;
            }

            .content {
                width: 680px;
                height: 400px;
                background-color: #FFF3EE;
                padding: 25px;
                margin-left: 20px;
                border-radius: 6px;
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
                white-space: pre-line;
                overflow-y: auto;
            }

            .content h3 {
                margin-top: 0;
                color: #FF5722;
            }

            .fade-enter-active,
            .fade-leave-active {
                transition: opacity 0.4s ease-in-out;
            }

            .fade-enter-from,
            .fade-leave-to {
                opacity: 0;
            }

            .fade-in-up {
                animation: fadeInUp 0.6s ease forwards;
            }

            @keyframes fadeInUp {
                0% {
                    opacity: 0;
                    transform: translateY(30px);
                }

                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* 🚗 자동차 주행 도로 (배경   제거) */
            .car-road {
                position: relative;
                height: 100px;
                margin-top: 60px;
                overflow: hidden;
            }

            .car {
                position: absolute;
                left: 100%;
                bottom: 0px;
                /* ✅ 항상 같은 높이 */
                width: 80px;
                pointer-events: none;
                z-index: 10;
                animation: drive-left 6s linear forwards;
            }

            @keyframes drive-left {
                0% {
                    left: 100%;
                }

                100% {
                    left: -100px;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <div class="container fade-in-up">
                <div class="sidebar">
                    <button v-for="(item, idx) in list" :key="idx" :class="{ active: selectedIdx === idx }"
                        @click="selectedIdx = idx">
                        {{ item.title }}
                    </button>
                </div>

                <transition name="fade">
                    <div class="content" v-show="list.length > 0" :key="selectedIdx">
                        <h3>{{ list[selectedIdx].title }}</h3>
                        <p>{{ list[selectedIdx].contents }}</p>
                    </div>
                </transition>
            </div>

            <!-- 자동차 주행 영역 -->
            <div class="car-road" id="car-road"></div>
        </div>

        <jsp:include page="../common/footer.jsp" />

        <!-- Vue 앱 -->
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        selectedIdx: 0,
                        list: [
                            {
                                title: "이용약관",
                                contents: `제 1 조 (목적)
본 약관은 과실제로(이하 "회사")가 제공하는 모든 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.`
                            },
                            {
                                title: "개인정보처리방침",
                                contents: `회사는 「개인정보 보호법」 등 관련 법령에 따라 이용자의 개인정보를 보호하고, 관련한 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같은 방침을 두고 있습니다.

1. 수집 항목: 이름, 전화번호, 이메일 등
2. 이용 목적: 회원관리, 서비스 제공, 민원 처리 등
3. 보유 기간: 회원 탈퇴 시까지 또는 관련 법령에 따른 보존기간까지`
                            },
                            {
                                title: "서비스 이용 동의",
                                contents: `회원은 회사가 제공하는 서비스의 목적, 이용 조건, 정책 등에 동의한 것으로 간주되며 다음 행위를 해서는 안됩니다.

1. 타인의 정보 도용
2. 회사 시스템에 대한 침해 행위
3. 기타 부정행위`
                            },
                            {
                                title: "마케팅 수신 동의",
                                contents: `회원은 다음과 같은 내용에 대해 동의 여부를 선택할 수 있습니다.

1. 이벤트, 혜택 안내 등의 마케팅 목적 문자 및 이메일 발송
2. 서비스 품질 향상을 위한 설문조사 안내`
                            }
                        ]
                    }
                }
            });
            app.mount("#app");
        </script>

        <!-- 🚗 랜덤 자동차 순차 주행 스크립트 -->
        <script>
            const carImages = [
                '/img/suv-car.png',
                '/img/van-car.png',
                '/img/truck-car.png',
                '/img/sports-car.png'
            ];

            function spawnCarSequentially() {
                const road = document.getElementById('car-road');
                const car = document.createElement('img');

                car.src = carImages[Math.floor(Math.random() * carImages.length)];
                car.className = 'car';

                road.appendChild(car);

                car.addEventListener('animationend', () => {
                    car.remove();
                    setTimeout(spawnCarSequentially, 1000); // 다음 차는 1초 뒤 등장
                });
            }

            window.addEventListener("load", () => {
                spawnCarSequentially(); // 최초 시작
            });
        </script>
    </body>

    </html>