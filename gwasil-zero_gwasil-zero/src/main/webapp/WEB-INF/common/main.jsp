<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>main.jsp</title>
</head>
<style>
</style>
<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app">
		본문
	</div>
	<jsp:include page="../common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : []
				
            };
        },
        methods: {
            fnGetList(){
				var self = this;
				var nparmap = {};
				$.ajax({
					url:"/project/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						if(data.result == "success"){
							self.list = data.list;
						} else {
							alert("오류발생");
						}
					}
				});
            }
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>
​