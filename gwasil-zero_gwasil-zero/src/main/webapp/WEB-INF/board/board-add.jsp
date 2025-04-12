<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>게시글 등록</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>

		<style>
			.board-form-wrapper {
				max-width: 800px;
				margin: 40px auto;
				padding: 30px;
				background: #fff;
				border-radius: 10px;
				box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
			}

			.board-form-title {
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
				font-weight: bold;
				margin-bottom: 6px;
				color: #555;
			}

			.input-box,
			.select-box,
			.textarea-box {
				width: 100%;
				padding: 10px;
				border: 1px solid #ddd;
				border-radius: 6px;
				font-size: 14px;
			}

			.textarea-box {
				resize: vertical;
				height: 200px;
				line-height: 1.5;
			}

			.file-box {
				margin-top: 10px;
			}

			.btn-area {
				text-align: center;
				margin-top: 30px;
			}

			.btn-submit {
				padding: 10px 30px;
				background-color: var(--main-color);
				color: white;
				border: none;
				border-radius: 6px;
				font-weight: bold;
				font-size: 14px;
				cursor: pointer;
				transition: background-color 0.2s;
			}

			.btn-submit:hover {
				background-color: #e55300;
			}

			.status-message {
				margin-top: 20px;
				text-align: center;
				font-weight: bold;
				color: #444;
			}

			.tooltip-container {
				position: relative;
				display: inline-block;
				cursor: pointer;
			}

			.tooltip-icon {
				display: inline-block;
				background-color: #999;
				color: #fff;
				border-radius: 50%;
				width: 18px;
				height: 18px;
				font-size: 12px;
				text-align: center;
				line-height: 18px;
				margin-left: 5px;
			}

			.tooltip-text {
				visibility: hidden;
				width: 250px;
				background-color: #333;
				color: #fff;
				text-align: left;
				border-radius: 5px;
				padding: 8px;
				position: absolute;
				z-index: 1;
				bottom: 125%;
				left: 0;
				opacity: 0;
				transition: opacity 0.3s;
				font-size: 13px;
			}

			.tooltip-container:hover .tooltip-text {
				visibility: visible;
				opacity: 1;
			}

			.btn-guide {
				padding: 8px 14px;
				font-size: 13px;
				font-weight: 600;
				color: #ff5c00;
				background-color: #fff6f1;
				border: 1px solid #ffc7a6;
				border-radius: 20px;
				box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
				transition: all 0.25s ease;
				text-decoration: none;
				display: inline-block;
			}

			.btn-guide:hover {
				background-color: #ff5c00;
				color: white;
				border-color: #ff5c00;
				box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
			}
		</style>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">
			<div class="board-form-wrapper">
				<div class="board-form-title">게시글 등록
					<span class="tooltip-container">
					    <span class="tooltip-icon">?</span>
					    <span class="tooltip-text" style="width: 300px;">
					      동영상은 초상권 침해를 막기 위해 자동으로 모자이크 처리되며,<br>
					      화질이 일부 제한될 수 있습니다.<br>
					      영상 길이는 각 영상당 최대 40초로 제한되며 초과 시 자동으로 편집됩니다.
					    </span>
					  </span>
					
				</div>

				<div class="form-group">
					<label>제목</label>
					<input v-model="title" class="input-box" placeholder="제목을 입력하세요">
				</div>

				<div class="form-group">
					<div class="flex-between mb-10">
						<label for="category">사고 유형</label>
						<a href="/totalDocs/guide.do" class="btn-guide" target="_blank" rel="noopener noreferrer">가이드라인
							보기</a>
					</div>
					<select v-model="selectedCategory" class="select-box">
						<option disabled value="">-- 사고 유형 선택 --</option>
						<option v-for="cat in categoryList" :key="cat.value" :value="cat.value">{{ cat.label }}</option>
					</select>
				</div>

				<div class="form-group">
					<label>패키지 적용 여부</label>
					<div style="display: flex; align-items: center; gap: 20px;">
						<label><input type="radio" value="N" v-model="usePackage"> 패키지 적용 안함</label>
						<label><input type="radio" value="Y" v-model="usePackage">
							빠른답변 패키지
							<span class="tooltip-container">
								<span class="tooltip-icon">?</span>
								<span class="tooltip-text">
									빠른답변 패키지를 적용하면<br>
									24시간 내로 빠른 답변을 받을 수 있습니다.
								</span>
							</span>
						</label>
					</div>
				</div>


				<div class="form-group">
					<label>내용</label>
					<textarea v-model="contents" class="textarea-box" placeholder="내용을 입력하세요"></textarea>
				</div>

				<div class="form-group">
					<label>파일 업로드</label>
					<input type="file" id="file1" name="file1" accept=".jpg,.png,.mp4,.mov,.avi" multiple
						class="file-box">
				</div>

				<div class="btn-area">
					<button @click="fnPixelizer" :disabled="isLoading" class="btn-submit">
						{{ isLoading ? '처리 중...' : '모자이크 처리 및 등록' }}
					</button>
				</div>

				<div class="status-message" v-if="statusMessage">
					{{ statusMessage }}
				</div>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					list: [],
					title: "",
					contents: "",
					usePackage: "N",
					isLoading: false,
					statusMessage: "",
					categoryList: [
						{ value: "01", label: "신호 위반" },
						{ value: "02", label: "보행자 사고" },
						{ value: "03", label: "음주/무면허 사고" },
						{ value: "04", label: "끼어들기/진로 변경" },
						{ value: "05", label: "주차/문 개방" },
						{ value: "06", label: "중앙선 침범" },
						{ value: "07", label: "과속/안전거리 미확보" },
						{ value: "08", label: "역주행/일방통행" },
						{ value: "09", label: "불법 유턴/좌회전" },
						{ value: "10", label: "기타/복합 사고" }
					],
					selectedCategory: "",
					sessionId: "${sessionScope.sessionId}",
					packageCount: 0,
					packageList: [],
					orderId: ""
				};
			},
			methods: {
				fnPixelizer() {
					const self = this;

					if (!self.selectedCategory) {
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

					const form = new FormData();
					for (let i = 0; i < $("#file1")[0].files.length; i++) {
						form.append("file1", $("#file1")[0].files[i]);
					}
					form.append("title", self.title);
					form.append("contents", self.contents);
					form.append("category", self.selectedCategory);
					form.append("sessionId", self.sessionId);
					if (self.usePackage === "Y") {
						form.append("usedPayOrderId", self.orderId);
					}
					else if (self.usePackage === "N") {
						form.append("usedPayOrderId", "");
					}
					// 패키지 사용여부
					form.append("usePackage", self.usePackage);

					self.isLoading = true;
					self.statusMessage = "업로드 및 모자이크 처리 중입니다... 잠시만 기다려주세요";
					self.upload(form);
				},
				upload(form) {
					const self = this;
					$.ajax({
						url: "/board/fileUpload.dox",
						type: "POST",
						processData: false,
						contentType: false,
						data: form,
						success: function (response) {
							self.statusMessage = "모자이크 처리가 완료되었습니다!";
							self.isLoading = false;
							location.href = "/board/list.do";
						},
						error: function () {
							self.statusMessage = "업로드 실패.";
							self.isLoading = false;
						}
					});
				},
				fnGetPackage() {
					let self = this;
					$.ajax({
						url: "/board/packageCount.dox",
						type: "POST",
						data: { userId: self.sessionId },
						success: function (res) {
							self.packageCount = res.packageCount;
							self.packageList = res.packageList;
							self.orderId = self.packageList[0].orderId;
							console.log("사용 가능 패키지 수:", self.packageCount);
							console.log("사용 가능 패키지 목록:", self.packageList);
						}
					});

				}
			},
			watch: {
				usePackage(newVal) {
					const self = this;

					// 선택이 Y인데 패키지 수가 0일 때
					if (newVal === "Y" && self.packageCount === 0) {
						Swal.fire({
							icon: "info",
							title: "패키지 없음",
							text: "빠른답변 패키지가 없습니다. 구매하러 가시겠습니까?",
							showCancelButton: true,
							confirmButtonText: "패키지 구매",
							cancelButtonText: "취소",
							confirmButtonColor: "#ff5c00"
						}).then((result) => {
							if (result.isConfirmed) {
								self.usePackage = "N";
								location.href = "/package/package.do";
							} else {
								
								self.$nextTick(() => {
									self.usePackage = "N";
								});
							}
						});
					}
				}
			},
			created() {
				const urlParams = new URLSearchParams(window.location.search);
				const categoryParam = urlParams.get('category');
				if (categoryParam) {
					this.selectedCategory = categoryParam;
				}
				this.fnGetPackage();

			}
		});
		app.mount('#app');
	</script>

	</html>