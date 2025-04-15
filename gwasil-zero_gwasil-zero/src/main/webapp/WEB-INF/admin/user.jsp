<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
	      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
</head>
<body>
    <div id="userApp">
        <jsp:include page="layout.jsp" />
        <div class="content">
            <h2>회원 관리</h2>
            <div class="content-container">
                <div>
                    <h3>최근 가입 회원</h3>
                    <table>
                        <tr>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>전화번호</th>
                            <th>이메일</th>
                            <th>등급</th>
                            <th>가입일자</th>
                        </tr>
                        <tr v-for="newMem in newMemList">
                            <td>{{newMem.userName}}</td>
                            <td>{{newMem.userId}}</td>
                            <td>{{newMem.userPhone}}</td>
                            <td>{{newMem.userEmail}}</td>
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
                    <div class="filter-bar" style="margin-bottom: 30px;">
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
                    <div class="pagination-container">
                        <button class="btn" @click="prevPage" :disabled="userPage === 1">〈 이전</button>
                        <button 
                           v-for="n in userPageCount" 
                           :key="n" 
                           @click="goToPage(n)" 
                           :class="['btn', userPage === n ? 'active' : '']">
                           {{ n }}
                        </button>
                        <button class="btn" @click="nextPage" :disabled="userPage === userPageCount">다음 〉</button>
                     </div>  
                </div>
            </div>
        </div>
        </div> <!-- 여기서 layout 닫기  -->
    </div> 
</body>
</html>
<script>
    const userApp = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
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
            goToPage(n) {
                    this.userPage = n;
                    this.fnUserList();
                },

            prevPage() {
                if (this.userPage > 1) {
                this.userPage--;
                this.fnUserList();
                }
            },
            nextPage() {
                if (this.userPage < this.userPageCount) {
                    this.userPage++;
                    this.fnUserList();
                }
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