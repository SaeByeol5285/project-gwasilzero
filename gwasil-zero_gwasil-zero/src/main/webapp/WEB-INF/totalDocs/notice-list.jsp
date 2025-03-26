<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<title>공지사항</title>
	</head>
	<style>
		/* 기존 사고유형 코드 스타일 재사용 */
		.card-container {
			width: 66%;
			margin: 0 auto;
			padding: 40px 20px;
		}

		.card-grid {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 24px;
			margin-top: 30px;
		}

		.box {
			background: white;
			padding: 24px;
			border-radius: 10px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
			cursor: pointer;
			transition: transform 0.2s ease, box-shadow 0.2s ease;
		}

		.box:hover {
			transform: translateY(-5px);
			box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
		}

		.search-bar {
			display: flex;
			justify-content: center;
			align-items: center;
			gap: 10px;
			margin: 20px auto;
			width: 66%;
		}

		.search-select,
		.search-input {
			padding: 8px 12px;
			font-size: 14px;
			border: 1px solid #ccc;
			border-radius: 6px;
		}

		.btn {
			padding: 8px 16px;
			border-radius: 6px;
			font-size: 14px;
			font-weight: 500;
			cursor: pointer;
		}

		.btn-primary {
			background-color: #FF5722;
			color: white;
			border: none;
		}

		.btn-primary:hover {
			background-color: #e55300;
		}
	</style>

	<body>
		<jsp:include page="../common/header.jsp" />

		<div id="app">
			<select v-model="pageSize" @change="fnNoticeList">
				<option value="5">5개씩</option>
				<option value="10">10개씩</option>
				<option value="15">15개씩</option>
				<option value="20">20개씩</option>
			</select>
			<div class="search-bar">
				<select v-model="searchOption" class="search-select">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="writer">작성자</option>
				</select>
				<input v-model="keyword" @keyup.enter="fnNoticeList" class="search-input" placeholder="검색어 입력">
				<button @click="fnNoticeList" class="btn btn-primary">검색</button>
			</div>

			<div class="box" v-for="item in list" :key="item.totalNo" @click="fnNoticeView(item.totalNo)">
				<h3>{{ item.totalTitle }}</h3>
				<p>작성자: {{ item.userId}}</p>
				<p>작성일: {{ item.cdate }}</p>
			</div>


			<div style="text-align: center; margin-top: 40px;">
				<button @click="prevPage" :disabled="page === 1">〈</button>
				<button v-for="n in index" :key="n" @click="goToPage(n)" :style="{ 
        margin: '0 4px',
        fontWeight: page === n ? 'bold' : 'normal',
        backgroundColor: page === n ? '#FF5722' : '#fff',
        color: page === n ? '#fff' : '#000',
        border: '1px solid #ccc',
        borderRadius: '4px',
        padding: '4px 8px',
        cursor: 'pointer'
      }">{{ n }}</button>
				<button @click="nextPage" :disabled="page === index">〉</button>
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
					index: 0
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
							console.log(data);
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
					pageChange("/notice/detail.do", { noticeNo : noticeNo });
				}
			},
			mounted() {
				this.fnNoticeList();
			}
		});
		app.mount("#app");
	</script>