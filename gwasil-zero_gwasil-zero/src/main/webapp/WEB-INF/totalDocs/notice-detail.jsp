<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/common.css">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
		<title>공지사항 상세</title>
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
					<img v-for="(image, index) in imgList" :src="image.filePath" :key="index" alt="제품 이미지">
				</div>
				<div v-if="sessionStatus == 'A'" class="mb-20">
					<button @click="fnEdit(info.totalNo)" class="btn btn-outline">수정</button>
					<button @click="fnRemove(info.totalNo)" class="btn btn-outline">삭제</button>
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
					totalNo: "${map.noticeNo}",
					info: "",
					sessionId: "",
					sessionStatus: "A",
					prev: null,
					next: null,
					imgList : []
				};
			},
			methods: {
				fnNoticeView() {
					var self = this;
					var nparmap = {
						totalNo: self.totalNo,
						option: "SELECT"
					};
					$.ajax({
						url: "/notice/view.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							
							if (data.result == "success") {
								self.info = data.info;
								self.imgList = data.imgList;
								self.fnAdjacent(self.totalNo);
							} else {
								alert("오류발생");
							}
						}
					});
				},
				fnAdjacent(no) {
					const self = this;
					var nparmap = {
						totalNo: no
					};
					$.ajax({
						url: "/notice/adjacent.dox",
						type: "POST",
						dataType: "json",
						data: nparmap,
						success(data) {
							console.log(data);
							self.prev = data.prev;
							self.next = data.next;
						}
					});
				},
				fnRemove(totalNo) {
					var self = this;
					if(!confirm("정말 삭제하시겠습니까?")){
						return;
					}
					var nparmap = {
						totalNo: totalNo,
					};
					$.ajax({
						url: "/notice/remove.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result == "success") {
								alert("삭제되었습니다.");
								location.href="/notice/list.do";
							} else {
								alert("삭제 중 오류발생");
							}
						}
					});

				},
				fnEdit(totalNo){
					pageChange("/notice/edit.do", { totalNo: totalNo });
				},
				moveTo(no) {
					this.totalNo = no;// 새 번호로 업데이트!
					this.fnNoticeView();// 새 totalNo 기준으로 다시 조회
					window.scrollTo({ top: 0, behavior: 'smooth' });// 선택사항: 스크롤도 위로				

				},
				goToListPage (){
					pageChange("/notice/list.do", {});
				}
			},
			mounted() {
				this.fnNoticeView();
			}
		});
		app.mount("#app");
	</script>