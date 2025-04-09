<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/common.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        * {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>

    <div id="header">
        <header class="main-header">

            <!-- 🔷 메인 헤더 전체 묶음 -->
            <div class="main-nav">

                <!-- ✅ 이용문의 / 로그인 줄 (제일 위) -->
                <div class="login-line">
                    <div class="login-right">
                        <a href="/totalDocs/list.do?kind=HELP">이용문의</a>
                        <a v-if="!sessionId" href="/user/login.do">로그인 / 회원가입</a>
                        <a v-else @click="fnLogout" href="#">로그아웃</a>
                    </div>
                </div>

                <!-- ✅ 로고 + 검색창 + 아이콘 줄 (그 아래) -->
                <div class="top-line">
                    <div class="left-area">
                        <a href="/common/main.do" class="logo">
                            <img src="/img/logo1.png" alt="로고 이미지" />
                        </a>
                    </div>
                    <div class="right-area">
                        <div class="header-search-bar">
                            <input type="text" placeholder="비슷한 블랙박스 영상을 찾아보세요!" />
                            <img src="/img/common/logo3.png" class="top-icon" />
                        </div>
                        <div class="header-icons">
                            <!-- 알림 -->
                            <a v-if="sessionType === 'user' || sessionType === 'lawyer'" href="javascript:void(0);"
                                class="noti-link" @click="toggleNotification" ref="notiToggle">
                                <img src="/img/common/alarm-none.png" class="top-icon" />
                                <span v-if="list.length > 0" class="noti-badge">{{ list.length > 9 ? '9+' : list.length
                                    }}</span>

                                <div v-if="showNotification" class="noti-popup" ref="notiPopup" @click.stop>
                                    <div class="noti-section" v-if="sessionType === 'user'">
                                        <h4>댓글 알림</h4>
                                        <div class="noti-list" v-if="commentNoti.length > 0">
                                            <div class="noti-item" v-for="item in commentNoti" :key="item.notiNo"
                                                @click="markAsRead(item)">
                                                {{ item.contents }}
                                                <br><small>{{ item.createdAt }}</small>
                                            </div>
                                        </div>
                                        <div v-else class="noti-empty">댓글 알림이 없습니다.</div>
                                    </div>

                                    <div class="noti-section">
                                        <h4>채팅 알림</h4>
                                        <div class="noti-list" v-if="messageNoti.length > 0">
                                            <div class="noti-item" v-for="item in messageNoti" :key="item.notiNo"
                                                @click="fnChat">
                                                {{ item.contents }}
                                                <br><small>{{ item.createdAt }}</small>
                                            </div>
                                        </div>
                                        <div v-else class="noti-empty">채팅 알림이 없습니다.</div>
                                    </div>
                                </div>
                            </a>
                            <!-- 북마크 -->
                            <a v-if="sessionType === 'user' " href="javascript:void(0);" class="bookmark-link"
                                @click="toggleBookmarkPopup" ref="bookmarkToggle">
                                <img src="/img/common/bookmark.png" class="top-icon" />
                                <!-- 북마크 팝업 -->
                                <div v-if="showBookmarkPopup" class="noti-popup" ref="bookmarkPopup" @click.stop>
                                    <div class="noti-section">
                                        <h4>관심 변호사</h4>
                                        <div class="noti-list" v-if="bookmarkList.length > 0">
                                            <div class="noti-item" v-for="(bm, index) in bookmarkList" :key="index">
                                                {{ bm.lawyerName }}
                                                <img src="/img/selectedBookmark.png"
                                                    style="float: right; width: 18px; height: 18px; cursor: pointer;"
                                                    @click="confirmBookmarkDelete(bm.lawyerId)" />
                                            </div>
                                        </div>
                                        <div class="noti-empty" v-else>관심있는 변호사가 없습니다.</div>
                                    </div>
                                </div>
                            </a>
                            <a v-if="sessionId && sessionType === 'user'" href="/mypage-home.do">
                                <img src="/img/common/mypage.png" class="top-icon" />
                            </a>
                            <a v-if="sessionId && sessionType === 'lawyer'" href="/mypage/lawyerMyPage.do">
                                <img src="/img/common/mypage.png" class="top-icon" />
                            </a>
                        </div>
                    </div>
                </div>

                <!-- ✅ 메뉴줄 (하단) -->
                <div class="bottom-line">
                    <ul class="main-menu">
                        <li class="menu-item" v-for="(item, index) in menuItems" :key="index">
                            <a :href="item.url" :class="{ active: currentPath.includes(item.url) }">{{ item.name }}</a>
                            <div class="dropdown" v-if="sections[index] && sections[index].length">
                                <ul>
                                    <li v-for="(sub, i) in sections[index]" :key="i">
                                        <a :href="sub.url">{{ sub.name }}</a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li v-if="sessionStatus === 'ADMIN'" class="menu-item">
                            <a href="/admin/main.do">관리자 페이지</a>
                        </li>
                    </ul>
                </div>
            </div>

        </header>
    </div>


    <script>
        const header = Vue.createApp({
            data() {
                return {
                    showNotification: false,
                    sessionId: "${sessionId}",
                    sessionType: "${sessionType}",
                    sessionStatus: "${sessionStatus}",
                    list: [],
                    commentNoti: [],
                    messageNoti: [],
                    showBookmarkPopup: false,
                    bookmarkList: [],
                    currentPath: "",
                    menuItems: [
                        { name: '홈', url: '/common/main.do' },
                        { name: '회사소개', url: '/common/introduce.do' },
                        { name: '패키지', url: '/package/package.do' },
                        { name: '변호사', url: '/profile/innerLawyer.do' },
                        { name: '상담게시판', url: '/board/list.do' },
                        { name: '통합자료실', url: '/totalDocs/list.do' }
                    ],
                    sections: [
                        [],
                        [],
                        [],
                        [
                            { name: '소속 변호사', url: '/profile/innerLawyer.do' },
                            { name: '개인 변호사', url: '/profile/personalLawyer.do' },
                            { name: '사무소 위치', url: '/lawyer/office.do' }
                        ],
                        [],
                        [
                            { name: '공지사항', url: '/totalDocs/list.do?kind=NOTICE' },
                            { name: '이용문의', url: '/totalDocs/list.do?kind=HELP' },
                            { name: '사건 종류 가이드', url: '/totalDocs/list.do?kind=GUIDE' }
                        ]
                    ]
                };
            },
            methods: {
                fnGetNotificationList() {
                    $.ajax({
                        url: "/notification/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: { userId: this.sessionId },
                        success: (data) => {
                            if (data.result === "success") {
                                this.list = data.list;
                                this.commentNoti = data.list.filter(n => n.notiType === 'C');
                                this.messageNoti = data.list.filter(n => n.notiType === 'M');
                            }
                        }
                    });
                },
                toggleNotification() {
                    this.showNotification = !this.showNotification;
                    if (this.showNotification) this.fnGetNotificationList();
                },
                markAsRead(item) {
                    let self = this;
                    // 읽음처리
                    $.ajax({
                        url: "/notification/read.dox",
                        type: "POST",
                        data: { notiNo: item.notiNo },
                        success: () => {
                            this.fnGetNotificationList();
                            this.fnBoardView(item);
                        }
                    });
                },
                fnBoardView(item) {
                    pageChange("/board/view.do", { boardNo: item.boardNo });
                },
                fnChat() {
                    let self = this;
                    // 읽음처리
                    $.ajax({
                        url: "/notification/read.dox",
                        type: "POST",
                        data: { notiNo: item.notiNo },
                        success: () => {
                            location.href = "/chat/chat/do";
                        }
                    });
                },
                fnLogout() {
                    var self = this;
                    $.ajax({
                        url: "/user/logout.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            if (data.result == "success") {
                                console.log("sessionId =====> " + self.id);

                                // 네이버 SDK가 저장한 로컬스토리지 데이터 삭제
                                localStorage.removeItem("com.naver.nid.access_token");
                                localStorage.removeItem("com.naver.nid.oauth.state_token");
                                localStorage.removeItem("com.naver.nid.refresh_token");

                                // 네이버 로그아웃을 위한 팝업 호출
                                var naverLogoutUrl = "https://nid.naver.com/nidlogin.logout";
                                var logoutWindow = window.open(naverLogoutUrl, "_unfencedTop", "width=1,height=1,top=9999,left=9999");
                                // logoutWindow.close();
                                setTimeout(function () {
                                    logoutWindow.close();
                                    location.href = "/common/main.do";

                                }, 100);


                            } else {
                                alert("로그아웃 실패");
                            }
                        },
                        error: function () {
                            alert("로그아웃 처리 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnGetBookmarkList() {
                    $.ajax({
                        url: "/bookmark/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: { sessionId: this.sessionId },
                        success: (data) => {
                            if (data.result === "success") {
                                this.bookmarkList = data.list;
                            } else {
                                this.bookmarkList = [];
                            }
                        }
                    });
                },
                toggleBookmarkPopup() {
                    this.showBookmarkPopup = !this.showBookmarkPopup;
                    if (this.showBookmarkPopup) this.fnGetBookmarkList();
                },
                confirmBookmarkDelete(lawyerId) {
                    if (confirm("정말 이 변호사를 관심목록에서 삭제하시겠습니까?")) {
                        $.ajax({
                            url: "/bookmark/remove.dox",
                            type: "POST",
                            data: {
                                userId: this.sessionId,
                                lawyerId: lawyerId
                            },
                            success: () => {
                                alert("삭제되었습니다.");
                                this.fnGetBookmarkList();
                            },
                            error: () => {
                                alert("삭제 중 오류가 발생했습니다.");
                            }
                        });
                    }
                },
                fnLogout() {
                    var self = this;
                    $.ajax({
                        url: "/user/logout.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            if (data.result == "success") {
                                console.log("sessionId =====> " + self.id);

                                // 네이버 SDK가 저장한 로컬스토리지 데이터 삭제
                                localStorage.removeItem("com.naver.nid.access_token");
                                localStorage.removeItem("com.naver.nid.oauth.state_token");
                                localStorage.removeItem("com.naver.nid.refresh_token");

                                // 네이버 로그아웃을 위한 팝업 호출
                                var naverLogoutUrl = "https://nid.naver.com/nidlogin.logout";
                                var logoutWindow = window.open(naverLogoutUrl, "_unfencedTop", "width=1,height=1,top=9999,left=9999");
                                // logoutWindow.close();
                                setTimeout(function () {
                                    logoutWindow.close();
                                    location.href = "/common/main.do";

                                }, 100);


                            } else {
                                alert("로그아웃 실패");
                            }
                        },
                        error: function () {
                            alert("로그아웃 처리 중 오류가 발생했습니다.");
                        }
                    });
                }
            },
            mounted() {
                if (this.sessionType === 'user') {
                    this.fnGetNotificationList();
                    this.fnGetBookmarkList();
                }
                this.currentPath = window.location.pathname || "";
            }
        });
        header.mount("#header");
    </script>