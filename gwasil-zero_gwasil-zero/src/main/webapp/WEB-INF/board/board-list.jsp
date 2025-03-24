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
	<div id="app">
		<div> 제목 : <input v-model="title"> </div>
		<div style="width: 500px; height: 300px;">
			<div id="editor"><textarea v-model="contents" style="width:500px; height:300px"></textarea></div>
		</div>
		<div><input type="file" id="file1" name="file1" accept=".jpg,.png,.mp4,.mov,.avi" multiple></div>
		<div>
		       <button @click="fnPixelizer" :disabled="isLoading">
		           {{ isLoading ? '처리 중...' : '모자이크 처리 및 등록' }}
		       </button>
		       <div v-if="statusMessage">{{ statusMessage }}</div>
		   </div>
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : [],
				title : "",
				contents : "",
				isLoading: false,
				statusMessage: ""
            };
        },
        methods: {
			fnPixelizer : function(){
				var self = this;
				var form = new FormData();
				//form.append( "file1",  $("#file1")[0].files[0] );
				for(let i = 0; i <  $("#file1")[0].files.length; i++){
					form.append( "file1",  $("#file1")[0].files[i]);
					console.log($("#file1")[0].files.length);
				}
				form.append("title", self.title);
				form.append("contents", self.contents);
				self.isLoading = true;
				self.statusMessage = "업로드 및 모자이크 처리 중입니다... 잠시만 기다려주세요";
				self.upload(form);  
			},
			// 파일 업로드
			upload : function(form){
				var self = this;
				$.ajax({
					url : "/board/fileUpload.dox"
					, type : "POST"
					, processData : false
					, contentType : false
					, data : form
					, success: function(response) {
						self.statusMessage = "모자이크 처리가 완료되었습니다!";
						self.isLoading = false;
					},
					error: function(err) {
						self.statusMessage = "업로드 실패.";
						self.isLoading = false;
					}
           
				});
			},
			
        },
		mounted() {
			var self = this;
		}  
    });
    app.mount('#app');
</script>