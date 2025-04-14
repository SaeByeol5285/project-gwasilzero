<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page session="true" %>
    <%
        String sessionStatus = (String) session.getAttribute("sessionStatus");
        if (sessionStatus == null || !"ADMIN".equals(sessionStatus)) {
    %>
        <script>
            alert("권한이 없습니다.");
            location.href = "<%=request.getContextPath()%>/common/main.do";
        </script>
    <%
            return;
        }
    %>   
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
	      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
	<link rel="stylesheet" href="/css/admin-style.css">
</head>
<body>
    <div class="header-container">
        <div class="logo-area">
            <a href="/common/main.do" class="logo">
                <img src="/img/logo1.png" alt="로고 이미지" />
            </a>
        </div>
        <div class="user-info">
            <div class="page-title">관리자페이지</div>
            <div class="session-id">${sessionId}님</div>
        </div>
    </div>
    <div class="layout">
        <!-- 사이드바 -->        
        <div class="sidebar">            
            <button onclick="fnPageMove('main')" class="${currentPage == 'main' ? 'active' : ''}">관리자 메인</button>
            <button onclick="fnPageMove('user')" class="${currentPage == 'user' ? 'active' : ''}">회원 관리</button>
            <button onclick="fnPageMove('lawyer')" class="${currentPage == 'lawyer' ? 'active' : ''}">변호사 관리</button>
            <button onclick="fnPageMove('report')" class="${currentPage == 'report' ? 'active' : ''}">게시글 관리</button>
            <button onclick="fnPageMove('chart')" class="${currentPage == 'chart' ? 'active' : ''}">통계 자료</button>
            <button onclick="fnPageMove('product')" class="${currentPage == 'product' ? 'active' : ''}">상품 관리</button>
    
            <button onclick="fnLogOut()" class="logout">Logout</button>
        </div>
        <!-- 오른쪽 content는 각 JSP에서 직접 작성 -->
   
</body>
</html>
<script>
    function fnPageMove(page) {
        location.href = "/admin/" + page + ".do?page=" + page;
    }

    function fnLogOut() {
        $.ajax({
            url: "/user/logout.dox",
            type: "POST",
            dataType: "json",
            success: function (data) {
                if (data.result === "success") {
                    Swal.fire({
                        icon: "success",
                        title: "로그아웃 되었습니다.",
                        confirmButtonColor: "#ff5c00"
                    }).then(() => {
                        location.href = "/common/main.do";
                    });
                } else {
                    Swal.fire({
                        icon: "error",
                        title: "로그아웃 실패",
                        text: "잠시 후 다시 시도해주세요.",
                        confirmButtonColor: "#ff5c00"
                    });
                }
            },
            error: function () {
                Swal.fire({
                    icon: "error",
                    title: "요청 오류",
                    text: "로그아웃 요청 중 오류가 발생했습니다.",
                    confirmButtonColor: "#ff5c00"
                });
            }
        });
    }
</script>