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
		<div> 제목 : <input v-model="title">
			<label>사고 유형 선택:</label>
			  <select v-model="selectedCategory">
			    <option disabled value="">-- 선택하세요 --</option>
			    <option v-for="cat in categoryList" :key="cat.value" :value="cat.value">
			      {{ cat.label }}
			    </option>
			  </select>
		</div>
		<div style="width: 700px; height: 400px;">
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
	<jsp:include page="../common/footer.jsp"/>
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
				statusMessage: "",
				categoryList: [
					{ value: "01", label: "신호위반 사고" },
					{ value: "02", label: "비보호 좌회전 중 사고" },
					{ value: "03", label: "황색 신호위반 사고" },
					{ value: "04", label: "일방통행 위반 사고" },
				    { value: "05", label: "중앙선 침범 사고" },
					{ value: "06", label: "좌회전(또는 유턴)중 사전 중앙선침범 사고" },
					{ value: "07", label: "주정차 차량을 피하여 중앙선 침범한 사고" },
					{ value: "08", label: "고속도로 또는 자동차 전용도로에서 후진 사고" },
					{ value: "09", label: "우천 시 감속운행 위반 사고" },
				],
				selectedCategory: ""
            };
        },
        methods: {
			fnPixelizer : function(){
				var self = this;
				
				var self = this;
					if (self.selectedCategory === "") {
						alert("사고 유형을 선택해주세요.");
						return;
					}
					if (!self.title || !self.contents) {
						alert("제목과 내용을 모두 입력해주세요.");
						return;
					}
					if ($("#file1")[0].files.length === 0) {
						alert("파일을 선택해주세요.");
						return;
					}
				
				var form = new FormData();
				//form.append( "file1",  $("#file1")[0].files[0] );
				for(let i = 0; i <  $("#file1")[0].files.length; i++){
					form.append( "file1",  $("#file1")[0].files[i]);
					console.log($("#file1")[0].files.length);
				}
				form.append("title", self.title);
				form.append("contents", self.contents);
				form.append("category", self.selectedCategory);
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