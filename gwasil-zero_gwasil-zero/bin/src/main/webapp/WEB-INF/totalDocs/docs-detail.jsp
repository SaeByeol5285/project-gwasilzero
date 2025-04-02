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
				<div class="view-content mb-20">
					{{ info.totalContents }}
				</div>
				<div>
					<img v-for="(image, index) in imgList" :src="image.filePath" :key="index" alt="첨부 이미지">
				</div>
				<div v-if="sessionStatus == 'A'" class="mb-20">
					<button @click="fnEdit(info.totalNo)" class="btn btn-outline">수정</button>
					<button @click="fnRemove(info.totalNo)" class="btn btn-outline">삭제</button>
				</div>
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
					imgList: [],
					prev: null,
					next: null,
					sessionStatus: "A"
				};
			},
			methods: {
				fnDocsView() {
					const self = this;
					$.ajax({
						url: "/totalDocs/view.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: self.totalNo },
						success(data) {
							if (data.result === "success") {
								self.info = data.info;
								self.imgList = data.imgList;
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
				fnEdit(totalNo) {
					pageChange("/totalDocs/edit.do", { totalNo: totalNo });
				},
				fnRemove(totalNo) {
					if (!confirm("정말 삭제하시겠습니까?")) {
						return;
					}
					$.ajax({
						url: "/docs/remove.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: totalNo },
						success(data) {
							if (data.result === "success") {
								alert("삭제되었습니다.");
								location.href = "/totalDocs/list.do";
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
			}
		});
		app.mount("#app");
	</script>