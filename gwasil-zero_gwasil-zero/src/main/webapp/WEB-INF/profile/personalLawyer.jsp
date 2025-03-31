<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-change.js"></script>
	<title>개인 변호사</title>
    <link rel="stylesheet" href="../css/profile.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />
<<<<<<< HEAD
=======

>>>>>>> branch 'master' of https://github.com/SaeByeol5285/project-gwasilzero.git
	<div id="perLawApp">
		<div class="title-area">
            <h2>개인 변호사</h2>
            <a href="javascript:;" @click="fnMove">소속 변호사 &gt;</a>
        </div>
        <div class="content-wrapper">
            <div class="lawyer-list">
                <div class="lawyer-card" v-for="item in list" :key="item.lawyerId" @click="fnView(item.lawyerId)">
                    <div class="profile-pic">프로필 사진</div>
                    <div class="lawyer-name">{{item.lawyerName}}</div>
                    <div class="intro">소개 : {{item.lawyerInfo}}</div>
                </div>
            </div>
            <div class="search-area">
                <label>변호사 찾기</label>
                <select v-model="searchOption" class="select-box">
                    <option value="all">::전체::</option>
                    <option value="name">이름</option>
                    <option value="txt">키워드</option>
                </select>
                <input v-model="keyword" @keyup.enter="fnGetList" placeholder="검색어" class="input-box">
                <button @click="fnGetList" class="btn">검색</button>
            </div>
            <div class="pagination">
                <a v-if="page != 1" href="javascript:;" @click="fnPageMove('prev')">&lt;</a>
                <a href="javascript:;" v-for="num in index" @click="fnPage(num)">{{num}}</a>
                <a v-if="page != index" href="javascript:;" @click="fnPageMove('next')">&gt;</a>
            </div>
        </div>
	</div>
    <jsp:include page="../common/footer.jsp" />
<<<<<<< HEAD
=======

>>>>>>> branch 'master' of https://github.com/SaeByeol5285/project-gwasilzero.git
</body>
</html>
<script>
    const perLawApp = Vue.createApp({
        data() {
            return {
				list : [],
				keyword : "",
				searchOption : "all",
				index : 0,
                page : 1 
            };
        },
        methods: {
            fnGetList(){
				var self = this;
				var nparmap = {
					keyword : self.keyword,
					searchOption : self.searchOption,
					page : (self.page-1) * 4
				};
				$.ajax({
					url:"/profile/personalLawyer.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						self.list = data.list;
						self.index = Math.ceil(data.count / 4);
					}
				});
            },
			fnPage: function(num){
                let self = this;
                self.page = num;
                self.fnGetList();
            },
            fnPageMove: function(direction){
                let self = this;
                if(direction == "next"){
                    self.page++;
                } else {
                    self.page--;
                }
                self.fnGetList();
            },
			fnView: function(lawyerId){
				pageChange("/profile/view.do", {lawyerId : lawyerId});
			},
            fnMove: function(){
                location.href = "/profile/innerLawyer.do"
            }
        },
        mounted() {
            var self = this;
			self.fnGetList();
        }
    });
    perLawApp.mount('#perLawApp');
</script>
​