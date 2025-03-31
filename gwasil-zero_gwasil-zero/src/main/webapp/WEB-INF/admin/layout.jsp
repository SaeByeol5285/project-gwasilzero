<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
	<title>admin sider</title>
	<link rel="stylesheet" href="/css/admin-style.css">
</head>
<body>
    <div class="layout">
        <!-- 사이드바 -->
        <div class="sidebar">
            <button onclick="fnPageMove('main')" class="${currentPage == 'main' ? 'active' : ''}">관리자 메인</button>
            <button onclick="fnPageMove('user')" class="${currentPage == 'user' ? 'active' : ''}">회원 관리</button>
            <button onclick="fnPageMove('lawyer')" class="${currentPage == 'lawyer' ? 'active' : ''}">변호사 관리</button>
            <button onclick="fnPageMove('board')" class="${currentPage == 'board' ? 'active' : ''}">게시글 관리</button>
            <button onclick="fnPageMove('chart')" class="${currentPage == 'chart' ? 'active' : ''}">통계</button>
            <button onclick="fnPageMove('product')" class="${currentPage == 'product' ? 'active' : ''}">상품 관리</button>
    
            <button onclick="fnLogOut()" class="logout">Logout</button>
        </div>
        <!-- 오른쪽 content는 각 JSP에서 직접 작성 -->
    </div>
</body>
</html>
<script>
    function fnPageMove(page) {
        location.href = "/admin/" + page + ".do?page=" + page;
    }

    function fnLogOut() {
        location.href = "/logout";
    }
</script>
