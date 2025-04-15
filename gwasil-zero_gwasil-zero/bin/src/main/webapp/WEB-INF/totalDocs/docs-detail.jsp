<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/common.css">
		<link rel="stylesheet" href="/css/totalDocs.css">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
				      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
		<style>

		</style>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<div class="container-detail">
				<!-- 본문 전체 -->
				<section class="post-wrapper" v-if="info">
					<!-- 제목 + 메타 -->
					<div class="post-header">
						<h2 class="section-title">{{ info.totalTitle }}</h2>
						<div class="detail-meta">
							작성자: {{ maskedUserId }} | 작성일: {{ info.cdate }} | 조회수: {{ info.cnt }}
						</div>
					</div>

					<!-- 첨부파일 -->
					<div class="post-file" v-if="fileList.length > 0">
						<div class="attachment-box">
							<label><strong>첨부파일</strong></label>
							<ul class="file-list">
								<li v-for="(file, idx) in fileList" :key="idx">
									<img src="../../img/common/file-attached.png" class="file-icon"> {{ file.fileName }}
									<template v-if="isPreviewable(file.fileName)">
										<a :href="file.filePath" target="_blank" class="btn-blue-small"
											style="margin-left: 10px;">보기</a>
									</template>
									<a :href="file.filePath" :download="file.fileName" class="btn-blue-small">다운로드</a>
								</li>
							</ul>
						</div>
					</div>

					<!-- 본문 내용 -->
					<div class="post-body">
						<div class="detail-contents" v-html="info.totalContents"></div>
					</div>

					<!-- 버튼 영역 -->
					<div class="post-actions">
						<div class="left-buttons">
							<button class="btn btn-write" @click="fnEdit(info.totalNo)" style="margin-right: 5px;"
								v-if="sessionId == info.userId">✏️ 수정</button>
							<button class="btn btn-red" @click="fnRemove(info.totalNo)"
								v-if="sessionStatus == 'ADMIN' || sessionId == info.userId">🗑️ 삭제</button>
						</div>
						<div class="right-buttons">
							<button @click="goToListPage" class="btn btn-outline">목록보기</button>
						</div>
					</div>
				</section>

				<!-- 댓글 전체 -->
				<!-- 관리자 댓글 리스트 -->
				<div class="admin-comments">
					<h3 class="section-title">관리자 댓글</h3>

					<ul class="comment-list" v-if="cmtList.length > 0">
						<li v-for="comment in cmtList" :key="comment.cmtNo" class="comment-item">
							<!-- 수정 중일 때 -->
							<div v-if="editCmtNo === comment.cmtNo" class="comment-edit">
								<textarea v-model="editContents" class="edit-textarea"></textarea>
								<div class="edit-actions">
									<button class="btn btn-outline btn-sm" @click="fnSaveCmt(comment.cmtNo)">수정
										완료</button>
									<button class="btn btn-gray btn-sm" @click="editCmtNo = null">취소</button>
								</div>
							</div>

							<!-- 일반 상태 -->
							<template v-else>
								<div class="comment-content">
									<strong>[관리자]</strong>
									<div class="comment-content" v-html="comment.contents.replace(/\n/g, '<br>')"></div>
									<small class="cmt-time">{{ comment.cdate }}</small>
									<span class="cmt-actions" v-if="sessionStatus == 'ADMIN'">
										<span @click="fnEditCmt(comment)">수정</span>
										<span @click="fnRemoveCmt(comment.cmtNo)">삭제</span>
									</span>
								</div>
							</template>
						</li>
					</ul>
					<p v-else class="no-comment">아직 등록된 댓글이 없습니다.</p>

					<div v-if="sessionStatus == 'ADMIN'">
						<h3 class="section-title">댓글 작성</h3>
						<div class="comment-form">
							<textarea v-model="cmtContents" placeholder="댓글을 입력하세요" rows="5"></textarea>
							<button @click="fnAddCmt" class="btn btn-blue">💬 댓글 등록</button>
						</div>
					</div>

				</div>

				<!-- 이전/다음글은 여기 아래로 분리 -->
				<div class="adjacent-links">
					<div v-if="prev">⬅️ 이전글: <a @click="moveTo(prev.totalNo)">{{ prev.totalTitle }}</a></div>
					<div v-if="next">➡️ 다음글: <a @click="moveTo(next.totalNo)">{{ next.totalTitle }}</a></div>
				</div>

				<!--  -->

			</div>
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					sessionStatus: "${sessionStatus}",
					sessionId: "${sessionId}",
					totalNo: "${map.totalNo}",
					kind: "${map.kind}", //NOTICE,HELP
					info: {}, //글
					fileList: [], //글첨부파일
					prev: null,
					next: null,
					cmtList: [], //댓글리스트
					cmtContents: "", //기존 댓글내용
					editCmtNo: null, //글 수정시 댓글번호
					editContents: '',//글 수정시 댓글내용
					isSubmitting: false, //중복방지
				};
			},
			methods: {
				fnDocsView() {
					var self = this;
					var nparmap = {
						totalNo: self.totalNo,
						option: "SELECT" //조회수 증가
					};
					$.ajax({
						url: "/totalDocs/view.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success(data) {
							if (data.result === "success") {
								self.info = data.info;
								self.fileList = data.fileList;
								self.fnAdjacent(self.totalNo, self.info.kind);
							} else {
								alert("오류발생");
							}
						}
					});
				},
				fnAdjacent(no, kind) {
					const self = this;
					$.ajax({
						url: "/totalDocs/adjacent.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: no, kind: kind },
						success(data) {
							self.prev = data.prev;
							self.next = data.next;
						}
					});
				},
				fnGetCmtList() {
					var self = this;
					var nparmap = {
						totalNo: self.totalNo
					};
					$.ajax({
						url: "/totalDocs/cmtList.dox",
						type: "POST",
						dataType: "json",
						data: nparmap,
						success(data) {
							if (data.result === "success") {
								self.cmtList = data.list;
							}
						}
					});
				},
				fnAddCmt() {
					const self = this;
					if (self.isSubmitting) return;
					if (!self.cmtContents.trim()) {
						alert("댓글 내용을 입력해주세요.");
						return;
					}
					self.isSubmitting = true;
					var nparmap = {
						totalNo: self.totalNo,
						contents: self.cmtContents
					};
					$.ajax({
						url: "/totalDocs/addCmt.dox",
						type: "POST",
						dataType: "json",
						data: nparmap,
						success(data) {
							if (data.result == "success") {
								self.cmtContents = "";
								self.isSubmitting = false;
								self.fnGetCmtList();
							} else {
								self.isSubmitting = false;
								alert("댓글 등록 실패");
							}
						}
					});
				},
				fnEditCmt(comment) {
					this.editCmtNo = comment.cmtNo;
					this.editContents = comment.contents;
				},
				fnSaveCmt(cmtNo) {
					const self = this;
					if (!self.editContents.trim()) return alert("내용을 입력하세요");
					var nparmap = {
						cmtNo: cmtNo,
						contents: self.editContents
					};
					$.ajax({
						url: "/totalDocs/editCmt.dox",
						type: "POST",
						dataType: "json",
						data: nparmap,
						success(data) {
							if (data.result == "success") {
								self.editCmtNo = null;
								self.editContents = '';
								self.fnGetCmtList();
							} else {
								alert("수정 실패");
							}
						}
					});
				},
				fnRemoveCmt(cmtNo) {
					const self = this;

					Swal.fire({
						title: "댓글 삭제",
						text: "정말 삭제하시겠습니까?",
						icon: "warning",
						showCancelButton: true,
						confirmButtonColor: "#d33",
						cancelButtonColor: "#aaa",
						confirmButtonText: "삭제",
						cancelButtonText: "취소"
					}).then((result) => {
						if (result.isConfirmed) {
							const nparmap = { cmtNo: cmtNo };

							$.ajax({
								url: "/totalDocs/removeCmt.dox",
								type: "POST",
								dataType: "json",
								data: nparmap,
								success(data) {
									if (data.result === "success") {
										Swal.fire({
											icon: "success",
											title: "삭제 완료",
											text: "댓글이 삭제되었습니다.",
											confirmButtonText: "확인"
										});
										self.fnGetCmtList();
									} else {
										Swal.fire({
											icon: "error",
											title: "삭제 실패",
											text: "댓글 삭제에 실패했습니다.",
											confirmButtonText: "확인"
										});
									}
								},
								error() {
									Swal.fire({
										icon: "error",
										title: "서버 오류",
										text: "댓글 삭제 중 오류가 발생했습니다.",
										confirmButtonText: "확인"
									});
								}
							});
						}
					});
				},

				isImage(fileName) { //이미지 파일인지
					const ext = fileName.split('.').pop().toLowerCase();
					return ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].includes(ext);
				},
				isPreviewable(fileName) { //미리보기 가능한지
					const ext = fileName.split('.').pop().toLowerCase();
					return ['pdf', 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].includes(ext);
				},
				fnEdit(totalNo) {
					pageChange("/totalDocs/edit.do", { totalNo: totalNo });
				},
				fnRemove(totalNo) {
					const self = this;

					Swal.fire({
						title: "정말 삭제하시겠습니까?",
						text: "삭제 후 복구할 수 없습니다.",
						icon: "warning",
						showCancelButton: true,
						confirmButtonColor: "#d33",
						cancelButtonColor: "#aaa",
						confirmButtonText: "삭제",
						cancelButtonText: "취소"
					}).then((result) => {
						if (result.isConfirmed) {
							$.ajax({
								url: "/totalDocs/remove.dox",
								type: "POST",
								dataType: "json",
								data: { totalNo: totalNo },
								success(data) {
									if (data.result === "success") {
										Swal.fire({
											icon: "success",
											title: "삭제 완료",
											text: "게시글이 삭제되었습니다.",
											confirmButtonText: "확인"
										}).then(() => {
											pageChange("/totalDocs/list.do", { kind: self.kind });
										});
									} else {
										Swal.fire({
											icon: "error",
											title: "오류 발생",
											text: "삭제 중 오류가 발생했습니다.",
											confirmButtonText: "확인"
										});
									}
								},
								error() {
									Swal.fire({
										icon: "error",
										title: "서버 오류",
										text: "서버와의 통신 중 문제가 발생했습니다.",
										confirmButtonText: "확인"
									});
								}
							});
						}
					});
				},

				moveTo(no) {
					this.totalNo = no;
					this.fnDocsView();
					this.fnGetCmtList();
					window.scrollTo({ top: 0, behavior: 'smooth' });
				},
				goToListPage() {
					pageChange("/totalDocs/list.do", { kind: this.kind });
				}
			},
			mounted() {
				this.fnDocsView();
				this.fnGetCmtList();
			},
			computed: {
				maskedUserId() {
					return this.info?.userId?.slice(0, 3) + '***';
				}
			}
		});
		app.mount("#app");
	</script>