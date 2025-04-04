<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<title>관리자 회원관리</title>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <div id="userApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />

            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
                <h2>회원 관리</h2>
                <div class="content-container">
                    <div>
                        <h3>최근 가입 회원</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>등급</th>
                                <th>가입일자</th>
                            </tr>
                            <tr v-for="newMem in newMemList">
                                <td>{{newMem.userName}}</td>
                                <td>{{newMem.userId}}</td>
                                <td>
                                    <span v-if="newMem.userStatus === 'ADMIN'">관리자</span>
                                    <span v-else-if="newMem.userStatus === 'NORMAL'">일반 회원</span>
                                    <span v-else-if="newMem.userStatus === 'OUT'">탈퇴 회원</span>
                                    <span v-else>{{ newMem.userStatus }}</span>
                                </td>
                                <td>{{newMem.cdate}}</td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        <h3>회원 목록</h3>
                        <div class="filter-bar">
                            <select v-model="searchPeriod">
                                <option value="ALL">기간설정</option>
                                <option value="WEEK">1주</option>
                                <option value="MONTH">1달</option>
                                <option value="YEAR">1년</option>
                            </select>
    
                            <select v-model="searchStatus">
                                <option value="ALL">회원 분류</option>
                                <option value="Out">탈퇴</option>
                                <option value="paid">유료회원</option>
                                <option value="free">무료회원</option>
                            </select>
                            <input type="text" v-model="searchWord" @keyup.enter="fnUserList" placeholder="이름 혹은 패키지 검색" />
                            <button @click="fnUserList">검색</button>
                            <span class="result-count">
                                총 {{ userTotalCount }}명 검색됨
                            </span>
                        </div>
                    
                        <!-- 결과 테이블 자리 -->
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>회원분류</th>
                                <th>신고회수</th>
                                <th>구매상품</th>
                                <th>가입일자</th>
                            </tr>
                            <tr v-for="user in userList" :key="user.userId">
                                <td>{{ user.userName }}</td>
                                <td>{{ user.userId }}</td>
                                <td>
                                    <span v-if="user.userStatus === 'ADMIN'">관리자</span>
                                    <span v-else-if="user.userStatus === 'NORMAL'">일반 회원</span>
                                    <span v-else-if="user.userStatus === 'OUT'">탈퇴 회원</span>
                                    <span v-else>{{ user.userStatus }}</span>
                                </td>
                                <td>{{ user.reportCnt }}</td>
                                <td>{{ user.packageName }}</td>
                                <td>{{ user.cdate }}</td>
                            </tr>
                        </table>
                        <div class="pagination">
                            <a v-if="userPage != 1" href="javascript:;" @click="fnUserPageMove('prev')" class="page-btn">&lt;</a>
                            <a href="javascript:;" v-for="num in userPageCount" @click="fnUserPage(num)" 
                               :class="{'active': userPage == num}" class="page-btn">{{num}}</a>
                            <a v-if="userPage != userPageCount" href="javascript:;" @click="fnUserPageMove('next')" class="page-btn">&gt;</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> 
    <jsp:include page="../common/footer.jsp" /> 
</body>
</html>
<script>
    const userApp = Vue.createApp({
        data() {
            return {
                newMemList: [],
                userList: [],
                userTotalCount: 0,
                searchPeriod: 'ALL', 
                searchStatus: 'ALL',
                searchWord: '',
                userPage: 1,
                userPageSize: 5,
                userPageCount: 0  
            };
        },
        methods: {
            fnNewMemList(){
				var self = this;
				var nparmap = {

				};
				$.ajax({
					url:"/admin/newMemList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
                        self.newMemList = data.newMemList;
					}
				});
            },
            fnUserList(){
                var self = this;
				var nparmap = {
					status: self.searchStatus,
                    period: self.searchPeriod,
                    word: self.searchWord,
                    pageSize: self.userPageSize,
                    page: (self.userPage - 1) * self.userPageSize
				};
                $.ajax({
					url:"/admin/userList.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
                        self.userList = data.userList;
                        self.userTotalCount = data.count;
                        self.userPageCount = Math.ceil(data.count / self.userPageSize);

                        // 현재 페이지에 데이터가 하나만 있고 삭제된 경우 페이지 이동
                        if (self.userList.length === 0 && self.userPage > 1) {
                            self.userPage--;
                            self.fnUserList(); // 다시 불러오기
                        }
					}
				});
            },
            fnUserPage(num) {
                var self = this;
                self.userPage = num;
                self.fnUserList();
            },
            fnUserPageMove(direction) {
                var self = this;
                if (direction === 'next') self.userPage++;
                else self.userPage--;
                self.fnUserList();
            }
        },
        mounted() {
            var self = this;
            self.fnNewMemList();
            self.fnUserList();
        }
    });
    userApp.mount('#userApp');
</script>