<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"
	            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>board-add</title>
	
</head>
<style>
</style>
<body>
	<jsp:include page="../common/header.jsp"/>
	<div id="app">
		
	</div>
	<jsp:include page="../common/footer.jsp"/>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : [],
				checked : false,
				keyword : "",
				searchOption : "all",  //변호사랑 사건으로 구분
				pageSize: 5,
				page: 1,  //현재페이지
				index : 0  //하단에 보여줄 숫자
            };
        },
        methods: {
			fnBoardList : function(){
				var self = this;
				var nparmap = {
					keyword : self.keyword, 
					searchOption : self.searchOption,
					pageSize : self.pageSize, 
					page : (self.page - 1) * self.pageSize
				};
				$.ajax({
					url:"/board/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						self.list = data.list;
						self.index = Math.ceil(data.count / self.pageSize); 
					}
				});
				
			},
			
			
        },
		mounted() {
			var self = this;
			self.fnBoardList();
		}  
    });
    app.mount('#app');
</script>