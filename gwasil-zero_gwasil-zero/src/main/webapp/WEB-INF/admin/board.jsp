<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>admin main</title>
</head>
<body>
    <jsp:include page="layout.jsp" />
    <div id="boardApp">
        <h2>게시판 관리 페이지</h2>

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
    app.mount('#boardApp');
</script>