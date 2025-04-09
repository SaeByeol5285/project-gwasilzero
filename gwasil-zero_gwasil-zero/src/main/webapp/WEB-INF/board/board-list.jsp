<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
		<title>board-list</title>

	</head>
	<style>
	      .category-wrap,
	      .search-bar,
	      .card-container,
	      .pagination-container {
	         width: 1200px;
	         max-width: 100%;
	         margin: 0 auto;
	         box-sizing: border-box;
	      }

	      .card-container {
	         padding: 20px;
	      }

	      .card-grid {
	         display: grid;
	         grid-template-columns: repeat(3, 1fr);
	         gap: 24px;
	         padding: 10px;
	         margin-top: 30px;
	      }

	      .box {
	         width: 100%;
	         background-color: white;
	         border-radius: 10px;
	         box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
	         padding: 24px;
	         text-align: center;
	         transition: transform 0.2s ease, box-shadow 0.2s ease;
	         border: 1px solid #eee;
	         box-sizing: border-box;
	         cursor: pointer;
	      }

	      .box:hover {
	         transform: translateY(-5px);
	         box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
	      }

	      .box h3 {
	         margin-bottom: 10px;
	         font-size: 18px;
	         font-weight: 700;
	         color: #222;
	      }

	      .box p {
	         margin: 4px 0;
	         font-size: 14px;
	         color: #666;
	      }

	      .box p:first-of-type {
	         font-weight: 500;
	         color: #444;
	      }

	      .box p:last-of-type {
	         font-style: italic;
	         color: #999;
	      }


	      .thumbnail {
	         width: 100%;
	         height: 180px;
	         object-fit: cover;
	         border-radius: 8px;
	         margin-bottom: 12px;
	      }

	      .category-wrap {
	         margin: 20px auto;
	         display: flex;
	         justify-content: center;
	         align-items: center;
	         gap: 10px;
	         flex-wrap: wrap;
	      }

	      .category-btn {
	         padding: 10px 20px;
	         font-size: 14px;
	         font-weight: 500;
	         color: #555;
	         background-color: #fdfdfd;
	         border: 1px solid #ddd;
	         border-radius: 15px;
	         box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
	         transition: all 0.25s ease;
	         cursor: pointer;
	      }

	      .category-btn:hover {
	         transform: translateY(-2px);
	         background-color: #fff8f5;
	         box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
	      }

	      .category-btn.active {
	         background-color: #ff5c00;
	         color: #fff;
	         border-color: #ff5c00;
	         box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
	      }

	      .search-bar {
	         margin: 20px auto;
	         display: flex;
	         justify-content: center;
	         align-items: center;
	         gap: 10px;
	         flex-wrap: wrap;
	      }

	      .search-select {
	         padding: 8px 12px;
	         font-size: 14px;
	         border: 1px solid #ccc;
	         border-radius: 6px;
	      }

	      .search-input {
	         flex: 1;
	         min-width: 200px;
	         height: 20px;
	         padding: 8px 12px;
	         border: 1px solid #ccc;
	         border-radius: 6px;
	         font-size: 14px;
	      }

	      .btn {
	         padding: 8px 16px;
	         border-radius: 6px;
	         cursor: pointer;
	         font-size: 14px;
	         font-weight: 500;
	         border: none;
	      }

	      .btn-primary {
	         background-color: var(--main-color);
	         color: #fff;
	      }

	      .btn-outline {
	         background-color: #fff;
	         color: var(--main-color);
	         border: 1px solid var(--main-color);
	      }

	      .btn-primary:hover {
	         background-color: #e55300;
	      }

	      .btn-outline:hover {
	         background-color: #fff3e0;
	      }

	      .slogan-slider {
	         width: 100%;
	         max-width: 1100px;
	         margin: 0 auto 30px;
	         background-color: #f3f3f3;
	         border-radius: 12px;
	         padding: 0;
	         /* 패딩 제거 (중앙 정렬 깨지지 않음) */
	         text-align: center;
	         overflow: hidden;
	         /* 👈 위아래 잘리는 부분 숨김 */
	         height: 60px;
	         /* 👈 정확히 슬라이드 높이와 일치 */
	         display: flex;
	         align-items: center;
	         justify-content: center;
	      }

	      .swiper-slide {
	         height: 80px;
	         display: flex;
	         justify-content: center;
	         align-items: center;
	      }

	      .slogan-slide {
	         display: flex;
	         align-items: center;
	         justify-content: center;
	         gap: 12px;
	      }

	      /* 슬라이드 컨테이너에 입체 회전 느낌 */
	      .swiper-container {
	         margin-top: 30px;
	         perspective: 1000px;
	      }

	      .slogan-slider .swiper-slide {
	         transform-style: preserve-3d;
	      }

	      /* 텍스트와 아이콘 */
	      .slogan-text {
	         font-size: 20px;
	         font-weight: bold;
	         color: #333;
	      }

	      .slogan-icon {
	         font-size: 20px;
	         margin-right: 8px;
	      }


	      @keyframes fadeIn {
	         from {
	            opacity: 0;
	            transform: translateY(20px);
	         }

	         to {
	            opacity: 1;
	            transform: translateY(0);
	         }
	      }

	      .pagination-container {
	         margin-top: 40px;
	         margin-bottom: 40px;
	         display: flex;
	         justify-content: center;
	         align-items: center;
	         gap: 6px;
	      }

	      .btn {
	         padding: 10px 18px;
	         /* margin-bottom: 10px; */
	         font-size: 15px;
	         border: none;
	         border-radius: 8px;
	         background-color: #f2f2f2;
	         color: #444;
	         font-weight: 500;
	         cursor: pointer;
	         transition: all 0.2s ease;
	      }

	      .btn:hover {
	         background-color: #ffe6db;
	         color: #ff5c00;
	      }

	      .btn.active {
	         background-color: #ff5c00;
	         color: white;
	         font-weight: bold;
	         box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	      }

	      .btn:disabled {
	         opacity: 0.4;
	         cursor: default;
	      }

	      .btn.active {
	         background-color: #ff5c00;
	         color: white;
	         font-weight: bold;
	         box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	      }

	      .btn:disabled {
	         opacity: 0.4;
	         cursor: default;
	      }

	      .btn-write {
	         background-color: #ffece4;
	         color: #ff5c00;
	         font-weight: 600;
	         border: 1px solid #ffd3c1;
	      }

	      .btn-write:hover {
	         background-color: #ff6b1a;
	         /* 더 진한 주황 */
	         color: #fff;
	      }
		  
	   </style>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">

			<!-- 👇 슬라이더 멘트 영역 -->
			<div class="swiper-container slogan-slider">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<span class="slogan-icon">💬</span>
						<span class="slogan-text">당신의 억울함을 대신 말해줄 전문가들이 기다리고 있어요</span>
					</div>
					<div class="swiper-slide">
						<span class="slogan-icon">📢</span>
						<span class="slogan-text">교통사고, 이제 혼자 고민하지 마세요</span>
					</div>
					<div class="swiper-slide">
						<span class="slogan-icon">🧑‍⚖️</span>
						<span class="slogan-text">전문 변호사와 함께 억울함을 해결하세요</span>
					</div>
				</div>
			</div>
			<div class="category-wrap">
				<button v-for="cat in categoryList" :key="cat.value" @click="selectCategory(cat.value)"
					:class="['category-btn', category === cat.value ? 'active' : '']">
					{{ cat.label }}
				</button>
			</div>
			<div class="search-bar">
				<select v-model="searchOption" class="search-select">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="name">변호사</option>
				</select>
				<input v-model="keyword" @keyup.enter="fnBoardList" class="search-input" placeholder="검색어를 입력하세요">
				<button @click="fnBoardList" class="btn">검색</button>
				<button v-if="sessionType != 'lawyer'" @click="goToAddPage" class="btn btn-write">글 작성</button>
			</div>

			<div class="card-container">
				<div class="card-grid">
					<div class="box" v-for="item in list" :key="item.boardNo" @click="fnBoardView(item.boardNo)">
						<img v-if="item.thumbnailPath" :src="item.thumbnailPath.replace('../', '/')" alt="썸네일"
							class="thumbnail" @error="e => e.target.src='/img/common/image_not_exist.jpg'" />
						<img v-else src="/img/common/image_not_exist.jpg" alt="기본 썸네일" class="thumbnail" />
						<h3>{{ item.boardTitle }}</h3>
						<p>작성자: {{ item.userId }}</p>
						<p>상태: {{ item.boardStatus }}</p>
						<p>담당 변호사: {{ item.lawyerName }}</p>
					</div>
				</div>
			</div>
			<div class="pagination-container">
				<button class="btn" @click="prevPage" :disabled="page === 1">〈 이전</button>
				<button v-for="n in index" :key="n" @click="goToPage(n)" :class="['btn', page === n ? 'active' : '']">
					{{ n }}
				</button>
				<button class="btn" @click="nextPage" :disabled="page === index">다음 〉</button>
			</div>

		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>
	<script>
		window.addEventListener('load', function () {
			const swiper = new Swiper('.swiper-container', {
				loop: true,
				direction: 'vertical', // 👈 위로 올라가는 전환
				autoplay: {
					delay: 2500, // 정지 시간
				},
				speed: 1000, // 전환 속도 (천천히)
				allowTouchMove: false
			});
		});

		const app = Vue.createApp({
			data() {
				return {
					list: [],
					sessionId: "${sessionScope.sessionId}",
					sessionType: "${sessionType}",
					categoryList: [
						{ value: "all", label: "전체" },
						{ value: "01", label: "신호 위반" },
						{ value: "02", label: "보행자 사고" },
						{ value: "03", label: "음주/무면허 사고" },
						{ value: "04", label: "끼어들기/진로 변경" },
						{ value: "05", label: "주차/문 개방" },
						{ value: "06", label: "중앙선 침범" },
						{ value: "07", label: "과속/안전거리 미확보" },
						{ value: "08", label: "역주행/일방통행" },
						{ value: "09", label: "불법 유턴/좌회전" },
						{ value: "10", label: "기타/복합 사고" }
					],
					category: "all", // 사고종류 
					checked: false,
					keyword: "",
					searchOption: "all",  //변호사랑 사건으로 구분
					pageSize: 9,  //3행3열로 띄우도록
					page: 1,  //현재페이지
					index: 0  //하단에 보여줄 숫자
				};
			},
			methods: {
				fnBoardList: function () {
					var self = this;
					var nparmap = {
						keyword: self.keyword,
						searchOption: self.searchOption,
						pageSize: self.pageSize,
						page: (self.page - 1) * self.pageSize,
						category: self.category
					};
					$.ajax({
						url: "/board/list.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							self.list = data.list;
							self.index = Math.ceil(data.count / self.pageSize);
						}
					});

				},
				selectCategory: function (cat) {
					console.log(cat);
					let self = this;
					self.keyword = "";
					self.searchOption = "all";
					self.category = cat;
					self.fnBoardList();
				},
				goToPage(n) {
					this.page = n;
					this.fnBoardList();
				},

				prevPage() {
					if (this.page > 1) {
						this.page--;
						this.fnBoardList();
					}
				},
				nextPage() {
					if (this.page < this.index) {
						this.page++;
						this.fnBoardList();
					}
				},
				goToAddPage: function () {
					if (!this.sessionId || this.sessionId === "") {
						Swal.fire({
							title: "작성 불가!",
							text: "로그인 후 이용하실 수 있습니다.",
							icon: "warning",
							showCancelButton: true,
							confirmButtonColor: "#ff5c00", // 주황색
							cancelButtonColor: "#aaa",
							confirmButtonText: "로그인하러 가기",
							cancelButtonText: "취소"
						}).then((result) => {
							if (result.isConfirmed) {
								location.href = "/user/login.do";
							}
						});
						return;
					}
					location.href = "/board/add.do";
				}
				,
				fnBoardView: function (boardNo) {
					pageChange("/board/view.do", { boardNo: boardNo })
				}

			},
			mounted() {
				var self = this;
				const params = new URLSearchParams(window.location.search);
				const categoryParam = params.get('category');
				if (categoryParam) {
					self.category = categoryParam;
				}
				self.fnBoardList();
			}
		});
		app.mount('#app');
	</script>