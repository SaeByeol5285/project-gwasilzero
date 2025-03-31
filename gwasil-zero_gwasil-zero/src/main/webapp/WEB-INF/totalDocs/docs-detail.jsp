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

				<span v-if="sessionId == info.userId" class="mb-20">
					<button @click="fnEdit(info.totalNo)" class="btn btn-outline">수정</button>
				</span>
				<span v-if="sessionStatus == 'A' || sessionId == info.userId" class="mb-20">
					<button @click="fnRemove(info.totalNo)" class="btn btn-outline">삭제</button>
				</span>
				<div class="mb-20">
					<button @click="goToListPage" class="btn btn-outline">목록보기</button>
				</div>
			</div>

			<div class="mt-40 pt-10" style="border-top: 1px solid #eee;">
				<div v-if="prev" class="mb-10">
					⬅️ 이전글: <a href="javascript:void(0)" @click="moveTo(prev.totalNo)">{{ prev.totalTitle }}</a>
				</div>
				<div v-if="next">
					➡️ 다음글: <a href="javascript:void(0)" @click="moveTo(next.totalNo)">{{ next.totalTitle }}</a>
				</div>
				<!-- 댓글 영역: 관리자만 보임 -->
				<div v-if="sessionStatus === 'A'" class="mt-40">
					<h3 class="section-title">관리자 댓글</h3>
					<div class="form-group mb-10">
						<textarea v-model="commentContent" rows="3" placeholder="댓글을 입력하세요" style="width: 100%; padding: 10px;"></textarea>
					</div>
					<div>
						<button @click="submitComment" class="btn btn-primary">댓글 등록</button>
					</div>
					<!-- 댓글 리스트 -->
					<ul class="mt-20" v-if="comments.length > 0">
						<li v-for="(comment, idx) in comments" :key="idx" style="margin-bottom: 10px;">
							<strong>{{ comment.writer }}</strong>: {{ comment.content }} <small style="color: #aaa;">{{comment.cdate }}</small>
						</li>
					</ul>
				</div>
			</div>
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
					commentContent: "",
					comments: [],


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
				submitComment() {
					if (!this.commentContent.trim()) {
						alert("댓글 내용을 입력해주세요.");
						return;
					}
					const self = this;
					$.ajax({
						url: "/totalDocs/addCmt.dox",
						type: "POST",
						dataType: "json",
						data: {
							totalNo: self.totalNo,
							content: self.commentContent
						},
						success(data) {
							if (data.result === "success") {
								self.commentContent = "";
								self.loadComments(); // 다시 불러오기
							} else {
								alert("댓글 등록 실패");
							}
						}
					});
				},

				loadComments() {
					const self = this;
					$.ajax({
						url: "/totalDocs/cmtList.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: self.totalNo },
						success(data) {
							if (data.result === "success") {
								self.comments = data.list;
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
				if (this.sessionStatus === 'A') {
					this.loadComments(); // 관리자만 로드
				}
			}
		});
		app.mount("#app");
	</script>