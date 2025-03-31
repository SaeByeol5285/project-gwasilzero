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
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
		<title>통합 자료실</title>

	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">

			<!-- 상단 탭 메뉴 -->
			<div class="tab-menu">
				<button class="tab-btn" :class="{ active: currentTab === 'notice' }"
					@click="currentTab = 'notice'">공지사항</button>
				<button class="tab-btn" :class="{ active: currentTab === 'help' }" @click="currentTab = 'help'">이용 문의</button>
				<button class="tab-btn" :class="{ active: currentTab === 'guide' }" @click="currentTab = 'guide'">사건 종류 가이드</button>
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
				<p>사건 종류 가이드 탭입니다. 요약 가이드 콘텐츠를 여기에 배치하세요.</p>
			</div>

			<!-- 우측 하단 버튼 -->
			<div class="fab-wrapper">
				<button class="fab-btn" @click="goToAddPage">＋ 글쓰기</button>
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
					kind: "${map.kind}" //글종류 : NOTICE, HELP, GUIDE
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
					pageChange("/totalDocs/add.do", {});
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