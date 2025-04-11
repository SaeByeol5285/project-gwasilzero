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
			* {
				font-family: 'Noto Sans KR', sans-serif;
				box-sizing: border-box !important;
			}
		</style>

	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<h2 class="section-subtitle">통합 자료실</h2>

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
				<div class="flex-between mb-20">
					<div class="search-bar">
						<select v-model="searchOption" class="search-select">
							<option value="all">:: 전체 ::</option>
							<option value="title">제목</option>
							<option value="writer">작성자</option>
						</select>
						<input v-model="keyword" @keyup.enter="fnNoticeList" class="search-input" placeholder="검색어 입력">
						<button @click="resetPage = true; fnNoticeList" class="btn btn-primary">검색</button>
					</div>
					<select v-model="pageSize" @change="fnNoticeList" class="search-select" style="min-width: 100px;">
						<option value="5">5개씩</option>
						<option value="10">10개씩</option>
						<option value="15">15개씩</option>
						<option value="20">20개씩</option>
					</select>
				</div>

				<div class="doc-list-wrapper">
					<!-- 상단 컬럼 -->
					<div class="doc-list-header">
						<div class="col-no">번호</div>
						<div class="col-title" style="text-align: center;">제목</div>
						<div class="col-writer">작성자</div>
						<div class="col-date">작성일</div>
						<div class="col-views">조회수</div>
					</div>

					<!-- 리스트 항목 -->
					<div class="doc-list-item" v-for="item in list" :key="item.totalNo"
						@click="currentTab === 'notice' ? fnNoticeView(item.totalNo) : fnHelpView(item.totalNo)">

						<div class="col-no">{{ item.totalNo }}</div>
						<div class="col-title">
							{{ item.totalTitle }}
							<span v-if="item.fileAttached"><img src="../../img/common/file-attached.png"
									class="file-icon"></span>
						</div>
						<div class="col-writer">관리자</div>
						<div class="col-date">{{ item.cdate }}</div>
						<div class="col-views">{{ item.cnt }}</div>
					</div>
				</div>

				<div class="pagination-container">
					<button class="btn" @click="prevPage" :disabled="page === 1">〈 이전</button>
					<button v-for="n in index" :key="n" @click="goToPage(n)"
						:class="['btn', page === n ? 'active' : '']">{{ n }}</button>
					<button class="btn" @click="nextPage" :disabled="page === index">다음 〉</button>
				</div>

			</div>


			<!-- 이용문의 -->
			<div v-else-if="currentTab === 'help'">
				<div class="flex-between mb-20">
					<div class="search-bar">
						<select v-model="searchOption" class="search-select">
							<option value="all">:: 전체 ::</option>
							<option value="title">제목</option>
							<option value="writer">작성자</option>
						</select>
						<input v-model="keyword" @keyup.enter="fnNoticeList" class="search-input" placeholder="검색어 입력">
						<button @click="resetPage = true; fnNoticeList" class="btn btn-primary">검색</button>
					</div>
					<select v-model="pageSize" @change="fnNoticeList" class="search-select" style="min-width: 100px;">
						<option value="5">5개씩</option>
						<option value="10">10개씩</option>
						<option value="15">15개씩</option>
						<option value="20">20개씩</option>
					</select>
				</div>

				<div class="doc-list-wrapper">
					<!-- 상단 컬럼 -->
					<div class="doc-list-header">
						<div class="col-no">번호</div>
						<div class="col-title" style="text-align: center;">제목</div>
						<div class="col-writer">답변상태</div>
						<div class="col-writer">작성자</div>
						<div class="col-date">작성일</div>
						<div class="col-views">조회수</div>
					</div>

					<!-- 리스트 항목 -->
					<div class="doc-list-item" v-for="item in list" :key="item.totalNo"
						@click="currentTab === 'notice' ? fnNoticeView(item.totalNo) : fnHelpView(item.totalNo)">

						<div class="col-no">{{ item.totalNo }}</div>
						<div class="col-title">
							{{ item.totalTitle }}
							<span v-if="item.fileAttached"><img src="../../img/common/file-attached.png"
									class="file-icon"></span>
						</div>
						<div class="col-writer">
							<span v-if="currentTab === 'help'"
								:class="item.answerStatus === '답변완료' ? 'status-done' : 'status-pending'">
								{{ item.answerStatus }}
							</span>
						</div>
						<div class="col-writer">{{ item.userId }}</div>
						<div class="col-date">{{ item.cdate }}</div>
						<div class="col-views">{{ item.cnt }}</div>
					</div>
				</div>

				<div class="pagination-container">
					<button class="btn" @click="prevPage" :disabled="page === 1">〈 이전</button>
					<button v-for="n in index" :key="n" @click="goToPage(n)"
						:class="['btn', page === n ? 'active' : '']">{{ n }}</button>
					<button class="btn" @click="nextPage" :disabled="page === index">다음 〉</button>
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
				<button class="fab-btn" v-if="(sessionStatus === 'ADMIN' && currentTab === 'notice') || 
			 								(sessionStatus === 'NORMAL' && currentTab === 'help')" @click="goToAddPage">
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
					sessionId: "${sessionId}",
					sessionStatus: "${sessionStatus}", //ADMIN, NORMAL
					list: [],
					fileList: [],
					keyword: "",
					searchOption: "all",
					page: 1,
					pageSize: 5,
					index: 0,
					showScrollBtn: false, // 맨위로 버튼
					currentTab: "notice", // 기본 탭,
					kind: "", //글종류 : NOTICE, HELP, GUIDE
					showGuide: true,
					resetPage: false,
					cards: [
						{
							title: "1. 신호 위반",
							summary: "신호 무시 또는 신호 없는 교차로 사고",
						},

						{
							"title": "2. 보행자 사고",
							"summary": "횡단보도, 스쿨존 등 보행자와의 충돌",
						},

						{
							"title": "3. 음주/무면허 사고",
							"summary": "음주, 무면허, 졸음운전 등으로 인한 사고",
						},

						{
							"title": "4. 끼어들기 / 진로 변경",
							"summary": "방향지시 없이 차선 변경, 끼어들기 사고",
						},

						{
							"title": "5. 주차 / 문 개방 중 사고",
							"summary": "정차된 차량의 문 개방 또는 주차 중 사고",
						},

						{
							"title": "6. 중앙선 침범",
							"summary": "유턴, 추월 등으로 중앙선을 넘어 발생한 사고",
						},

						{
							"title": "7. 과속 / 안전거리 미확보",
							"summary": "속도 초과나 앞차와 거리 부족으로 인한 사고",
						},

						{
							"title": "8. 일방통행 / 역주행",
							"summary": "일방통행 위반이나 역주행으로 인한 사고",
						},

						{
							"title": "9. 불법 유턴 / 좌회전",
							"summary": "금지된 유턴/좌회전으로 인한 사고",
						},

						{
							"title": "10. 기타 / 복합 사고",
							"summary": "분류하기 어려운 특수·복합 사고",
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
							console.log(data);
							self.list = data.list;
							self.fileList = data.fileList;

							self.index = Math.ceil(data.count / self.pageSize);
							//초기 진입일 때만 페이지 1로
							if (self.resetPage) {
								self.page = 1;
								self.resetPage = false;
							}
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
							console.log(data);
							self.list = data.list;
							self.index = Math.ceil(data.count / self.pageSize);
							//초기 진입일 때만 페이지 1로
							if (self.resetPage) {
								self.page = 1;
								self.resetPage = false;
							}
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
					this.page = 1;
					if (newVal === 'notice') {
						this.fnNoticeList();
					} else if (newVal === 'help') {
						this.fnHelpList();
					}
				}
			},
			mounted() {
				const urlParams = new URLSearchParams(window.location.search);
				const kindParam = urlParams.get("kind");
				const fallbackKind = "${map.kind}" || "NOTICE";
				this.kind = kindParam || fallbackKind;

				// 탭 선택 및 초기 데이터 불러오기
				if (this.kind === "NOTICE") {
					this.currentTab = "notice";
				} else if (this.kind === "HELP") {
					this.currentTab = "help";
				} else if (this.kind === "GUIDE") {
					this.currentTab = "guide";
				}

				// 탭에 따라 초기 데이터 로딩
				this.resetPage = true;
				if (this.currentTab === "notice") {
					this.fnNoticeList();
				} else if (this.currentTab === "help") {
					this.fnHelpList();
				}
				window.addEventListener("scroll", this.handleScroll);
			}
		});
		app.mount("#app");
	</script>

	</html>