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
												<a v-if="sessionType === 'user'"><img src="../../img/common/call.png"
														class="icon" @click="startChat(lawyer.lawyerId)"></a>
												<a @click="toggleBookmark(lawyer.lawyerId)">
													<img :src="isBookmarked(lawyer.lawyerId) ? '/img/selectedBookmark.png' : '/img/common/bookmark.png'"
														class="icon" />
												</a>
											</div>
											<div class="icons-text">
												<div v-if="sessionType === 'user'" class="card-txt-small"
													@click="startChat(lawyer.lawyerId)">전화상담</div>
												<div class="card-txt-small" @click="fnBookmark(lawyer.lawyerId)">북마크
												</div>
											</div>
											<div class="lawyer-content">
												<div class="lawyer-tags">
													<!-- 대표 카테고리 db에서 가져와서 넣기 -->
													<span class="tag">{{lawyer.mainCategoryName1}}</span>
													<span class="tag">{{lawyer.mainCategoryName2}}</span>
												</div>
												<div>
													<h3 class="lawyer-name">{{ lawyer.lawyerName }}<span
															class="card-txt-small">변호사</span></h3>
													<p class="lawyer-info" v-html="lawyer.lawyerInfo"></p>
													<a class="btn-detail" @click="goToProfile(lawyer.lawyerId)">자세히
														보기</a>
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
						<div @click="goToBoard('01')">
							<img src="../../img/common/category/1.icon.signal_violation.png" class="category-icon">
							<div>신호위반</div>
						</div>
						<div @click="goToBoard('02')">
							<img src="../../img/common/category/2.icon.pedestrian.png" class="category-icon">
							<div>보행자</div>
						</div>
						<div @click="goToBoard('03')">
							<img src="../../img/common/category/3.icon.drunk_or_nolicense.png" class="category-icon">
							<div>음주/무면허</div>
						</div>
						<div @click="goToBoard('04')">
							<img src="../../img/common/category/4.icon.lane_change.png" class="category-icon">
							<div>끼어들기/진로변경</div>
						</div>
						<div @click="goToBoard('05')">
							<img src="../../img/common/category/5.icon.parking_door.png" class="category-icon">
							<div>주차/문개방</div>
						</div>
						<div @click="goToBoard('06')">
							<img src="../../img/common/category/6.icon.center_line.png" class="category-icon">
							<div>중앙선 침범</div>
						</div>
						<div @click="goToBoard('07')">
							<img src="../../img/common/category/7.icon.speed_distance.png" class="category-icon">
							<div>과석/안전거리 미확보</div>
						</div>
						<div @click="goToBoard('08')">
							<img src="../../img/common/category/8.icon.wrong_way.png" class="category-icon">
							<div>일방통행/역주행</div>
						</div>
						<div @click="goToBoard('09')">
							<img src="../../img/common/category/9.icon.illegal_turn.png" class="category-icon">
							<div>불법유턴/좌회전</div>
						</div>
						<div @click="goToBoard('10')">
							<img src="../../img/common/category/10.icon.etc_case.png" class="category-icon">
							<div>기타/복합사고</div>
						</div>
					</div>
				</section>

				<!-- 최근 질문 -->
				<section class="question-board">
					<div class="flex-between">
						<a class="section-title" href="/board/list.do" style="text-decoration: none;">최근 상담글 ></a>
					</div>
					<ul class="question-list">
						<li class="card mb-20" v-for="board in boardList" :key="board.boardNo"
							@click="goToBoardView(board.boardNo)">
							<div class="board-logo">
								<img src="/img/common/logo3.png" class="top-icon" />
								<span class="orange">{{ board.category }}</span>
							</div>
							<h3>{{ board.boardTitle }}</h3>
							<div class="cut-letter">{{ board.contents }}</div>
							<p>{{ board.cdate }}</p>
							<div>변호사 답변 : {{ board.cmtCount }}개</div>
						</li>
					</ul>
				</section>

				<!-- 리뷰 -->
				<section class="review">
					<div class="section-title">상담 후기</div>
					<div class="swiper reviewSwiper">
						<div class="swiper-wrapper">
							<div class="swiper-slide" v-for="review in reviewList" :key="review.reviewNo">
								<li class="review-card">
									<!-- 로고영역: 카드 내부지만 절대위치로 띄움 -->
									<div class="review-logo">
										<img src="/img/common/logo3.png" class="review-icon" />
										<span class="review-lawyerName">{{ review.lawyerName }}</span><span
											class="small">변호사</span>
									</div>

									<!-- 나머지 본문 -->
									<div class="review-body">
										<p class="review-highlight">“{{ review.highlight }}”</p>
										<p class="review-content">{{ review.contents }}</p>
										<p class="review-user">{{ review.userId.slice(0, 3) + '***' }}님의 후기</p>
									</div>
								</li>

							</div>
						</div>
						<div class="swiper-button-next" style="color: #ff57226b"></div>
						<div class="swiper-button-prev" style="color: #ff57226b"></div>
						<div class="swiper-review-pagination"></div>

					</div>

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
					reviewList: [],
					sessionId: "${sessionId}",
					bookmarkList: [],
					sessionType: "${sessionType}"
				};
			},
			methods: {
				fnGetReviewList() {
					const self = this;
					$.ajax({
						url: "/common/reviewList.dox",
						dataType: "json",
						type: "POST",
						success: function (data) {
							if (data.result === "success") {
								console.log(data);
								self.reviewList = self.reviewList = data.list;
							} else {
								alert("review 불러오기 실패");
							}
						}
					});
				},
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
					//리뷰 슬라이더
					new Swiper(".reviewSwiper", {
						slidesPerView: 3,             // 한 화면에 3개 보여줌
						spaceBetween: 20,             // 카드 간 간격
						slidesPerGroup: 3,            // 몇 장씩 넘길지
						loop: true,
						centeredSlides: false,        // 양 옆 잘림 방지
						navigation: {
							nextEl: ".swiper-button-next",
							prevEl: ".swiper-button-prev",
						},
						pagination: {
							el: ".swiper-review-pagination",
							clickable: true,
						},
					});
				},
				startChat(lawyerId) {
					let self = this;

					if (!self.sessionId) {
						alert("로그인이 필요합니다.");
						return;
					}

					if (self.sessionType !== 'user') {
						alert("일반 사용자만 채팅을 이용할 수 있습니다.");
						return;
					}

					$.ajax({
						url: "/chat/findOrCreate.dox",
						type: "POST",
						data: {
							userId: self.sessionId,
							lawyerId: lawyerId
						},
						success: function (res) {
							let chatNo = res.chatNo;
							pageChange("/chat/chat.do", {
								chatNo: chatNo
							});
						}
					});
				},
				EditBoard: function () {
					let self = this;
					pageChange("/board/edit.do", { boardNo: self.boardNo, userId: self.sessionId });
				},
				isBookmarked(lawyerId) {
					return this.bookmarkList.some(bm => bm.lawyerId === lawyerId);
				},
				toggleBookmark(lawyerId) {
					const self = this;

					if (!self.sessionId) {
						alert("로그인이 필요합니다.");
						return;
					}

					if (self.sessionType !== 'user') {
						alert("일반 사용자만 북마크를 사용할 수 있습니다.");
						return;
					}

					const isMarked = self.isBookmarked(lawyerId);
					const url = isMarked ? "/bookmark/remove.dox" : "/bookmark/add.dox";

					$.ajax({
						url: url,
						type: "POST",
						data: {
							userId: self.sessionId,
							lawyerId: lawyerId
						},
						success: function (data) {
							if (isMarked) {
								self.bookmarkList = self.bookmarkList.filter(b => b.lawyerId !== lawyerId);
								alert(data.result);
							} else {
								self.bookmarkList.push({ lawyerId: lawyerId });
								alert(data.result);
							}
							localStorage.setItem('bookmarkUpdated', Date.now());
						},
						error: function () {
							alert("북마크 처리 중 오류가 발생했습니다.");
						}
					});
				},
				fnGetBookmarkList() {
					const self = this;
					if (!self.sessionId) return;

					$.ajax({
						url: "/bookmark/list.dox",
						type: "POST",
						data: { sessionId: self.sessionId },
						dataType: "json",
						success: function (data) {
							if (data.result === "success") {
								self.bookmarkList = data.list;
							}
						}
					});
				},
				goToBoard(categoryNo) {
					// 페이지 이동 (파라미터 포함)
					location.href = "/board/list.do?category=" + categoryNo;
				},
				goToProfile(lawyerId) {
					location.href = "/profile/view.do?lawyerId=" + lawyerId;
				},
				goToBoardView(boardNo) {
					location.href = "/board/view.do?boardNo=" + boardNo;
				}
			},
			mounted() {
				this.fnGetBoardList();
				this.fnGetLawyerList();
				this.fnGetBookmarkList();
				this.fnGetReviewList();
				console.log("메인에서 :", this.sessionId);
				//북마크 갱신용
				window.addEventListener('storage', (e) => {
					if (e.key === 'bookmarkUpdated') {
						this.fnGetBookmarkList();
					}
				});
			},

		});

		app.mount('#app');
	</script>

	</html>