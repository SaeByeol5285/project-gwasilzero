<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>관리자 회원관리</title>
</head>
<body>
    <div id="userApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />

            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
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
                            <td>{{newMem.userStatus}}</td>
                            <td>{{newMem.cdate}}</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h3>회원 목록</h3>
                    <div class="filter-bar">
                        <select v-model="searchStatus">
                            <option value="">회원 상태</option>
                            <option value="ALL">전체</option>
                            <option value="out">탈퇴</option>
                            <option value="paid">유료회원</option>
                            <option value="free">무료회원</option>
                        </select>
                
                        <select v-model="searchKey">
                            <option value="">검색 키워드</option>
                            <option value="ALL">전체</option>
                            <option value="userName">회원이름</option>
                            <option value="packageName">패키지이름</option>
                        </select>
                
                        <input type="text" v-model="searchWord" @keyup.enter="fnUserList" placeholder="검색어 입력" />
                
                        <button @click="fnSearch">검색</button>
                    </div>
                
                    <!-- 결과 테이블 자리 -->
                    <table>
                        <tr>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>회원상태</th>
                            <th>가입일자</th>
                        </tr>
                        <tr v-for="user in userList" :key="user.userId">
                            <td>{{ user.userName }}</td>
                            <td>{{ user.userId }}</td>
                            <td>{{ user.userStatus }}</td>
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
</body>
</html>
<script>
    const userApp = Vue.createApp({
        data() {
            return {
                newMemList: [],
                userList: [],
                searchStatus: '',
                searchKey: '',
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
                    key: self.searchKey,
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
                        self.userPageCount = Math.ceil(data.count / self.userPageSize);
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