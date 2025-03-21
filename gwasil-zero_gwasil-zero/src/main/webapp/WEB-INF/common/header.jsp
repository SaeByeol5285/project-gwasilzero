<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap" rel="stylesheet">
        <title>header.jsp</title>
        <link rel="stylesheet" href="/css/header.css">
        <style>
        </style>

    </head>

    <body>
        <div id="header">
            <header>
                <!-- 로고 -->
                <a href="/common/main.do" class="logo">
                    <img src="../../img/logo1.png" alt="과실제로 로고" class="logo">
                </a>

                <!-- 네비게이션 메뉴 -->
                <nav>
                    <ul>
                        <li class="dropdown">
                            <a class="link" class="bold" href="#">회사 소개</a>
                            <ul class="dropdown-menu">
                                <li><a href="#">비빔밥</a></li>
                                <li><a href="#">김치찌개</a></li>
                                <li><a href="#">불고기</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a class="link" href="#">상품 소개</a>
                            <ul class="dropdown-menu">
                                <li><a href="#">짜장면</a></li>
                                <li><a href="#">짬뽕</a></li>
                                <li><a href="#">마파두부</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a class="link" href="#">구성원</a>
                            <ul class="dropdown-menu">
                                <li><a href="#">피자</a></li>
                                <li><a href="#">파스타</a></li>
                                <li><a href="#">스테이크</a></li>
                            </ul>
                        </li>
                        <li><a class="link" href="#">게시판</a></li>
                        <li><a class="link" href="#">통합 자료실</a></li>
                    </ul>
                </nav>

                <!-- 검색 바 -->
                <div class="search-bar">
                    <input type="text" placeholder="상품을 검색하세요..." v-model="keyword">
                    <button @click="fnSearch">검색</button>
                </div>

                <!-- 로그인 버튼 -->
                <div class="login-btn">
                    <a href="/member/login.do"><button>로그인</button></a>
                </div>
            </header>
        </div>
    </body>

    </html>
    <script>
        const header = Vue.createApp({
            data() {
                return {
                    isOpen: false,
                };
            },
            methods: {
                toggleMenu() {
                    this.isOpen = !this.isOpen;
                },
            },
            mounted() {
                var self = this;
                self.fnGetList();
            }
        });
        app.mount('#app');
    </script>
    ​