<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>상품 등록</title>
</head>
<body>
<div id="productApp" class="layout">
	<jsp:include page="../admin/layout.jsp" />
	
	<div class="content">
		<div class="header">
			<div>상품 등록</div>
			<div>Admin님</div>
		</div>

		<div class="box">
			<h3>패키지 정보 입력</h3>

			<div style="margin-bottom: 15px;">
				<label>패키지 이름</label><br>
				<input type="text" v-model="packageName" style="width: 100%; padding: 8px;">
			</div>

			<div style="margin-bottom: 15px;">
				<label>패키지 설명</label><br>
				<textarea v-model="packageInfo" rows="3" style="width: 100%; padding: 8px;"></textarea>
			</div>

			<div style="margin-bottom: 15px;">
				<label>패키지 가격</label><br>
				<input type="number" v-model="packagePrice" style="width: 100%; padding: 8px;">
			</div>

			<div style="margin-bottom: 15px;">
				<label>패키지 상태</label><br>
				<select v-model="packageStatus" style="width: 100%; padding: 8px;">
					<option value="U">일반 사용자용</option>
					<option value="L">변호사용</option>
				</select>
			</div>

			<div style="text-align: center;">
				<button @click="fnSave" style="padding: 10px 30px; background-color: #ff5c00; color: white; border: none; border-radius: 5px;">등록</button>
			</div>
		</div>
	</div>
</div>

<script>
	const productApp = Vue.createApp({
		data() {
			return {
				packageName: "",
				packageInfo: "",
				packagePrice: 0,
				packageStatus: "U"
			};
		},
		methods: {
			fnSave() {
				let self = this;
				let nparmap = {
					packageName : self.packageName,
					packageInfo : self.packageInfo,
					packagePrice : self.packagePrice,
					packageStatus : self.packageStatus
				}
				$.ajax({
					url: "/admin/product/add.dox",
					type: "POST",
					dataType: "json",
					data: nparmap,
					success: function (data) {
						if (data.result === "success") {
							alert("등록 완료!");
							location.href = "/admin/product.do";
						} else {
							alert("등록 실패");
						}
					},
					error: function () {
						alert("서버 오류");
					}
				});
			}
		}
	});
	productApp.mount('#productApp');
</script>
</body>
</html>
