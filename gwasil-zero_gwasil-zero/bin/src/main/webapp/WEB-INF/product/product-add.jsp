<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("currentPage", "product");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 등록</title>

	<!-- 라이브러리 -->
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<!-- 스타일 정리 -->
	<style>
		.form-wrapper {
			max-width: 600px;
			margin: 40px auto;
			padding: 30px;
			background: #fff;
			border-radius: 10px;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
		}

		.form-title {
			text-align: center;
			font-size: 24px;
			font-weight: bold;
			color: #333;
			margin-bottom: 30px;
		}

		.form-group {
			margin-bottom: 20px;
		}

		.form-group label {
			display: block;
			margin-bottom: 6px;
			font-weight: bold;
			color: #555;
		}

		.input-box {
			width: 100%;
			padding: 10px;
			border: 1px solid #ddd;
			border-radius: 6px;
			font-size: 14px;
		}

		.textarea-box {
			min-height: 100px;
			resize: vertical;
			line-height: 1.5;
		}

		.btn-area {
			text-align: center;
			margin-top: 30px;
		}

		.btn-submit {
			padding: 10px 30px;
			background-color: #ff5c00;
			color: white;
			border: none;
			border-radius: 5px;
			font-size: 14px;
			cursor: pointer;
			font-weight: bold;
			transition: background-color 0.2s ease;
		}

		.btn-submit:hover {
			background-color: #e55300;
		}

		.btn-cancel {
			padding: 10px 30px;
			background-color: #ccc;
			color: #333;
			border: none;
			border-radius: 5px;
			font-size: 14px;
			cursor: pointer;
			font-weight: bold;
			transition: background-color 0.2s ease;
			margin-left: 10px;
		}
		.btn-cancel:hover {
			background-color: #bbb;
		}
	</style>
</head>
<body>
<div id="productApp" class="layout">
	<jsp:include page="../admin/layout.jsp" />

	<div class="content">
		<div class="header">
			<div>상품 등록</div>
			<div>Admin님</div>
		</div>

		<div class="form-wrapper">
			<div class="form-title">패키지 정보 입력</div>

			<div class="form-group">
				<label>패키지 명</label>
				<input type="text" v-model="packageName" class="input-box">
			</div>

			<div class="form-group">
				<label>패키지 설명</label>
				<textarea v-model="packageInfo" rows="3" class="input-box textarea-box"></textarea>
			</div>

			<div class="form-group">
				<label>패키지 가격</label>
				<input type="text" v-model="packagePrice" class="input-box">
			</div>

			<div class="form-group">
				<label>사용자</label>
				<select v-model="packageStatus" class="input-box">
					<option value="U">일반 사용자용</option>
					<option value="L">변호사용</option>
				</select>
			</div>

			<div class="btn-area">
				<button @click="fnSave" class="btn-submit">등록</button>
				<button @click="fnBack" class="btn-cancel">뒤로가기</button>
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
				const self = this;

				Swal.fire({
					title: '정말 등록하시겠습니까?',
					icon: 'question',
					showCancelButton: true,
					confirmButtonText: '등록',
					cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						let nparmap = {
							packageName: self.packageName,
							packageInfo: self.packageInfo,
							packagePrice: self.packagePrice,
							packageStatus: self.packageStatus
						};

						$.ajax({
							url: "/admin/product/add.dox",
							type: "POST",
							dataType: "json",
							data: nparmap,
							success: function (data) {
								if (data.result === "success") {
									Swal.fire("등록 완료", "상품이 등록되었습니다.", "success")
										.then(() => {
											location.href = "/admin/product.do";
										});
								} else {
									Swal.fire("등록 실패", "데이터 저장에 실패했습니다.", "error");
								}
							},
							error: function () {
								Swal.fire("서버 오류", "관리자에게 문의해주세요.", "error");
							}
						});
					}
				});
			},

			fnBack() {
				location.href = "/admin/product.do?page=product";
			}

		}
	});
	productApp.mount('#productApp');
</script>
</body>
</html>
