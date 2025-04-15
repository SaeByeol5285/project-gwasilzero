<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

   <link rel="stylesheet" href="/css/header.css">
   <link rel="stylesheet" href="/css/common.css">
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
   <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
   <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
   <script src="/js/page-change.js"></script>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <link rel="icon" type="image/png" href="/img/common/logo3.png">
         <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
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
                     <!-- 새별수정 -->
                     <input type="text" placeholder="비슷한 블랙박스 영상을 찾아보세요!" v-model="keyword"
                        @keyup.enter="goToBoard" />
                     <img src="/img/common/logo3.png" class="top-icon" @click="goToBoard" />
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
                                    @click="fnChat(item)">
                                    {{ item.contents }}
                                    <br><small>{{ item.createdAt }}</small>
                                 </div>
                              </div>
                              <div v-else class="noti-empty">채팅 알림이 없습니다.</div>
                           </div>

                           <div class="noti-section" v-if="sessionType === 'lawyer'">
                              <h4>게시글 알림</h4>
                              <div class="noti-list" v-if="broadcastNoti.length > 0">
                                 <div class="noti-item" v-for="item in broadcastNoti" :key="item.notiNo"
                                    @click="markAsRead(item)">
                                    {{ item.contents }}
                                    <br><small>{{ item.createdAt }}</small>
                                 </div>

                              </div>
                           </div>
                           <div v-else class="noti-empty">게시글 알림이 없습니다.</div>
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
								
								<div class="noti-item" v-for="(bm, index) in bookmarkList" :key="index" style="display: flex; justify-content: space-between; align-items: center;">
									<span
									    style="color: #ff5722; font-weight: 500; cursor: pointer;"
									    @click="goToLawyerProfile(bm.lawyerId)"
									  >
									    {{ bm.lawyerName }}
									  </span>

								  <!-- 오른쪽: 아이콘들 -->
								  <div style="display: flex; align-items: center; gap: 8px;">
								    <img
								      src="/img/common/call.png"
								      style="width: 18px; height: 18px; cursor: pointer;"
								      @click="startChat(bm.lawyerId)"
								    />
								    <img
								      src="/img/selectedBookmark.png"
								      style="width: 18px; height: 18px; cursor: pointer;"
								      @click="confirmBookmarkDelete(bm.lawyerId)"
								    />
								  </div>
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

            <div class="bottom-line">
               <ul class="main-menu">
                  <li class="menu-item" v-for="(item, index) in menuItems" :key="index">
                     <a :href="item.url" :class="{
                       active:
                        currentPath.startsWith(item.url) ||
                        (sections[index] &&
                          sections[index].some(sub => currentPath === sub.url))
                     }">
                        {{ item.name }}
                     </a>
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
               broadcastNoti: [],
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
                     { name: '법률 사무소 찾기', url: '/lawyer/office.do' }
                  ],
                  [],
                  [
                     { name: '공지사항', url: '/totalDocs/list.do?kind=NOTICE' },
                     { name: '이용문의', url: '/totalDocs/list.do?kind=HELP' },
                     { name: '사건 종류 가이드', url: '/totalDocs/list.do?kind=GUIDE' }
                  ]
               ],
               //새별
               keyword: ""
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

                        this.broadcastNoti = data.list.filter(n => n.notiType === 'BROADCAST');
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
			fnChat(item) {
			    let self = this;

			    // 로그인 여부 확인
			    if (!self.sessionId) {
			        Swal.fire({
			            icon: "warning",
			            title: "로그인 필요",
			            text: "로그인 후 이용해주세요.",
			            confirmButtonColor: "#ff5c00"
			        });
			        return;
			    }
				
			    //  채팅 이동 확인
			    Swal.fire({
			        icon: "warning",
			        title: "알림",
			        text: "채팅으로 이동하시겠습니까?",
			        showCancelButton: true,
			        confirmButtonText: "이동",
			        cancelButtonText: "취소",
			        confirmButtonColor: "#ff5c00"
			    }).then((result) => {
			        if (result.isConfirmed) {
			            self.fnChat2(item);
			        }
			    });
			},
			fnChat2(item) {
			    let self = this;

			    // 변호사일 경우 패키지 체크 생략
			    if (self.sessionType === 'lawyer') {
			        // 읽음 처리 후 채팅방 이동
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
			        return;
			    }

			    // 일반 사용자일 경우 패키지 확인
			    $.ajax({
			        url: "/board/checkUserPacakge.dox",
			        type: "POST",
			        data: { userId: self.sessionId },
			        success: function (pkgRes) {
			            if (pkgRes.count == 0) {
			                Swal.fire({
			                    icon: "error",
			                    title: "패키지 없음",
			                    text: "전화 상담 패키지를 구매 후 이용해주세요.",
			                    confirmButtonColor: "#ff5c00"
			                }).then(() => {
			                    location.href = "/package/package.do";
			                });
			                return;
			            }

			            // 읽음 처리 후 채팅방 이동
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
			        error: function () {
			            Swal.fire({
			                icon: "error",
			                title: "오류",
			                text: "패키지 확인 중 오류가 발생했습니다.",
			                confirmButtonColor: "#ff5c00"
			            });
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
               let self = this;
               $.ajax({
                  url: "/bookmark/list.dox",
                  type: "POST",
                  dataType: "json",
                  data: { sessionId: self.sessionId },
                  success: (data) => {
                     if (data.result === "success") {
                        this.bookmarkList = data.list;
                     } else {
                        this.bookmarkList = [];
                     }
                     localStorage.setItem('bookmarkUpdated', Date.now());
                  }
               });
            },
            toggleBookmarkPopup() {
               this.showBookmarkPopup = !this.showBookmarkPopup;
               if (this.showBookmarkPopup) this.fnGetBookmarkList();
            },
            confirmBookmarkDelete(lawyerId) {
               Swal.fire({
                  title: "정말 삭제하시겠습니까?",
                  text: "이 변호사를 관심목록에서 삭제합니다",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonText: "삭제",
                  cancelButtonText: "취소",
                  confirmButtonColor: "#d33"
               }).then((result) => {
                  if (result.isConfirmed) {
                     $.ajax({
                        url: "/bookmark/remove.dox",
                        type: "POST",
                        data: {
                           userId: this.sessionId,
                           lawyerId: lawyerId
                        },
                        success: () => {
                           Swal.fire({
                              icon: "success",
                              title: "삭제 완료",
                              text: "관심목록에서 삭제되었습니다.",
                              confirmButtonText: "확인"
                           }).then(() => {
                              this.fnGetBookmarkList();
                              location.reload();
                           });
                        },
                        error: () => {
                           Swal.fire({
                              icon: "error",
                              title: "오류 발생",
                              text: "삭제 중 오류가 발생했습니다."
                           });
                        }
                     });
                  }
               });
            },

            handleClickOutside(event) {
               // 알림창 외부 클릭
               if (this.showNotification) {
                  const popup = this.$refs.notiPopup;
                  const toggle = this.$refs.notiToggle;

                  if (popup && !popup.contains(event.target) && toggle && !toggle.contains(event.target)) {
                     this.showNotification = false;
                  }
               }

               // 북마크창 외부 클릭
               if (this.showBookmarkPopup) {
                  const popup = this.$refs.bookmarkPopup;
                  const toggle = this.$refs.bookmarkToggle;

                  if (popup && !popup.contains(event.target) && toggle && !toggle.contains(event.target)) {
                     this.showBookmarkPopup = false;
                  }
               }
            },
            beforeUnmount() {
               document.removeEventListener('click', this.handleClickOutside);
            },
            //새별
            goToBoard() {
               if (this.keyword) {
                  location.href = "/board/list.do?keyword=" + encodeURIComponent(this.keyword) + "&searchType=all";
               } else {
                  alert("검색어를 입력해주세요.");
               }
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
			goToLawyerProfile(lawyerId){
				pageChange("/profile/view.do" , {lawyerId : lawyerId});
			}
				
         },
         mounted() {
            this.fnGetNotificationList();
            if (this.sessionType === 'user') {
               // this.fnGetBookmarkList();
            }
            this.currentPath = window.location.pathname || "";

            document.addEventListener('click', this.handleClickOutside);
            window.addEventListener('storage', (e) => {
               if (e.key === 'bookmarkUpdated') {
                  this.fnGetBookmarkList();
               }
            });

         }
      });
      header.mount("#header");
   </script>