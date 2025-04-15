<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
	      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
</head>
<style>
</style>
<body>
	<div id="app">
		{{list}}
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : [],
				sessionId : "${sessionScope.sessionId}"
				
            };
        },
        methods: {
            fnGetBookmarkList(){
				var self = this;
				var nparmap = {sessionId : self.sessionId};
				$.ajax({
					url:"/bookmark/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
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
			self.fnGetBookmarkList();
        }
    });
    app.mount('#app');
</script>
​