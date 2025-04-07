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
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">
			<div class="container">
				<!-- 변호사 소개 영역 -->
				<section class="lawyer-intro">
					<div class="lawyer-flex">
						<div class="swiper-container-area">
							<div class="section-title">
								<span class="orange">상담 가능 변호사</span> 와 지금 바로 <strong>블랙박스 영상</strong> 기반 상담을 받아보세요.
							</div>
							<div class="swiper mySwiper">
								<div class="swiper-wrapper">
									<div class="swiper-slide" v-for="lawyer in lawyerList" :key="lawyer.lawyerId">
										<div class="lawyer-card">
											<img class="lawyer-img" :src="lawyer.lawyerImg" />
											<div class="lawyer-icons">
												<a><img src="../../img/common/message-ing.png" class="icon"></a>
												<a><img src="../../img/common/bookmark.png" class="icon"></a>
											</div>
											<div class="icons-text">
												<div class="card-txt-small">1:1채팅</div>
												<div class="card-txt-small">북마크</div>
											</div>
											<div class="lawyer-content">
												<div class="lawyer-tags">
													<!-- 대표 카테고리 db에서 가져와서 넣기 -->
													<span class="tag">신호위반</span>
													<span class="tag">음주/무면허 사고</span>
												</div>
												<div>
													<h3 class="lawyer-name">{{ lawyer.lawyerName }}<span
															class="card-txt-small">변호사</span></h3>
													<p class="lawyer-info" v-html="lawyer.lawyerInfo"></p>
													<a class="btn-detail" href="#">자세히 보기</a>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="swiper-pagination"></div>
							<div class="swiper-button-next" style="color: #ff57226b"></div>
							<div class="swiper-button-prev" style="color: #ff57226b"></div>
						</div>
					</div>
				</section>

				<section class="category-intro">
					<div class="section-title">
						어떤 분야의 사례를 알아보고 싶으신가요?
					</div>
					<div class="category-list">
						<div>
							<img src="../../img/common/category/1.icon.signal_violation.png" class="category-icon">
							<div>신호위반</div>
						</div>
						<div>
							<img src="../../img/common/category/2.icon.pedestrian.png" class="category-icon">
							<div>보행자</div>
						</div>
						<div>
							<img src="../../img/common/category/3.icon.drunk_or_nolicense.png" class="category-icon">
							<div>음주/무면허</div>
						</div>
						<div>
							<img src="../../img/common/category/4.icon.lane_change.png" class="category-icon">
							<div>끼어들기/진로변경</div>
						</div>
						<div>
							<img src="../../img/common/category/5.icon.parking_door.png" class="category-icon">
							<div>주차/문개방</div>
						</div>
						<div>
							<img src="../../img/common/category/6.icon.center_line.png" class="category-icon">
							<div>중앙선 침범</div>
						</div>
						<div>
							<img src="../../img/common/category/7.icon.speed_distance.png" class="category-icon">
							<div>과석/안전거리 미확보</div>
						</div>
						<div>
							<img src="../../img/common/category/8.icon.wrong_way.png" class="category-icon">
							<div>일방통행/역주행</div>
						</div>
						<div>
							<img src="../../img/common/category/9.icon.illegal_turn.png" class="category-icon">
							<div>불법유턴/좌회전</div>
						</div>
						<div>
							<img src="../../img/common/category/10.icon.etc_case.png" class="category-icon">
							<div>기타/복합사고</div>
						</div>
					</div>
				</section>

				<!-- 최근 질문 -->
				<section class="question-board">
					<div class="flex-between">
						<a class="section-title orange">최근 상담 문의</a>
						<a class="btn btn-outline" href="/board/list.do">질문하러 가기</a>
					</div>
					<ul class="question-list">
						<li class="card mb-20" v-for="board in boardList" :key="board.boardNo">
							<div class="orange">{{ board.category }}</div>
							<div>{{ board.boardTitle }}</div>
							<div class="cut-letter card-txt-small">{{ board.contents }}</div>
							<p>{{ board.cdate }}</p>
							<div>변호사 답변 : <span class="orange">{{ board.cmtCount }}</span>개</div>
						</li>
					</ul>
				</section>

				<!-- 리뷰 -->
				<section class="review">


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
						slidesPerView: 4,
						spaceBetween: 30,
						slidesPerGroup: 4,
						speed: 1000,

						loop: true,
						autoplay: {
							delay: 5000,
							disableOnInteraction: true,
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