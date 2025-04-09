<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <title>개인 변호사</title>
        <link rel="stylesheet" href="/css/profile.css">
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="perLawApp">
            <div class="layout">
                <div class="content">
                    <div>
                        <h2 class="section-subtitle">개인 변호사</h2>
                    </div>
                    <div class="lawMove-menu">
                        <button
                            class="lawMove-btn"
                            :class="{ 'active': currentPage === 'innerLawyer' }"
                            @click="fnMove('innerLawyer')">
                            <span>소속 변호사</span>
                        </button>
                        <button
                            class="lawMove-btn"
                            :class="{ 'active': currentPage === 'personalLawyer' }"
                            @click="fnMove('personalLawyer')">
                            <span>개인 변호사</span>
                        </button>
                    </div>
                    <div class="content-wrapper">
                        <div class="filter-bar">
                            <label>변호사 찾기</label>
                            <select v-model="searchOption">
                                <option value="all">::전체::</option>
                                <option value="name">이름</option>
                                <option value="txt">키워드</option>
                            </select>
                            <input type="text" v-model="keyword" @keyup.enter="fnGetList" placeholder="검색어">
                            <button @click="fnGetList">검색</button>
                        </div>
                        <div class="lawyer-list">
                            <div class="lawyer-card" v-for="item in list" :key="item.lawyerId"
                                @click="fnView(item.lawyerId)">
                                <div class="profile-pic">
                                    <img v-if="item.lawyerImg" :src="item.lawyerImg" alt="프로필 사진" />
                                    <div v-else class="no-data">등록된 프로필 사진이 없습니다.</div>
                                </div>
                                <div class="lawyer-name">{{item.lawyerName}}</div>
                                <div class="intro">
                                    <span v-if="item.lawyerInfo" v-html="truncateText(item.lawyerInfo, 100)"></span>
                                    <span v-else class="no-data">등록된 소개가 없습니다.</span>
                                </div>
                            </div>
                        </div>
                        <div class="pagination-container">
                            <button class="btn" @click="prevPage" :disabled="page === 1">〈 이전</button>                         
                            <button 
                               v-for="n in index" 
                               :key="n" 
                               @click="goToPage(n)" 
                               :class="['btn', page === n ? 'active' : '']">
                               {{ n }}
                            </button>                         
                            <button class="btn" @click="nextPage" :disabled="page === index">다음 〉</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/profile/recentViewBox.jsp" />
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const perLawApp = Vue.createApp({
            data() {
                return {
                    list: [],
                    keyword: "",
                    searchOption: "all",
                    index: 0,
                    page: 1,
                    currentPage: 'personalLawyer'
                };
            },
            methods: {
                fnGetList() {
                    var self = this;
                    var nparmap = {
                        keyword: self.keyword,
                        searchOption: self.searchOption,
                        page: (self.page - 1) * 4
                    };
                    $.ajax({
                        url: "/profile/personalLawyer.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.list = data.list;
                            self.index = Math.ceil(data.count / 4);
                        }
                    });
                },
                goToPage(n) {
                    this.page = n;
                    this.fnGetList();
                },

                prevPage() {
                    if (this.page > 1) {
                    this.page--;
                    this.fnGetList();
                    }
                },
                nextPage() {
                    if (this.page < this.index) {
                        this.page++;
                        this.fnGetList();
                    }
                },
                fnView: function (lawyerId) {
                    const target = this.list.find(item => item.lawyerId === lawyerId);
                    if (!target) return;

                    var item = {
                        type: 'lawyer',
                        id: target.lawyerId,
                        name: target.lawyerName
                    };

                    var list = JSON.parse(localStorage.getItem('recentViewed') || '[]');
                    list = list.filter(i => !(i.type === item.type && i.id === item.id));
                    list.unshift(item);
                    if (list.length > 5) list = list.slice(0, 5);
                    localStorage.setItem('recentViewed', JSON.stringify(list));

                    pageChange("/profile/view.do", { lawyerId: lawyerId });
                },
                fnMove(page) {
                    if (page === 'innerLawyer') {
                        this.currentPage = 'innerLawyer';
                        location.href = "/profile/innerLawyer.do";  
                    } else if (page === 'personalLawyer') {
                        this.currentPage = 'personalLawyer';
                        location.href = "/profile/personalLawyer.do";  
                    }
                },
                truncateText(text, maxLength) {
                    if (text && text.length > 50) {
                        return text.substring(0, 50) + '...';
                    }
                    return text;
                }
            },
            mounted() {
                var self = this;
                self.fnGetList();
            }
        });
        perLawApp.mount('#perLawApp');
    </script>