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
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/common.css">
	<style>
		.form-wrapper {
			width: 1000px;
			margin: 40px auto;
			padding: 30px;
			background: #fff;
			border-radius: 10px;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
		}

		.form-title {
			font-size: 24px;
			font-weight: bold;
			margin-bottom: 30px;
			text-align: center;
			color: #333;
		}

		.form-table {
			width: 100%;
		}

		.form-table th {
			text-align: left;
			padding: 10px 0 10px 16px;
			color: #555;
			width: 130px;
			vertical-align: top;
		}

		.form-table td {
			padding: 10px 16px;
		}

		.input-box {
			width: 100%;
			box-sizing: border-box;
			padding: 10px;
			border: 1px solid #ddd;
			border-radius: 6px;
			font-size: 14px;
		}

		.textarea-box {
			resize: vertical;
			min-height: 100px;
			line-height: 1.5;
		}

		.btn-area {
			text-align: center;
			margin-top: 30px;
		}

		.btn {
			padding: 10px 24px;
			font-size: 14px;
			font-weight: bold;
			border: none;
			border-radius: 6px;
			cursor: pointer;
			margin: 0 8px;
		}

		.btn-save {
			background-color: #ff5c00;
			color: #fff;
		}

		.btn-save:hover {
			background-color: #e55300;
		}

		.btn-cancel {
			background-color: #ccc;
			color: #333;
		}

		.btn-cancel:hover {
			background-color: #bbb;
		}
	</style>
</head>
<body>
	<div id="productApp">
		<jsp:include page="../admin/layout.jsp" />
		<div class="layout">
			<div class="content">
				<div class="form-wrapper">
					<div class="form-title">패키지 정보 입력</div>
					<table class="form-table">
						<tr>
							<th>패키지명</th>
							<td><input type="text" v-model="packageName" class="input-box"></td>
						</tr>
						<tr>
							<th>패키지 설명</th>
							<td>
								<textarea v-model="packageInfo" rows="4" class="input-box textarea-box"></textarea>
							</td>
						</tr>
						<tr>
							<th>패키지 가격</th>
							<td><input type="number" v-model="packagePrice" class="input-box"></td>
						</tr>
						<tr>
							<th>사용자</th>
							<td>
								<select v-model="packageStatus" class="input-box">
									<option value="U">일반 사용자용</option>
									<option value="L">변호사용</option>
								</select>
							</td>
						</tr>
					</table>

					<div class="btn-area">
						<button @click="fnSave" class="btn btn-save" style="font-family: 'Noto Sans KR', sans-serif !important;">등록</button>
						<button @click="fnBack" class="btn btn-cancel" style="font-family: 'Noto Sans KR', sans-serif !important;">뒤로가기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
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
</html>
