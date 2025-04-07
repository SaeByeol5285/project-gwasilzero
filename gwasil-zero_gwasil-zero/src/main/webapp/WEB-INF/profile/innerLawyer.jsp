<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <title>소속 변호사</title>
        <link rel="stylesheet" href="/css/profile.css">
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="inLawApp">
            <div class="layout">
                <div class="content">
                    <div class="content-wrapper">
                        <div class="title-area">
                            <h2>소속 변호사</h2>
                            <a href="javascript:;" @click="fnMove">개인 변호사 &gt;</a>
                        </div>

                        <div class="filter-bar">
                            <label>변호사 찾기</label>
                            <select v-model="searchOption">
                                <option value="all">::전체::</option>
                                <option value="name">이름</option>
                                <option value="txt">키워드</option>
                            </select>
                            <input type="text" v-model="keyword" @keyup.enter="fnGetList" placeholder="검색어">
                            <button @click="fnGetList" class="btn">검색</button>
                        </div>
                        <div class="lawyer-list">
                            <div class="lawyer-card" v-for="item in list" :key="item.lawyerId"
                                @click="fnView(item.lawyerId)">
                                <div class="profile-pic">
                                    <img v-if="item.lawyerImg" :src="item.lawyerImg" alt="프로필 사진" />
                                    <div v-else class="no-data">등록된 프로필 사진이 없습니다.</div>
                                </div>
                                <div v-if="item.mainCategoryName1 || item.mainCategoryName2" class="category-badges">
                                    <span v-if="item.mainCategoryName1" class="badge">{{ item.mainCategoryName1 }}</span>
                                    <span v-if="item.mainCategoryName2" class="badge">{{ item.mainCategoryName2 }}</span>
                                </div>
                                <div v-else class="no-data">선택된 전문분야가 없습니다.</div>
                                <div class="lawyer-name">{{item.lawyerName}}</div>
                                <div class="intro">소개 : <span v-html="item.lawyerInfo"></span></div>
                            </div>
                        </div>
                        <div class="pagination">
                            <a v-if="page != 1" href="javascript:;" @click="fnPageMove('prev')"
                                class="page-btn">&lt;</a>
                            <a href="javascript:;" v-for="num in index" @click="fnPage(num)"
                                :class="{'active': page == num}" class="page-btn">{{num}}</a>
                            <a v-if="page != index" href="javascript:;" @click="fnPageMove('next')"
                                class="page-btn">&gt;</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const inLawApp = Vue.createApp({
            data() {
                return {
                    list: [],
                    keyword: "",
                    searchOption: "all",
                    index: 0,
                    page: 1
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
                        url: "/profile/innerLawyer.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.list = data.list;
                            self.index = Math.ceil(data.count / 4);
                        }
                    });
                },
                fnPage: function (num) {
                    let self = this;
                    self.page = num;
                    self.fnGetList();
                },
                fnPageMove: function (direction) {
                    let self = this;
                    if (direction == "next") {
                        self.page++;
                    } else {
                        self.page--;
                    }
                    self.fnGetList();
                },
                fnView: function (lawyerId) {
                    pageChange("/profile/view.do", { lawyerId: lawyerId });
                },
                fnMove: function () {
                    location.href = "/profile/personalLawyer.do"
                }
            },
            mounted() {
                var self = this;
                self.fnGetList();
            }
        });
        inLawApp.mount('#inLawApp');
    </script>