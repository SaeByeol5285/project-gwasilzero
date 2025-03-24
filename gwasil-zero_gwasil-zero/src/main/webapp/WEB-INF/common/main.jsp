<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<link rel="stylesheet" href="/css/main.css">
		<link rel="stylesheet" href="/css/common.css">
		<script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />

		<title>main.jsp</title>
	</head>
	<style>
	</style>

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
					<div class="section-title flex-between">
						최근 질문
						<button class="btn btn-outline">질문하러 가기</button>
					</div>
					<ul class="question-list mt-40 mb-40">
						<li class="card mb-20">
							<h3>[형사] 블랙박스 영상에 잡힌 사고, 과실이 있을까요?</h3>
							<p>2025.03.23</p>
						</li>
						<li class="card mb-20">
							<h3>[민사] 차량 파손 보상을 받으려면 어떻게 해야 하나요?</h3>
							<p>2025.03.22</p>
						</li>
						<li class="card mb-20">
							<h3>[민사] 보험사에 2:8을 주장해요. 근거가 있나요? </h3>
							<p>2025.03.21</p>
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
					list: []

				};
			},
			methods: {
				fnKaKao() {
                    var self = this;
                    var nparmap = {
                        code: self.code
                    };
                    $.ajax({
                        url: "/kakao.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                        }
                    });
                }
			},
			mounted() {
				var self = this;
				const queryParams = new URLSearchParams(window.location.search);
                self.code = queryParams.get('code') || '';
                console.log(self.code);
                if (self.code != "") {
                    self.fnKaKao();
                }
				const swiper = new Swiper('.mySwiper', {
					slidesPerView: 3,
					spaceBetween: 30,
					loop: true,
					autoplay: {
						delay: 2000, // 3초마다 자동으로 전환
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
			},
			
		});
		app.mount('#app');
	</script>
	​