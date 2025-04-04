<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/common.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>

    <div id="header">
        <header>
            <!-- 로그인 / 북마크 / 알림 -->
            <div class="header-line">
                <a v-if="sessionType === 'user' || sessionType === 'lawyer'" href="javascript:void(0);"
                    class="noti-link" @click="toggleNotification" ref="notiToggle">
                    새 소식
                    <span v-if="list.length > 0" class="noti-badge">{{ list.length > 9 ? '9+' : list.length }}</span>

                    <div v-if="showNotification" class="noti-popup" ref="notiPopup" @click.stop>
                        <!-- 댓글 알림은 사용자만 표시 -->
                        <div class="noti-section" v-if="sessionType === 'user'">
                            <h4>댓글 알림</h4>
                            <div class="noti-list" v-if="commentNoti.length > 0">
                                <div class="noti-item" v-for="item in commentNoti" :key="item.notiNo"
                                    @click="markAsRead(item)">
                                    {{ item.contents }}
                                    <br><small>{{ item.createdAt }}</small>
                                </div>
                            </div>
                            <div class="noti-empty" v-else>댓글 알림이 없습니다.</div>
                        </div>

                        <!-- 채팅 알림은 사용자/변호사 모두 표시 -->
                        <div class="noti-section">
                            <h4>채팅 알림</h4>
                            <div class="noti-list" v-if="messageNoti.length > 0">
                                <div class="noti-item" v-for="item in messageNoti" :key="item.notiNo"
                                    @click="fnChat(item)">
                                    {{ item.contents }}
                                    <br><small>{{ item.createdAt }}</small>
                                </div>
                            </div>
                            <div class="noti-empty" v-else>채팅 알림이 없습니다.</div>
                        </div>
                    </div>
                </a>

                <a v-if="sessionType === 'user'" href="javascript:void(0);" class="bookmark-link"
                    @click="toggleBookmarkPopup" ref="bookmarkToggle">
                    북마크 목록
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
                <a href="/totalDocs/list.do?kind=HELP">고객만족센터</a>
                <a v-if="!sessionId" href="/user/login.do">로그인 / 회원가입</a>
                <a v-else @click="fnLogout" href="#">로그아웃</a>
                <a v-if="sessionId != '' && sessionType == 'user'" href="/mypage-home.do">마이페이지</a>
                <a v-if="sessionId != '' && sessionType == 'lawyer'" href="/mypage/lawyerMyPage.do">마이페이지</a>
            </div>

            <!-- 네비게이션 -->
            <nav class="main-nav-wrapper">
                <div class="main-nav">
                    <a href="/common/main.do" class="logo">
                        <img src="/img/logo1.png" alt="로고 이미지">
                    </a>

                    <ul class="main-menu">
                        <li class="menu-item" v-for="(item, index) in menuItems" :key="index">
                            <a :href="item.url" class="menu-font">{{ item.name }}</a>
                            <div class="dropdown" v-if="sections[index] && sections[index].length">
                                <ul>
                                    <li v-for="(sub, i) in sections[index]" :key="i">
                                        <a :href="sub.url">{{ sub.name }}</a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li class="menu-item" v-if="sessionStatus === 'ADMIN'">
                            <a href="/admin/main.do" class="menu-font">관리자 페이지</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
    </div>


    <script>
        const header = Vue.createApp({
            data() {
                return {
                    showNotification: false,
                    sessionId: "${sessionId}",
                    sessionType: "${sessionType}",
                    sessionStatus: "${sessionStatus}", //ADMIN
                    list: [],
                    commentNoti: [],
                    messageNoti: [],
                    showBookmarkPopup: false,
                    bookmarkList: [],
                    menuItems: [
                        { name: '회사 소개', url: '/common/introduce.do' },
                        { name: '패키지 소개', url: '/package/package.do' },
                        { name: '구성원', url: '/profile/innerLawyer.do' },
                        { name: '게시판', url: '/board/list.do' },
                        { name: '통합 자료실', url: '/totalDocs/list.do' }
                    ],
                    sections: [
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
                    const self = this;
                    $.ajax({
                        url: "/notification/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: { userId: self.sessionId },
                        success(data) {
                            if (data.result === "success") {
                                self.list = data.list;
                                self.commentNoti = data.list.filter(n => n.notiType === 'C');
                                self.messageNoti = data.list.filter(n => n.notiType === 'M');
                                console.log(self.list);
                            } else {
                                console.warn("알림 로딩 실패");
                            }
                        }
                    });
                },
                toggleNotification() {
                    this.showNotification = !this.showNotification;
                    if (this.showNotification) {
                        this.fnGetNotificationList();
                    }
                },
                markAsRead(item) {
                    let self = this;
                    // 읽음처리
                    if (!confirm("해당 게시글로 이동하시겠습니까?")) {
                        return;
                    }

                    $.ajax({
                        url: "/notification/read.dox",
                        type: "POST",
                        data: { notiNo: item.notiNo },
                        success: () => {
                            self.fnGetNotificationList();
                            self.fnBoardView(item);
                        }
                    });
                },
                handleClickOutside(event) {
                    const toggle = this.$refs.notiToggle;
                    const popup = this.$refs.notiPopup;
                    const bmToggle = this.$refs.bookmarkToggle;
                    const bmPopup = this.$refs.bookmarkPopup;

                    const clickedOutsideNoti = toggle && popup && !toggle.contains(event.target) && !popup.contains(event.target);
                    const clickedOutsideBookmark = bmToggle && bmPopup && !bmToggle.contains(event.target) && !bmPopup.contains(event.target);

                    if (clickedOutsideNoti) {
                        this.showNotification = false;
                    }
                    if (clickedOutsideBookmark) {
                        this.showBookmarkPopup = false;
                    }
                },
                fnBoardView(item) {  // 읽음처리 후 해당보드로 넘어가기
                    let self = this;
                    pageChange("/board/view.do", { boardNo: item.boardNo });
                },
                fnChat(item) {
                    let self = this;

                    if (!confirm("채팅방으로 이동하시겠습니까?")) return;

                    // 읽음 처리 후 바로 이동
                    $.ajax({
                        url: "/notification/read.dox",
                        type: "POST",
                        data: { notiNo: item.notiNo },
                        success: () => {
                            if (item.chatNo) {
                                location.href = "/chat/chat.do?chatNo=" + item.chatNo;
                            } else {
                                alert("채팅방 정보가 없습니다.");
                            }
                        }
                    });
                },
                fnMyPage() {
                    if (this.sessionStatus === 'NORMAL') {
                        return '/mypage/mypage-home.do';
                    } else if (this.sessionStatus === 'I' || this.sessionStatus === 'P') {
                        return '/mypage/lawyerMyPage.do';
                    } else {
                        return '#';
                    }
                },
                fnGetBookmarkList() {
                    const self = this;
                    $.ajax({
                        url: "/bookmark/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: { sessionId: self.sessionId },
                        success(data) {
                            if (data.result === "success") {
                                self.bookmarkList = data.list;
                            } else {
                                self.bookmarkList = [];
                            }
                        }
                    });
                },
                toggleBookmarkPopup() {
                    this.showBookmarkPopup = !this.showBookmarkPopup;
                    if (this.showBookmarkPopup) {
                        this.fnGetBookmarkList();
                    }
                },

                confirmBookmarkDelete(lawyerId) {
                    let self = this;
                    if (confirm("정말 이 변호사를 관심목록에서 삭제하시겠습니까?")) {
                        $.ajax({
                            url: "/bookmark/remove.dox",
                            type: "POST",
                            data: {
                                userId: self.sessionId,
                                lawyerId: lawyerId
                            },
                            success: function (data) {
                                alert("삭제되었습니다.");
                                self.fnGetBookmarkList(); // 다시 목록 불러오기
                            },
                            error: function () {
                                alert("삭제 중 오류가 발생했습니다.");
                            }
                        });
                    }
                },
                fnLogout() {
                    var self = this;
                    var nparmap = {
                    };
                    $.ajax({
                        url: "/user/logout.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log("sessionId =====> " + self.id);
                                alert("로그아웃 되었습니다.");
                                location.href = "/common/main.do"; // 로그아웃 후 이동할 페이지
                            } else {
                                alert("로그아웃 실패");
                            }
                        }
                    });
                }

            },
            mounted() {
                let self = this;
                console.log(self.sessionType);
                
                self.fnGetNotificationList();
                if (self.sessionType === 'user') {

                    self.fnGetBookmarkList();
                }
                document.addEventListener('click', self.handleClickOutside);
            },
            beforeUnmount() {
                document.removeEventListener('click', this.handleClickOutside);
            },
        });
        header.mount("#header");
    </script>