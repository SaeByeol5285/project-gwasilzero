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
    <header>
        <div id="header">
            <nav class="main-nav">
                <a href="/" class="logo">
                    <img src="/img/logo1.png" alt="로고 이미지">
                </a>
                <ul class="main-menu">
                    <li class="menu-item" v-for="(item, index) in menuItems" :key="index" 
                        @mouseover="showDropdown()" @mouseleave="hideDropdown()">
                        <a href="#" class="menu-font">{{ item }}</a>
                      
                    </li>
                    <li class="menu-item" v-if="sessionStatus == 'A'">
                        <a href="#">관리자 페이지</a>
                    </li>
                </ul>
            </nav>
            <div class="dropdown-item-back" :class="{ show: showDropdownMenu }" @mouseover="showDropdown()" @mouseleave="hideDropdown()">
                <template v-for="index in 6">
                    <div class="dropdown-item" :style="{ right: fnRight(index-1) + '%' }">
                        <ul>
                            <li v-for="(sub, i) in sections[6-index]" :key="i">
                                <a href="#">{{ sub }}</a>
                            </li>
                        </ul>
                    </div>
                </template>
            </div>
        </div>
    </header>
</body>
</html>

<script>
    const header = Vue.createApp({
        data() {
            return {
                menuItems: [
                    '회사 소개',
                    '상품 소개',
                    '구성원',
                    '게시판',
                    '통합 자료실',
                    '로그인',
                ],
                sections: [
                    [],
                    ['패키지 소개', '물품 소개'],
                    ['소속 변호사', '개인 변호사'],
                    [],
                    ['공지사항', 'Q & A', '사건 종류 가이드'],
                    ['로그인', '회원가입'],
                    []
                ],
                showDropdownMenu: false
            }
        },
        methods: {
            fnRight(index) {
                return 9.5 * index;
            },
            showDropdown() {
                this.showDropdownMenu = true;
            },
            hideDropdown() {
                this.showDropdownMenu = false;
            }
        },
        mounted() {}
    });
    header.mount('#header');
</script>
