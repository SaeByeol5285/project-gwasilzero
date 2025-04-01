<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<link rel="stylesheet" href="/css/header.css">
<link rel="stylesheet" href="/css/common.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

<!-- Vue, jQuery 등 라이브러리는 한 번만 로드 -->
<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
<script src="/js/page-change.js"></script>

<div id="header">
    <header>
        <!-- 로그인 / 북마크 / 알림 -->
        <div class="header-line">
			<a v-if="sessionType === 'user'" href="javascript:void(0);" class="noti-link" @click="toggleNotification" ref="notiToggle">
			    새 소식
			    <span v-if="list.length > 0" class="noti-badge">{{ list.length > 9 ? '9+' : list.length }}</span>

				<div v-if="showNotification" class="noti-popup"  ref="notiPopup" @click.stop>
				    <div class="noti-section">
				        <h4>댓글 알림</h4>
				        <div class="noti-list" v-if="commentNoti.length > 0">
				            <div class="noti-item" v-for="item in commentNoti" :key="item.notiNo" @click="markAsRead(item)">
				                {{ item.contents }}
				                <br><small>{{ item.createdAt }}</small>
				            </div>
				        </div>
				        <div v-else class="noti-empty">댓글 알림이 없습니다.</div>
				    </div>

				    <div class="noti-section">
				        <h4>채팅 알림</h4>
				        <div class="noti-list" v-if="messageNoti.length > 0">
				            <div class="noti-item" v-for="item in messageNoti" :key="item.notiNo">
				                {{ item.contents }}
				                <br><small>{{ item.createdAt }}</small>
				            </div>
				        </div>
				        <div v-else class="noti-empty">채팅 알림이 없습니다.</div>
				    </div>
				</div>
			</a>
            <a v-if="sessionType === 'user'" href="/bookmark/list.do">북마크 목록</a>
            <a href="#">고객만족센터</a>
            <a v-if="sessionId === ''" href="/user/login.do">로그인 / 회원가입</a>
            <a v-else href="/user/logout.do">로그아웃</a>
            <a v-if="sessionId !== ''" href="/mypage-home.do">마이페이지</a>
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
                    <li class="menu-item" v-if="sessionStatus === 'A'">
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
                sessionId: "${sessionScope.sessionId}",
                sessionType: "${sessionScope.sessionType}",
                sessionStatus: "${sessionScope.sessionStatus}", // 예: A, U 등
                list: [],
				commentNoti : [],
				messageNoti : [],
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
                        { name: '공지사항', url: '#' },
                        { name: 'Q & A', url: '#' },
                        { name: '사건 종류 가이드', url: '#' }
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
			    // 읽음
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

			        if (!toggle || !popup) return;

			        if (
			            !toggle.contains(event.target) &&
			            !popup.contains(event.target)
			        ) {
			            this.showNotification = false;
			        }
			    },
			fnBoardView(item) {  // 읽음처리 후 해당보드로 넘어가기
				let self = this;
				pageChange("/board/view.do", {boardNo : item.boardNo});
			}
        },
        mounted() {
			let self = this;
			
            if (self.sessionType === 'user') {
                self.fnGetNotificationList();
            }
			
			document.addEventListener('click', self.handleClickOutside);
        },
		beforeUnmount() {
		    document.removeEventListener('click', this.handleClickOutside);
		},
    });
    header.mount("#header");
</script>
