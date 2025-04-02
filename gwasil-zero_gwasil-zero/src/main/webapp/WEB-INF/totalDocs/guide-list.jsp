<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<link rel="stylesheet" href="/css/common.css">

		<head>
			<meta charset="UTF-8">
			<script src="https://code.jquery.com/jquery-3.7.1.js"
				integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
			<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
			<link rel="stylesheet" href="/css/common.css">
			<title>guide-list.jsp</title>
			<style>
				.image-grid-wrapper {
					display: flex;
					flex-wrap: wrap;
					/* 줄바꿈 허용 */
					justify-content: left;
					/* 가운데 정렬 */
					gap: 24px;
					/* 이미지 사이 간격 */
				}

				.image-grid-wrapper img {
					width: 480px;
					/* 원하는 고정 너비 */
					height: auto;
					/* 비율 유지 */
					object-fit: contain;
					border-radius: 6px;
				}

				.detail-content ul {
					padding-left: 20px;
				}

				.detail-content li {
					line-height: 1.6;
					margin-bottom: 6px;
				}

				.detail-content strong {
					color: #ff5c00;
				}

				.card {
					padding: 30px;
				}
			</style>
		</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">
			<div class="container">
				<h2 class="section-title">사고 유형에 맞는 카테고리를 선택해주세요</h2>

				<div class="card mb-20" v-for="(card, index) in cards" :key="index" :ref="el => cardRefs[index] = el">
					<div class="flex-between">
						<h2 class="section-title">{{ card.title }}</h2>
						<button class="btn btn-outline" @click="toggleCard(index)">
							{{ openIndex === index ? '간단히 보기' : '자세히 보기' }}
						</button>
					</div>

					<p><strong>예시 상황:</strong> {{ card.summary }}</p>

					<div v-if="openIndex === index" class="detail-content">
						<ul>
							<li v-for="item in card.details" :key="item">{{ item }}</li>
						</ul>
						<p><strong>법적 기준:</strong> {{ card.law }}</p>
						<p><strong>주의 포인트:</strong> {{ card.caution }}</p>
						<p class="mt-10">→ {{ card.guide }}</p>

						<div class="image-grid-wrapper mt-40">
							<img v-for="n in card.imageCount" :key="n" :src="fnImg(card.category, n)"
								:alt="`${card.title} 이미지 ${n}`" @error="onImageError" />
						</div>

						<div class="flex-center mt-40">
							<a :href="'/board/add.do?category=' + card.category" class="btn btn-primary">이 유형으로 글쓰기</a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>

	<!-- Vue 스크립트 -->
	<script>
		const app = Vue.createApp({
			data() {
				return {
					cardRefs: [], // 여기에 참조된 DOM들이 담김
					cards: [
						{
							title: "1. 신호 위반",
							summary: "신호 무시 또는 신호 없는 교차로 사고",
							"details": [
								"적신호에 직진 또는 좌회전",
								"황색신호에 빠르게 진입하다 사고",
								"신호등 없는 교차로에서 우선권 무시"
							],
							"law": "도로교통법 제5조",
							"caution": "명백한 신호위반은 100% 과실 가능성 높음",
							"guide": "위 상황과 유사하다면 ‘신호 위반’ 카테고리를 선택해주세요.",
							"imageCount": 3,
							"category": "signal_violation"
						},

						{
							"title": "2. 보행자 사고",
							"summary": "횡단보도, 스쿨존 등 보행자와의 충돌",
							"details": [
								"횡단보도 건너던 보행자와 충돌",
								"스쿨존에서 어린이와 사고 발생",
								"골목길 보행자 부주의 사고"
							],
							"law": "도로교통법 제27조",
							"caution": "스쿨존은 민식이법 적용, 형사처벌 가능성 있음",
							"guide": "보행자와 관련된 사고라면 ‘보행자 사고’로 선택해주세요.",
							"imageCount": 5,
							"category": "pedestrian"
						},

						{
							"title": "3. 음주/무면허 사고",
							"summary": "음주, 무면허, 졸음운전 등으로 인한 사고",
							"details": [
								"음주 상태로 운전 중 사고",
								"무면허 운전자 또는 대리운전 사고",
								"약물·졸음 상태 등 정상 주행 불가 상태"
							],
							"law": "도로교통법 제44조",
							"caution": "중과실 사고로 형사처벌 및 면허취소 가능",
							"guide": "위 사항에 해당된다면 ‘음주/무면허’로 선택해주세요.",
							"imageCount": 2,
							"category": "drunk_or_nolicense"
						},

						{
							"title": "4. 끼어들기 / 진로 변경",
							"summary": "방향지시 없이 차선 변경, 끼어들기 사고",
							"details": [
								"방향지시 없이 차선 급변경",
								"정체 중 끼어들다 접촉",
								"교차로 직전 진로 급변경"
							],
							"law": "도로교통법 제19조",
							"caution": "사고 시 끼어든 차량의 과실이 큼",
							"guide": "끼어들기·진로 변경 관련 사고라면 이 카테고리를 선택해주세요.",
							"imageCount": 3,
							"category": "lane_change"
						},

						{
							"title": "5. 주차 / 문 개방 중 사고",
							"summary": "정차된 차량의 문 개방 또는 주차 중 사고",
							"details": [
								"정차된 차량에서 문 열다 자전거와 충돌",
								"갓길 주차 차량과 지나가던 차량 충돌",
								"후진 주차 중 뒤 차량과 접촉"
							],
							"law": "도로교통법 제49조",
							"caution": "문 개방 사고는 운전자 책임이 큼",
							"guide": "위 사고 상황이라면 ‘주차/문 개방’ 카테고리를 선택해주세요.",
							"imageCount": 1,
							"category": "parking_door"
						},

						{
							"title": "6. 중앙선 침범",
							"summary": "유턴, 추월 등으로 중앙선을 넘어 발생한 사고",
							"details": [
								"유턴하려다 중앙선 넘은 경우",
								"좁은 도로에서 중앙선 넘어 추월",
								"사전 중앙선 침범 후 좌회전/진입"
							],
							"law": "도로교통법 제13조",
							"caution": "중앙선 침범은 대부분 100% 과실 판단",
							"guide": "위와 같은 경우라면 ‘중앙선 침범’으로 선택해주세요.",
							"imageCount": 2,
							"category": "center_line"
						},

						{
							"title": "7. 과속 / 안전거리 미확보",
							"summary": "속도 초과나 앞차와 거리 부족으로 인한 사고",
							"details": [
								"제한속도 초과 주행 중 추돌",
								"앞차와 거리 좁게 유지하다 사고",
								"고속도로에서 급제동 후 추돌"
							],
							"law": "도로교통법 제17조, 제18조",
							"caution": "과속 또는 거리 미확보는 과실 크고 형사처벌 가능",
							"guide": "위와 같은 상황이라면 ‘과속/안전거리’로 선택해주세요.",
							"imageCount": 2,
							"category": "speed_distance"
						},

						{
							"title": "8. 일방통행 / 역주행",
							"summary": "일방통행 위반이나 역주행으로 인한 사고",
							"details": [
								"일방통행 도로를 반대로 진입",
								"골목길에서 역주행하며 마주 오는 차량과 사고",
								"일방통행 끝단에서 무리한 진입"
							],
							"law": "도로교통법 제5조",
							"caution": "역주행 차량이 가해자로 판단되는 경우 많음",
							"guide": "위와 같은 경우라면 ‘역주행/일방통행 위반’ 선택해주세요.",
							"imageCount": 2,
							"category": "wrong_way"
						},

						{
							"title": "9. 불법 유턴 / 좌회전",
							"summary": "금지된 유턴/좌회전으로 인한 사고",
							"details": [
								"유턴 금지 구간에서 유턴하다 사고",
								"좌회전 금지 표지 무시하고 진행",
								"비보호 좌회전 중 신호차량과 충돌"
							],
							"law": "도로교통법 제6조, 제5조",
							"caution": "명백한 표지 위반은 가해자로 판단됨",
							"guide": "위 상황이라면 ‘불법 유턴/좌회전’으로 선택해주세요.",
							"imageCount": 3,
							"category": "illegal_turn"
						},

						{
							"title": "10. 기타 / 복합 사고",
							"summary": "분류하기 어려운 특수·복합 사고",
							"details": [
								"여러 차량이 관련된 복합 사고",
								"한 쪽 책임이 명확하지 않은 사고",
								"기존 분류에 포함되지 않는 특수 사례"
							],
							"law": "사고 상황에 따라 개별 판단",
							"caution": "정확한 분석이 필요한 사례",
							"guide": "분류가 애매하다면 ‘기타/복합 사고’를 선택해주세요.",
							"imageCount": 3,
							"category": "etc_case"
						}
					],
					openIndex: null
				};
			},
			methods: {
				toggleCard(index) {
					this.openIndex = this.openIndex === index ? null : index;
					// 카드 열렸을 때 스크롤 이동
					this.$nextTick(() => {
						const targetEl = this.cardRefs[index];
						if (targetEl) {
							targetEl.scrollIntoView({
								behavior: 'smooth',
								block: 'start'
							});
						}
					});
				},
				onImageError(event) {
					event.target.style.display = 'none'; // 이미지 없으면 감춤
				},
				fnImg(category, count) {
					return "/img/guide/" + category + count + ".gif";
				}

			},
			mounted() {

			}
		});
		app.mount("#app");
	</script>
	​