<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
	<title>admin sider</title>
	<link rel="stylesheet" href="../css/admin-style.css">
</head>
<body>
    <div id="app">
        <div class="sidebar">
            <button @click="fnPageMove('main')" :class="{ active: currentPage === 'main' }">
                관리자 메인</button>
            <button @click="fnPageMove('user')" :class="{ active: currentPage === 'user' }">
                회원 관리</button>
            <button @click="fnPageMove('lawyer')" :class="{ active: currentPage === 'lawyer' }">
                변호사 관리</button>
            <button @click="fnPageMove('board')" :class="{ active: currentPage === 'board' }">
                게시글 관리</button>
            <button @click="fnPageMove('chart')" :class="{ active: currentPage === 'chart' }">
                통계</button>
            <button @click="fnLogout">Logout</button>
        </div>
        <div class="content">
            <div class="header">관리자 페이지</div>
        </div>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                currentPage: "${currentPage}",
                sessionStatus : "${sessionStatus}"
            };
        },
        methods: {
            fnPageMove(page) {
                location.href = "/admin/" + page + ".do?page=" + page;
            },
            fnLogout() {
                location.href = "/logout";
            }
        },
        mounted() {
            let self = this;
            if (self.sessionStatus !== 'A') {
                alert("접근 권한이 없습니다.");
                window.location.href = "/member/login.do";
            }
        }
    });
    app.mount('#app');
</script>
