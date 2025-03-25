<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/header.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
        <title>header.jsp</title>
    </head>

    <body>
        <div id="header">
            <header>
                <!-- 상단 로그인 / 고객센터 라인 -->
                <div class="header-line">
                    <a href="#">고객만족센터</a>
                    <a href="/user/login.do">로그인 / 회원가입</a>
                </div>

                <!-- 네비게이션 바 -->
                <nav class="main-nav-wrapper">
                    <div class="main-nav">
                        <!-- 로고 -->
                        <a href="/common/main.do" class="logo">
                            <img src="/img/logo1.png" alt="로고 이미지">
                        </a>

                        <!-- 메뉴 -->
                        <ul class="main-menu">
                            <li class="menu-item" v-for="(item, index) in menuItems" :key="index">
                                <a :href="item.url" class="menu-font">{{ item.name }}</a>
                                <div class="dropdown" v-if="sections[index] && sections[index].length">
                                    <ul>
                                        <li v-for="(sub, i) in sections[index]" :key="i">
                                            <a href="#">{{ sub }}</a>
                                        </li>
                                    </ul>
                                </div>
                            </li>
                            <li class="menu-item" v-if="sessionStatus == 'A'">
                                <a href="#" class="menu-font">관리자 페이지</a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>
        </div>
    </body>

    </html>

    <script>
        const header = Vue.createApp({
            data() {
                return {
                    sessionStatus: 'A',
                    menuItems: [
                        { name: '회사 소개', url: '/common/introduce.do' },
                        { name: '상품 소개', url: '' },
                        { name: '구성원', url: '' },
                        { name: '게시판', url: '' },
                        { name: '통합 자료실', url: '' }
                    ],
                    sections: [
                        [],
                        ['패키지 소개', '물품 소개'],
                        ['소속 변호사', '개인 변호사'],
                        [],
                        ['공지사항', 'Q & A', '사건 종류 가이드']
                    ]
                }
            },
            mounted() { }
        });
        header.mount('#header');
    </script>