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
				<section class="mt-40 mb-40">
					<div class="section-title">변호사 소개</div>
					<div class="swiper mySwiper">
						<div class="swiper-wrapper">
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/65c09ad0057892157e091fd4-original-1707121361363.jpg" alt="변호사" />
								<p><strong>김묘연</strong></p>
								<p>유턴 사고 전문 변호사</p>
							</div>
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/6743ddaac975c372bdf11b55-original-1732500907700.jpg" alt="변호사" />
								<p><strong>한보라</strong></p>
								<p>좌회전 사고 전문 변호사</p>
							</div>
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/662b42288c5ed98ed456f0ed-original-1714111016988.jpg" alt="변호사" />
								<p><strong>정다미</strong></p>
								<p>음주운전 사고 전문 변호사</p>
							</div>
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/63e0b8862df2010046cbcb4a-original-1675671686593.jpg" alt="변호사" />
								<p><strong>홍길동</strong></p>
								<p>차대차 전문 변호사</p>
							</div>
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/66432819ad4f841ac7c5d8a7-original-1715677210341.jpg" alt="변호사" />
								<p><strong>김영희</strong></p>
								<p>무단횡단 전문 변호사</p>
							</div>
							<div class="swiper-slide card">
								<img class="img-circle"
									src="../../img/676a1679502ca3b171b5cb6d-original-1735005818097.JPG" alt="변호사" />
								<p><strong>이철수</strong></p>
								<p>우회전 사고 전문 변호사</p>
							</div>
						</div>

						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
						<div class="swiper-pagination"></div>
					</div>
				</section>
				<section class="question-board">
					<div class="flex-between">
						<span class="section-title">최근 질문</span>
						<a class="btn btn-outline" href="/board/list.do">질문하러 가기</a>
					</div>
					<ul class="question-list mt-40 mb-40">
						<li class="card mb-20" v-for="board in boardList" :key="board.boardNo">
							<div class="orange">{{board.category}}</div>
							<h3>{{board.boardTitle}}</h3>
							<div class="cut-letter">{{board.contents}}</div>
							<p>{{board.cdate}}</p>
							<div>변호사 답변 : {{board.cmtCount}}개</div>
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

	</html>
	<script>

		const app = Vue.createApp({
			data() {
				return {
					boardList: [],
				};
			},
			methods: {
				fnGetBoardList() {
					const self = this;
					const nparmap = {
					};
					$.ajax({
						url: "/common/boardList.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							if (data.result === "success") {
								console.log(data);
								self.boardList = data.list;
							} else {
								alert("board불러오기 실패");
							}
						},

					});
				},
				fnView(boardNo){
					location.href = "/board/view.do?boardNo=" + boardNo;
				}

			},
			mounted() {
				var self = this;
				const swiper = new Swiper('.mySwiper', {
					slidesPerView: 3,
					spaceBetween: 30,
					loop: true,
					autoplay: {
						delay: 3000, // 3초마다 자동으로 전환
						disableOnInteraction: false, // 사용자가 슬라이드를 조작해도 자동 전환 유지
					},
					pagination: {
						el: '.swiper-pagination',
						clickable: true,
					},
					navigation: {
						nextEl: '.swiper-button-next',
						prevEl: '.swiper-button-prev',
					},
				});
				self.fnGetBoardList();
			}
		});

		app.mount('#app');
	</script>
	​