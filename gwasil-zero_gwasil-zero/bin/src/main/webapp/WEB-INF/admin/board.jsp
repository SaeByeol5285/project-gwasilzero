<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<title>admin main</title>
</head>
<body>
    <div id="boardApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />
            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
                <h2>게시판 관리</h2>
            </div>
        </div>

    </div>  
</body>
</html>
<script>
    const boardApp = Vue.createApp({
        data() {
            return {

            };
        },
        methods: {
            
        },
        mounted() {
            var self = this;
            
        }
    });
    boardApp.mount('#boardApp');
</script>