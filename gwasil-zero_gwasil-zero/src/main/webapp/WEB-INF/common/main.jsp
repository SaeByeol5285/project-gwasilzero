<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<link rel="stylesheet" href="/css/main.css">
		<link rel="stylesheet" href="/css/common.css">
		<script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />

		<title>main.jsp</title>

		<style>
		</style>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">
			<div class="container">
				<!-- 변호사 소개 영역 -->
				<section>
					<div class="section-title">변호사 소개</div>
					<div class="lawyer-flex">
						<!-- Swiper 영역 -->
						<div class="swiper-container-area">
							<div class="swiper mySwiper">
								<div class="swiper-wrapper">
									<div class="swiper-slide card-profile" v-for="lawyer in lawyerList"
										:key="lawyer.name">
										<img class="img-circle-profile" :src="lawyer.lawyerImg" />
										<p><strong>{{ lawyer.lawyerName }}</strong></p>
									</div>
								</div>
								<div class="swiper-button-next"></div>
								<div class="swiper-button-prev"></div>
								<div class="swiper-pagination"></div>
							</div>
						</div>
						<!-- 상담 가능한 변호사 리스트 -->
						<div class="lawyer-available-list">
							<h4>상담 가능 변호사</h4>
							<ul>
								<li v-for="lawyer in lawyerList" :key="lawyer.lawyerId">
									{{ lawyer.lawyerName }}
								</li>
							</ul>
							<a class="btn btn-outline" href="/lawyer/office.do">자세히 보기</a>
						</div>
					</div>
				</section>

				<!-- 최근 질문 -->
				<section class="question-board">
					<div class="flex-between">
						<span class="section-title">최근 질문</span>
						<a class="btn btn-outline" href="/board/list.do">질문하러 가기</a>
					</div>
					<ul class="question-list mt-40 mb-40">
						<li class="card mb-20" v-for="board in boardList" :key="board.boardNo">
							<div class="orange">{{ board.category }}</div>
							<h3>{{ board.boardTitle }}</h3>
							<div class="cut-letter">{{ board.contents }}</div>
							<p>{{ board.cdate }}</p>
							<div>변호사 답변 : {{ board.cmtCount }}개</div>
							<div class="mt-10">
								<a class="btn btn-outline" @click="fnView(board.boardNo)">자세히 보기</a>
							</div>
						</li>
					</ul>
				</section>

			</div>
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					boardList: [],
					lawyerList: [],
				};
			},
			methods: {
				fnGetBoardList() {
					const self = this;
					$.ajax({
						url: "/common/boardList.dox",
						dataType: "json",
						type: "POST",
						success: function (data) {
							if (data.result === "success") {
								self.boardList = data.list;
							} else {
								alert("board 불러오기 실패");
							}
						}
					});
				},
				fnView(boardNo) {
					location.href = "/board/view.do?boardNo=" + boardNo;
				},
				fnGetLawyerList() {
					const self = this;
					$.ajax({
						url: "/common/lawyerList.dox",
						type: "POST",
						dataType: "json",
						success(data) {
							if (data.result === "success") {
								console.log(data);
								self.lawyerList = data.list;
								self.$nextTick(() => {
									self.initSwiper();
								});
							} else {
								alert("변호사 목록 불러오기 실패");
							}
						}
					});
				},
				initSwiper() {
					new Swiper('.mySwiper', {
						slidesPerView: 2,
						spaceBetween: 30,
						loop: true,
						autoplay: {
							delay: 3000,
							disableOnInteraction: false,
						},
						pagination: {
							el: '.swiper-pagination',
							clickable: true,
						},
						navigation: {
							nextEl: '.swiper-button-next',
							prevEl: '.swiper-button-prev',
						},
						centeredSlides: false,
						grabCursor: true,
					});
				}
			},
			mounted() {
				this.fnGetBoardList();
				this.fnGetLawyerList();
			},

		});

		app.mount('#app');
	</script>

	</html>