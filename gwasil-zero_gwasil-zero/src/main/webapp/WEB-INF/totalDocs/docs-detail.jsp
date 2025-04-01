<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/common.css">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
		<title>상세 페이지</title>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<div class="card" v-if="info">
				<h2 class="section-title">{{ info.totalTitle }}</h2>
				<div class="view-meta mb-20">
					작성자: {{ info.userId }} | 작성일: {{ info.cdate }} | 조회수: {{ info.cnt }}
				</div>
				<div class="form-group mb-20" v-if="fileList.length > 0">
					<label>첨부파일</label>
					<ul>
						<li v-for="(file, idx) in fileList" :key="idx">
							📎 {{ file.fileName }}
							<template v-if="isPreviewable(file.fileName)">
								<a :href="file.filePath" target="_blank" style="margin-left: 10px;">보기</a>
							</template>
							<a :href="file.filePath" :download="file.fileName" style="margin-left: 10px;">다운로드</a>
						</li>
					</ul>
				</div>

				<div class="view-content mb-20">
					<div class="detail-contents" v-html="info.totalContents"></div>
				</div>

				<div class="button-wrap" style="display: flex; justify-content: space-between; margin-top: 20px;">
					<div class="left-buttons">
						<button class="btn btn-outline">수정</button>
						<button class="btn btn-outline">삭제</button>
					</div>
					<div class="right-buttons">
						<button @click="goToListPage" class="btn btn-primary">목록보기</button>
					</div>
				</div>
			</div>

			<div class="mt-40 pt-10" style="border-top: 1px solid #eee;">
				<div v-if="prev" class="mb-10">
					⬅️ 이전글: <a href="javascript:void(0)" @click="moveTo(prev.totalNo)">{{ prev.totalTitle }}</a>
				</div>
				<div v-if="next">
					➡️ 다음글: <a href="javascript:void(0)" @click="moveTo(next.totalNo)">{{ next.totalTitle }}</a>
				</div>
			</div>
			<!-- 댓글 영역: 관리자만 보임 -->
			<div class="mt-40" v-if="sessionStatus == 'A'">
				<h3 class="section-title">관리자 댓글</h3>
				<div class="form-group mb-10">
					<textarea v-model="cmtContents" rows="3" placeholder="댓글을 입력하세요"
						style="width: 100%; padding: 10px;"></textarea>
				</div>
				<div>
					<button @click="fnAddCmt" class="btn btn-primary">댓글 등록</button>
				</div>
			</div>
			<!-- 댓글 리스트 -->
			<ul class="mt-20">
				<li v-for="(comment, idx) in cmtList" :key="idx" style="margin-bottom: 10px;">
					<div v-if="editCmtId === comment.cmtNo">
						<textarea v-model="editContents" rows="3" style="width: 100%; padding: 10px;"></textarea>
						<div style="margin-top: 5px;">
							<button @click="fnSaveCmt(comment.cmtNo)" class="btn btn-outline">수정 완료</button>
							<button @click="editCmtId = null" class="btn btn-danger">취소</button>
						</div>
					</div>
					<div v-else>
						<strong>[관리자 답변]</strong>: {{ comment.contents }}
						<small style="color: #aaa;">{{ comment.cdate }}</small>
						<div style="margin-top: 5px;">
							<button @click="fnEditCmt(comment)" class="btn btn-outline btn-sm">수정</button>
							<button @click="fnRemoveCmt(comment.cmtNo)" class="btn btn-danger btn-sm">삭제</button>
						</div>
					</div>
				</li>
			</ul>
			<p v-else class="mt-20" style="color: #888;">아직 등록된 댓글이 없습니다.</p>

		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					totalNo: "${map.totalNo}",
					kind: "${map.kind}",
					info: {},
					fileList: [],
					prev: null,
					next: null,
					sessionStatus: "A",
					sessionId: "101", //"${sessionId}"
					cmtContents: "",
					cmtList: [], //댓글리스트
					isSubmitting: false,
					editCmtId: null,
					editContents: '',
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
								console.log(data);
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
							console.log(data);
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
					this.editCmtId = comment.cmtNo;
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
								self.editCmtId = null;
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
					if (!confirm("정말 삭제하시겠습니까?")) return;
					var nparmap = {
						cmtNo : cmtNo,
					};
					$.ajax({
						url: "/totalDocs/removeCmt.dox",
						type: "POST",
						dataType: "json",
						data: nparmap,
						success(data) {
							if (data.result == "success") {
								alert("답변이 삭제되었습니다.");
								self.fnGetCmtList();
							} else {
								alert("삭제 실패");						
							}
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
					if (!confirm("정말 삭제하시겠습니까?")) {
						return;
					}
					$.ajax({
						url: "/totalDocs/remove.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: totalNo },
						success(data) {
							if (data.result == "success") {
								alert("삭제되었습니다.");
								pageChange("/totalDocs/list.do", { kind: self.kind });
							} else {
								alert("삭제 중 오류발생");
							}
						}
					});
				},
				moveTo(no) {
					this.totalNo = no;
					this.fnDocsView();
					window.scrollTo({ top: 0, behavior: 'smooth' });
				},
				goToListPage() {
					pageChange("/totalDocs/list.do", { kind: this.kind });
				}
			},
			mounted() {
				this.fnDocsView();
				this.fnGetCmtList();
			}
		});
		app.mount("#app");
	</script>