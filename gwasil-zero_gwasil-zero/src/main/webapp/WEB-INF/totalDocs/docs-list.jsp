<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/common.css">
		<link rel="stylesheet" href="/css/totalDocs.css">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
			rel="stylesheet">
		<title>통합 자료실</title>
		<style>
			.guide-card-grid {
				display: grid;
				grid-template-columns: repeat(3, 1fr);
				gap: 20px;
			}

			.mini-card {
				background-color: #fff7f2;
				border: 1px solid #ffe3d0;
				border-radius: 10px;
				padding: 16px;
				min-height: 100px;
				box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
				transition: box-shadow 0.2s;
			}

			.mini-card:hover {
				box-shadow: 0 3px 10px rgba(0, 0, 0, 0.07);
			}

			.card-title {
				color: var(--main-color);
				font-weight: bold;
			}

			.card-summary {
				font-size: 14px;
				color: #333;
				margin-top: 4px;
			}

			.arrow-icon {
				float: right;
				color: #bbb;
			}

			.text-center {
				text-align: center;
			}

			.big-button {
				padding: 14px 28px;
				font-size: 16px;
				font-weight: bold;
				border-radius: 8px;
				background-color: #ff5c00;
				color: white;
				transition: all 0.3s ease;
			}

			.big-button:hover {
				background-color: #e64a00;
				transform: scale(1.03);
			}

			.tab-menu {
				display: flex;
				gap: 12px;
				justify-content: center;
				margin: 40px 0 30px;
			}


			.tab-btn {
				padding: 12px 24px;
				border: none;
				border-radius: 999px;
				background-color: #f6f6f6;
				font-size: 16px;
				font-weight: 500;
				color: #444;
				cursor: pointer;
				transition: all 0.2s ease;
				box-shadow: inset 0 0 0 1px #ddd;
			}

			.tab-btn:hover {
				background-color: #ffece1;
				color: #ff5c00;
			}

			.tab-btn.active {
				background-color: #ff5c00;
				color: #fff;
				font-weight: 600;
				box-shadow: none;
			}

			* {
				font-family: 'Noto Sans KR', sans-serif;
			}
		</style>

	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">

			<!-- 상단 탭 메뉴 -->
			<div class="tab-menu">
				<button class="tab-btn" :class="{ active: currentTab === 'notice' }"
					@click="currentTab = 'notice'">공지사항</button>
				<button class="tab-btn" :class="{ active: currentTab === 'help' }" @click="currentTab = 'help'">이용
					문의</button>
				<button class="tab-btn" :class="{ active: currentTab === 'guide' }" @click="currentTab = 'guide'">사건 종류
					가이드</button>
			</div>

			<!-- 탭 내용 -->

			<!-- 공지사항 -->
			<div v-if="currentTab === 'notice'">
				<div class="flex-between mb-20" style="align-items: center; font-family: var(--font-main);">
					<div style="display: flex; gap: 10px; flex-wrap: wrap;">
						<select v-model="searchOption" class="search-select">
							<option value="all">:: 전체 ::</option>
							<option value="title">제목</option>
							<option value="writer">작성자</option>
						</select>
						<input v-model="keyword" @keyup.enter="fnNoticeList" class="search-input" placeholder="검색어 입력">
						<button @click="fnNoticeList" class="btn btn-primary">검색</button>
					</div>
					<select v-model="pageSize" @change="fnNoticeList" class="search-select" style="min-width: 100px;">
						<option value="5">5개씩</option>
						<option value="10">10개씩</option>
						<option value="15">15개씩</option>
						<option value="20">20개씩</option>
					</select>
				</div>

				<div class="card mb-20" v-for="item in list" :key="item.totalNo" @click="fnNoticeView(item.totalNo)"
					style="cursor:pointer;">
					<h3>{{ item.totalTitle }}</h3>
					<p>작성자: {{ item.userId }}</p>
					<p>작성일: {{ item.cdate }}</p>
				</div>

				<div class="flex-center mt-40">
					<button @click="prevPage" :disabled="page === 1">〈</button>
					<button v-for="n in index" :key="n" @click="goToPage(n)"
						:class="['btn', page === n ? 'btn-primary' : 'btn-outline']" class="mx-1">{{ n }}</button>
					<button @click="nextPage" :disabled="page === index">〉</button>
				</div>
			</div>

			<!-- 이용문의 -->
			<div v-else-if="currentTab === 'help'">
				<div class="flex-between mb-20" style="align-items: center; font-family: var(--font-main);">
					<div style="display: flex; gap: 10px; flex-wrap: wrap;">
						<select v-model="searchOption" class="search-select">
							<option value="all">:: 전체 ::</option>
							<option value="title">제목</option>
							<option value="writer">작성자</option>
						</select>
						<input v-model="keyword" @keyup.enter="fnHelpList" class="search-input" placeholder="검색어 입력">
						<button @click="fnHelpList" class="btn btn-primary">검색</button>
					</div>
					<select v-model="pageSize" @change="fnHelpList" class="search-select" style="min-width: 100px;">
						<option value="5">5개씩</option>
						<option value="10">10개씩</option>
						<option value="15">15개씩</option>
						<option value="20">20개씩</option>
					</select>
				</div>

				<div class="card mb-20" v-for="item in list" :key="item.totalNo" @click="fnHelpView(item.totalNo)"
					style="cursor:pointer;">
					<h3>{{ item.totalTitle }}</h3>
					<p>작성자: {{ item.userId }}</p>
					<p>작성일: {{ item.cdate }}</p>
				</div>

				<div class="flex-center mt-40">
					<button @click="prevPage" :disabled="page === 1">〈</button>
					<button v-for="n in index" :key="n" @click="goToPage(n)"
						:class="['btn', page === n ? 'btn-primary' : 'btn-outline']" class="mx-1">{{ n }}</button>
					<button @click="nextPage" :disabled="page === index">〉</button>
				</div>
			</div>

			<!-- 사건 종류 가이드 -->
			<div v-else-if="currentTab === 'guide'">
				<div class="guide-toggle-box mb-20">

					<div v-if="showGuide" class="guide-summary mt-10">
						<!-- 카드 6개만 보여주기 -->
						<div class="guide-card-grid">
							<div v-for="card in cards.slice(0, 6)" :key="card.title" class="mini-card">
								<strong class="card-title">{{ card.title }}</strong>
								<p class="card-summary">
									{{ card.summary }}
									<span class="arrow-icon">→</span>
								</p>
							</div>
						</div>

						<!-- 클릭 유도 문장 -->
						<p class="mt-10" style="font-size:14px; color:#777;">
							이 외에도 사고 유형별 더 다양한 예시와 설명이 준비되어 있어요.
						</p>

						<div class="text-center mt-20">
							<a href="/totalDocs/guide.do" target="_blank" class="btn btn-primary big-button">
								전체 가이드 보기
							</a>
						</div>
					</div>
				</div>
			</div>



			<!-- 우측 하단 버튼 -->
			<div class="fab-wrapper">
				<!-- 글쓰기 버튼: 조건부 렌더링 -->
				<button class="fab-btn" v-if="(sessionStatus === 'A' && currentTab === 'notice') || 
			 								(sessionStatus === '' && currentTab === 'help')" @click="goToAddPage">
					＋ 글쓰기
				</button>

				<!-- 맨 위로 버튼 -->
				<button class="fab-btn" v-show="showScrollBtn" @click="scrollToTop">↑ 맨 위로</button>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					list: [],
					keyword: "",
					searchOption: "all",
					page: 1,
					pageSize: 5,
					index: 0,
					showScrollBtn: false, // 맨위로 버튼
					currentTab: "notice", // 기본 탭,
					kind: "${map.kind}", //글종류 : NOTICE, HELP, GUIDE
					sessionStatus: '',//"${sessionStatus}"
					showGuide: true,
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
					]

				};
			},
			methods: {
				fnNoticeList() {
					const self = this;
					const params = {
						kind: 'NOTICE',
						keyword: self.keyword,
						searchOption: self.searchOption,
						page: (self.page - 1) * self.pageSize,
						pageSize: self.pageSize
					};
					$.ajax({
						url: "/totalDocs/list.dox",
						type: "POST",
						dataType: "json",
						data: params,
						success: function (data) {
							self.list = data.list;
							self.index = Math.ceil(data.count / self.pageSize);
						}
					});
				},
				fnHelpList() {
					const self = this;
					const params = {
						kind: 'HELP',
						keyword: self.keyword,
						searchOption: self.searchOption,
						page: (self.page - 1) * self.pageSize,
						pageSize: self.pageSize
					};
					$.ajax({
						url: "/totalDocs/list.dox",
						type: "POST",
						dataType: "json",
						data: params,
						success: function (data) {
							self.list = data.list;
							self.index = Math.ceil(data.count / self.pageSize);
						}
					});
				},
				fnNoticeView(totalNo) {
					pageChange("/totalDocs/detail.do", { totalNo: totalNo, kind: 'NOTICE' });
				},
				fnHelpView(totalNo) {
					pageChange("/totalDocs/detail.do", { totalNo: totalNo, kind: 'HELP' });
				},

				//페이징-페이지 이동
				goToPage(n) {
					this.page = n;
					if (this.currentTab === 'notice') {
						this.fnNoticeList();
					} else if (this.currentTab === 'help') {
						this.fnHelpList();
					}
				},
				//페이징-이전페이지
				prevPage() {
					if (this.page > 1) {
						this.page--;
						if (this.currentTab === 'notice') {
							this.fnNoticeList();
						} else if (this.currentTab === 'help') {
							this.fnHelpList();
						}
					}
				},
				//페이징-다음페이지
				nextPage() {
					if (this.page < this.index) {
						this.page++;
						if (this.currentTab === 'notice') {
							this.fnNoticeList();
						} else if (this.currentTab === 'help') {
							this.fnHelpList();
						}
					}
				},
				//맨 위로
				scrollToTop() {
					window.scrollTo({ top: 0, behavior: 'smooth' });
				},
				//첫 화면에 맨위로 버튼 안 보이게.
				handleScroll() {
					this.showScrollBtn = window.scrollY > 100;
				},
				//글쓰기
				goToAddPage() {
					if (this.currentTab === 'notice') {
						pageChange("/totalDocs/addNotice.do", {});
					} else if (this.currentTab === 'help') {
						pageChange("/totalDocs/addHelp.do", {});
					}
				}
			},
			watch: {
				currentTab(newVal) {
					if (newVal === 'notice') {
						this.fnNoticeList();
					} else if (newVal === 'help') {
						this.fnHelpList();
					}
				}
			},
			mounted() {
				if (this.kind === "NOTICE" || this.kind == '') {
					this.currentTab = "notice";
					this.fnNoticeList();
				} else if (this.kind === "HELP") {
					this.currentTab = "help";
					this.fnHelpList();
				}
				window.addEventListener("scroll", this.handleScroll);
			},
			beforeUnmount() {
				window.removeEventListener("scroll", this.handleScroll);
			}
		});
		app.mount("#app");
	</script>

	</html>