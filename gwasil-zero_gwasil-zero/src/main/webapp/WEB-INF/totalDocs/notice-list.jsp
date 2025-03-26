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
		<title>공지사항</title>
		<style>
			.fab-wrapper {
				position: fixed;
				bottom: 30px;
				right: 30px;
				display: flex;
				gap: 10px;
				z-index: 999;
			}

			.fab-btn {
				background-color: var(--main-color);
				color: white;
				border: none;
				border-radius: 20px;
				padding: 10px 16px;
				font-size: 14px;
				font-weight: 500;
				box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
				cursor: pointer;
				transition: background-color 0.2s;
			}

			.fab-btn:hover {
				background-color: #ff5c00;
			}
		</style>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<!-- 📌 메인 검색/옵션 줄 -->
			<div class="flex-between mb-20" style="align-items: center; font-family: var(--font-main);">
				<!-- 왼쪽: 검색창 그룹 -->
				<div style="display: flex; gap: 10px; flex-wrap: wrap;">
					<select v-model="searchOption" class="search-select">
						<option value="all">:: 전체 ::</option>
						<option value="title">제목</option>
						<option value="writer">작성자</option>
					</select>
					<input v-model="keyword" @keyup.enter="fnNoticeList" class="search-input" placeholder="검색어 입력">
					<button @click="fnNoticeList" class="btn btn-primary">검색</button>
				</div>

				<!-- 오른쪽: 페이지 개수 드롭다운 -->
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

			<div class="fab-wrapper">
				<button class="fab-btn" @click="goToAddPage">＋ 글쓰기</button>
				<button class="fab-btn" v-show="showScrollBtn" @click="scrollToTop">↑ 맨 위로</button>
			</div>

		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>

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
					showScrollBtn: false

				};
			},
			methods: {
				fnNoticeList() {
					const self = this;
					const params = {
						keyword: self.keyword,
						searchOption: self.searchOption,
						page: (self.page - 1) * self.pageSize,
						pageSize: self.pageSize
					};
					$.ajax({
						url: "/notice/list.dox",
						type: "POST",
						dataType: "json",
						data: params,
						success: function (data) {
							self.list = data.list;
							self.index = Math.ceil(data.count / self.pageSize);
						}
					});
				},
				goToPage(n) {
					this.page = n;
					this.fnNoticeList();
				},
				prevPage() {
					if (this.page > 1) {
						this.page--;
						this.fnNoticeList();
					}
				},
				nextPage() {
					if (this.page < this.index) {
						this.page++;
						this.fnNoticeList();
					}
				},
				fnNoticeView(noticeNo) {
					pageChange("/notice/detail.do", { noticeNo: noticeNo });
				},
				scrollToTop() {
					window.scrollTo({ top: 0, behavior: 'smooth' });
				},
				handleScroll() {
					this.showScrollBtn = window.scrollY > 100;
				},
				goToAddPage() {
					pageChange("/notice/add.do", {});
				}
				
			},
			mounted() {
				this.fnNoticeList();
				window.addEventListener("scroll", this.handleScroll);
			},
			beforeUnmount() {
				window.removeEventListener("scroll", this.handleScroll);
			}
		}
		);
		app.mount("#app");
	</script>