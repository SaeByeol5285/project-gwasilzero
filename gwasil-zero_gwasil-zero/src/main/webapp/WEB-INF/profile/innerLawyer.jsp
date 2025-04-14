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
                    <div>
                        <h2 class="section-subtitle">변호사</h2>
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
                        <button
                            class="lawMove-btn"
                            :class="{ 'active': currentPage === 'searchLawyer' }"
                            @click="fnMove('searchLawyer')">
                            <span>법률 사무소 찾기</span>
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
                            <input type="text" v-model="keyword" @keyup.enter="fnGetList" placeholder="검색어를 입력하세요!">
                            <button @click="fnGetList">검색</button>
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
                                <div class="intro">
                                    <span v-if="item.lawyerInfo" v-html="truncateText(item.lawyerInfo, 100)"></span>
                                    <span v-else class="no-data">등록된 소개가 없습니다.</span>
                                </div>
                                <div class="lawyer-icons">
                                    <div class="icon-item" @click.stop="startChat(item.lawyerId)">
                                        <img src="/img/common/call.png" class="icon" />
                                        <div class="icon-label">전화상담</div>
                                    </div>
                                    <div class="icon-item" @click.stop="toggleBookmark(item.lawyerId)">
                                        <img :src="isBookmarked(item.lawyerId) ? '/img/selectedBookmark.png' : '/img/common/bookmark.png'" class="icon" />
                                        <div class="icon-label">북마크</div>
                                    </div>
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
        const inLawApp = Vue.createApp({
            data() {
                return {
                    list: [],
                    bookmarkList: [],
                    sessionId: "${sessionId}",
                    keyword: "",
                    searchOption: "all",
                    index: 0,
                    page: 1,
                    currentPage: 'innerLawyer',
                    sessionType: "${sessionType}"
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
                            console.log(`.             |
  　╲　　　　　　　　　　　╱
  　　　　　　　　/
  　　　╲　　　　　　　　╱
  　　╲　　    　　　　　╱
  -　-　　　　저기요　　　-　-
  　　╱　   　　　　　　╲
  　╱　　/             .
  　　╱　　　　　　　　╲
  　　　　　/　|　　　
  　　　　　　　.
         
.           |
　╲　　　　　　　　　　　╱
　　　　　　　　　/
　　　╲　　　　　　　　╱
　　╲　　    설마...　　　╱
-　-　　　제 목소리가　　-　-　-
　　╱　   들리시나요?　　╲
　╱　　/               .
　　╱　　　　　　　　╲
　　　　　/　|　　　
　　　　　　　.
`, "color: #7b68ee; font-size: 14px; font-family: monospace; font-weight: bold;");
                            self.list = data.list;
                            console.log("✅ 변호사 정보 로딩 완료:", data.list);
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
                    if (!target) {
                        return;
                    }

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
                    } else if (page === 'searchLawyer') {
                        this.currentPage = 'searchLawyer';
                        location.href = "/lawyer/office.do";  
                    }
                },
                truncateText(text, maxLength) {
                    if (text && text.length > 50) {
                        return text.substring(0, 50) + '...';
                    }
                    return text;
                },
                startChat(lawyerId) {
                    let self = this;
                    if(self.sessionId == null || self.sessionId == ""){
                        Swal.fire({
                                    icon: "error",
                                    title: "로그인 필요",
                                    text: "로그인 후 이용해주세요.",
                                    confirmButtonColor: "#ff5c00"
                                }).then(() => {
                            location.href = "/user/login.do";
                        });
                        return; 
                    }
                    $.ajax({
                        url: "/board/checkLawyerStatus.dox",
                        type: "POST",
                        data: {
                            sessionId: lawyerId
                        },
                        dataType: "json",
                        success: function (res) {
                            const isApproved = res.result === "true";
                            const isAuthValid = res.authResult === "true";

                            if (!isApproved) {
                                Swal.fire({
                                    icon: "error",
                                    title: "승인되지 않음",
                                    text: "아직 승인되지 않은 변호사 계정입니다.",
                                    confirmButtonColor: "#ff5c00"
                                });
                                return;
                            }

                            if (!isAuthValid) {
                                Swal.fire({
                                    icon: "info",
                                    title: "채팅 불가능",
                                    text: "변호사 등록기간이 만료된 변호사와는 채팅할 수 없습니다.",
                                    confirmButtonColor: "#ff5c00"
                                });
                                return;
                            }

                            // 조건 통과
                            $.ajax({
                                url: "/chat/findOrCreate.dox",
                                type: "POST",
                                data: {
                                    userId: self.sessionId,
                                    lawyerId: lawyerId
                                },
                                success: function (res) {
                                    let chatNo = res.chatNo;
                                    pageChange("/chat/chat.do", {
                                        chatNo: chatNo
                                    });
                                }
                            });

                        },
                        error: function () {
                            Swal.fire({
                                icon: "error",
                                title: "요청 실패",
                                text: "변호사 상태 확인 요청에 실패했습니다.",
                                confirmButtonColor: "#ff5c00"
                            });
                        }
                    });
                },
                isBookmarked(lawyerId) {
                    return this.bookmarkList.some(bm => bm.lawyerId === lawyerId);
                },
                toggleBookmark(lawyerId) {
                    const self = this;

                    if (!self.sessionId) {
                        Swal.fire({
                            icon: "warning",
                            title: "로그인 필요",
                            text: "로그인이 필요합니다.",
                            confirmButtonColor: "#ff5c00"
                        }).then(() => {
                            location.href = "/user/login.do";
                        });
                        return;
                    }

                    if (self.sessionType !== 'user') {
                        Swal.fire({
                            icon: "warning",
                            title: "이용 불가",
                            text: "변호사 사용자는 이용 불가능합니다.",
                            confirmButtonColor: "#ff5c00"
                        });
                        return;
                    }

                    const isMarked = self.isBookmarked(lawyerId);
                    const url = isMarked ? "/bookmark/remove.dox" : "/bookmark/add.dox";

                    $.ajax({
                        url: url,
                        type: "POST",
                        data: {
                            userId: self.sessionId,
                            lawyerId: lawyerId
                        },
                        success: function (data) {
                            if (isMarked) {
                                self.bookmarkList = self.bookmarkList.filter(b => b.lawyerId !== lawyerId);
                            } else {
                                self.bookmarkList.push({ lawyerId: lawyerId });
                            }
                            localStorage.setItem('bookmarkUpdated', Date.now());
                        },
                        error: function () {
                            alert("북마크 처리 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnGetBookmarkList() {
                    const self = this;
                    if (!self.sessionId) return;

                    $.ajax({
                        url: "/bookmark/list.dox",
                        type: "POST",
                        data: { sessionId: self.sessionId },
                        dataType: "json",
                        success: function (data) {
                            if (data.result === "success") {
                                self.bookmarkList = data.list;
                            }
                        }
                    });
                }
            },
            mounted() {
                var self = this;
                self.fnGetList();
                self.fnGetBookmarkList();
                window.addEventListener('storage', (e) => {
                    if (e.key === 'bookmarkUpdated') {
                        this.fnGetBookmarkList();
                    }
                });
            }
        });
        inLawApp.mount('#inLawApp');
    </script>