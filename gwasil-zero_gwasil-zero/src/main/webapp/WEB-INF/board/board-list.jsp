<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"
	            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-change.js"></script>
	<title>board-list</title>
	
</head>
<style>
	.card-container {
	    width: 66%; /* 전체 화면의 2/3 */
	    margin: 0 auto; /* 중앙 정렬 */
	    padding: 40px 20px;
	  }
	.card-grid {
	  display: grid;
	  grid-template-columns: repeat(3, 1fr); /* 한 줄에 3개 */
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

	.thumbnail {
	  width: 100%;
	  height: 180px;
	  object-fit: cover;
	  border-radius: 8px;
	  margin-bottom: 12px;
	}

	.category-wrap {
		width: 66%;
		margin: 20px auto; /* 중앙 정렬 + 위아래 여백 */
		display: flex;
		flex-wrap: wrap;
		gap: 12px; /* 버튼 간 간격 */
		justify-content: center; /* 가운데 정렬 */
	}

	.category-btn {
		border: 1px solid var(--main-color); /* 기존 #ccc → 주황색 변수 */
		border-radius: 999px;
		padding: 8px 18px;
		background-color: white;
		cursor: pointer;
		font-size: 14px;
		transition: all 0.2s ease;
		color: gray;
	}

	.category-btn:hover {
		background-color: #f0f0f0;
	}

	.category-btn.active {
		background-color: #FF5722;
		color: white;
		border-color: #FF5722;
	}

	.search-bar {
			display: flex;
			justify-content: center;
			align-items: center;
			gap: 10px;
			margin: 20px auto;
			width: 66%;
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


</style>
<body>
	<jsp:include page="../common/header.jsp"/>
	<div id="app">
		<div class="category-wrap">
		  <button 
		    v-for="cat in categoryList" 
		    :key="cat.value"
		    @click="selectCategory(cat.value)"
		    :class="['category-btn', category === cat.value ? 'active' : '']"
		  >
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
			<button @click="fnBoardList" class="btn btn-primary">검색</button>
			<button @click="goToAddPage" class="btn btn-outline">글 작성</button>
		</div>
		
		<div class="card-container">
		  <div class="card-grid">
		    <div class="box" v-for="item in list" :key="item.boardNo" @click="fnBoardView(item.boardNo)">
		      <img 
		        v-if="item.thumbnailPath" 
		        :src="item.thumbnailPath.replace('../', '/')" 
		        alt="썸네일" 
		        class="thumbnail"
		        @error="e => e.target.src='/img/common/image_not_exist.jpg'" 
		      />
		      <img 
		        v-else 
		        src="/img/common/image_not_exist.jpg" 
		        alt="기본 썸네일" 
		        class="thumbnail" 
		      />
		      <h3>{{ item.boardTitle }}</h3>
		      <p>작성자: {{ item.userId }}</p>
		      <p>상태: {{ item.boardStatus }}</p>
			  <p>담당 변호사: {{ item.lawyerName }}</p>
		    </div>
		  </div>
		</div>

		<div style="text-align: center; margin-top: 40px;">
		  <button @click="prevPage" :disabled="page === 1">〈</button>
		  
		  <button 
		    v-for="n in index" 
		    :key="n" 
		    @click="goToPage(n)" 
		    :style="{ 
		      margin: '0 4px', 
		      fontWeight: page === n ? 'bold' : 'normal',
		      backgroundColor: page === n ? '#007bff' : '#fff',
		      color: page === n ? '#fff' : '#000',
		      border: '1px solid #ccc',
		      borderRadius: '4px',
		      padding: '4px 8px',
			  cursor : 'pointer'
		    }"
		  >
		    {{ n }}
		  </button>
		  
		  <button @click="nextPage" :disabled="page === index">〉</button>
		</div>		
		
	</div>
	<jsp:include page="../common/footer.jsp"/>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : [],
				sessionId : "${sessionScope.sessionId}",
				categoryList: [
					{ value: "all", label: "전체 사고 보기" },
				  { value: "01", label: "신호위반 사고" },
				  { value: "02", label: "비보호 좌회전 중 사고" },
				  { value: "03", label: "황색주의 신호위반 사고" },
				  { value: "04", label: "일방통행 금지위반 사고" },
				  { value: "05", label: "중앙선 침범 사고" },
				  { value: "06", label: "좌회전(또는 유턴)중 사전 중앙선침범 사고" },
				  { value: "07", label: "주정차 차량을 피하여 중앙선 침범한 사고" },
				  { value: "08", label: "고속도로 또는 자동차 전용도로에서 후진 사고" },
				  { value: "09", label: "우천 시 감속운행 위반 사고" },
				],
				category : "all", // 사고종류 
				checked : false,
				keyword : "",
				searchOption : "all",  //변호사랑 사건으로 구분
				pageSize: 9,  //3행3열로 띄우도록
				page: 1,  //현재페이지
				index : 0  //하단에 보여줄 숫자
            };
        },
        methods: {
			fnBoardList : function(){
				var self = this;
				var nparmap = {
					keyword : self.keyword, 
					searchOption : self.searchOption,
					pageSize : self.pageSize, 
					page : (self.page - 1) * self.pageSize,
					category : self.category
				};
				$.ajax({
					url:"/board/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						self.list = data.list;
						self.index = Math.ceil(data.count / self.pageSize); 
					}
				});
				
			},
			selectCategory: function(cat){
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
				location.href = "/board/add.do";
			 }
			,
			fnBoardView : function(boardNo){
				pageChange("/board/view.do", {boardNo : boardNo})
			}
			
        },
		mounted() {
			var self = this;
			self.fnBoardList();
		}  
    });
    app.mount('#app');
</script>