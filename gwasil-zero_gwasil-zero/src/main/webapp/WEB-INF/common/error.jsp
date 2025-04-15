<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>서비스 작업 중</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                position: relative;
            }

            .container {
                text-align: center;
                background-color: #fff;
                padding: 50px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 600px;
                position: absolute;
                z-index: 20;
                /* 컨텐츠가 차 위에 오게 하도록 z-index 추가 */
            }

            h1 {
                font-size: 48px;
                color: #FF5722;
            }

            p {
                font-size: 18px;
                color: #555;
                margin-bottom: 30px;
            }

            .button {
                padding: 12px 20px;
                font-size: 16px;
                background-color: #FF5722;
                color: #fff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            .button:hover {
                background-color: #FF7043;
            }

            /*  자동차 주행 도로 */
            .car-road {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 250px;
                /* 차 크기와 동일하게 도로 높이 설정 */
                overflow: hidden;
                z-index: 10;
            }

            .car {
                position: absolute;
                left: 100%;
                bottom: 0;
                width: 250px;
                /* 차 크기 250px로 설정 */
                pointer-events: none;
                animation: drive-left 4s linear infinite;
            }

            @keyframes drive-left {
                0% {
                    left: 100%;
                    /* 차가 화면의 오른쪽 끝에서 시작 */
                }

                100% {
                    left: -250px;
                    /* 차가 화면 밖으로 완전히 나가도록 설정, 차 크기에 맞게 -250px */
                }
            }
        </style>
    </head>

    <body>
        <!-- 서비스 작업 중 메시지 영역 -->
        <div class="container">
            <h1>현재 서비스 작업 중입니다.</h1>
            <p>다음에 다시 접속해주세요.</p>
            <p>불편을 드려 죄송합니다.</p>
            <button class="button" onclick="window.location.href='/common/main.do'">돌아가기</button>
        </div>

        <!-- 자동차 주행 영역 -->
        <div class="car-road" id="car-road"></div>

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

                // 랜덤으로 자동차 이미지 선택
                car.src = carImages[Math.floor(Math.random() * carImages.length)];
                car.className = 'car';

                road.appendChild(car);

                // 애니메이션이 끝날 때 차를 제거하는 대신 무한 반복으로 처리
                car.addEventListener('animationiteration', () => {
                    car.remove();
                    setTimeout(spawnCarSequentially, 1000); // 1초 뒤 새로운 차가 등장
                });
            }

            window.addEventListener("load", () => {
                spawnCarSequentially(); // 최초 시작
            });
        </script>
    </body>

    </html>