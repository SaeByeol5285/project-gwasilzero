<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>공지사항 등록</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<link rel="stylesheet" href="/css/common.css">
		<script src="/js/page-change.js"></script>

	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<div class="card">
				<h2 class="section-title">공지사항 등록</h2>

				<div class="form-group mb-20">
					<label>제목</label>
					<input v-model="totalTitle" class="input-box" placeholder="제목을 입력하세요">
				</div>
				<div>
					첨부파일 : <input type="file" id="file1" name="file1" accept=".jpg, .png" multiple>
				</div>

				<div class="form-group mb-20">
					<label>내용</label>
					<textarea v-model="totalContents" class="textarea-box" placeholder="내용을 입력하세요"></textarea>
				</div>

				<div class="btn-area">
					<button @click="fnAddNotice" class="btn btn-primary">등록</button>
					<button @click="goToListPage" class="btn btn-primary">목록보기</button>
				</div>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					totalTitle: "",
					totalContents: "",
					userId: "101", // 세션에서 받아오는 값으로 대체 가능
					kind: "NOTICE"
				};
			},
			methods: {
				fnAddNotice() {
					var self = this;
					if (!self.totalTitle || !self.totalContents) {
						alert("제목과 내용을 모두 입력해주세요.");
						return;
					}
					var nparmap = {
						totalTitle: self.totalTitle,
						totalContents: self.totalContents,
						userId: self.userId,
						kind: self.kind
					};
					$.ajax({
						url: "/notice/add.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							if (data.result == "success") {
								if ($("#file1")[0].files.length > 0) {
                                    var form = new FormData();
                                    for(let i=0; i<$("#file1")[0].files.length; i++){
                                        form.append("file1", $("#file1")[0].files[i]);
                                    }
                                    form.append("totalNo", data.totalNo); // 임시 pk
                                    self.upload(form);
									
                                } else{

                                }
                                
							} else {
								alert("글쓰기 실패!");
							}
						},
                        error: function () {
                            alert("서버 오류가 발생했습니다.");
                        }
					});
				},
				goToListPage (){
					pageChange("/notice/list.do", {});
				},
				// 파일 업로드
                upload: function (form) {
                    var self = this;
                    $.ajax({
                        url: "/fileUpload.dox"
                        , type: "POST"
                        , processData: false
                        , contentType: false
                        , data: form
                        , success: function (data) {
							if(data.result == "success"){
								alert("글쓰기가 완료되었습니다.");
								location.href="/notice/list.do"
							} else {
								alert("실패.");
							}							
                        }
                    });
                }
			}
		});
		app.mount("#app");
	</script>

	</html>