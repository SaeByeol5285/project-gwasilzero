<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <script src="https://code.jquery.com/jquery-3.7.1.js"
         integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script src="/js/page-change.js"></script>
     <link rel="icon" type="image/png" href="/img/common/logo3.png">
                 <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
   </head>
   <style>
      #app {
         max-width: 1000px;
         margin: 0 auto;
         padding: 20px;
      }

      #app h2 {
         font-size: 28px;
         text-align: center;
         margin-bottom: 20px;
      }

      #app .section {
         border-bottom: 2px solid #ddd;
         margin-bottom: 20px;
         padding-bottom: 15px;
      }

      #app .info-section {
        display: flex;
        align-items: center;
        gap: 30px;
        margin-top: 10px;
        }

      #app .info-details {
      line-height: 1.8;
      }

      #app .info-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
      }

      .edit-btn,
      .withdraw-btn {
      background-color: #FF5722;
      
      border: none;
      border-radius: 8px;
      padding: 6px 12px;
      color: #fff;
      font-weight: bold;
      cursor: pointer;
      transition: background-color 0.2s ease;
      }

      .edit-btn:hover,
      .withdraw-btn:hover {
      background-color: #e64a19; /* 조금 더 어두운 색 */
      }

      #app .post-section {
         display: flex;
         gap: 20px;
         justify-content: center;
         margin-top: 15px;
      }

      #app .post-card {
         width: 30%;
         border: 1px solid #ddd;
         border-radius: 8px;
         padding: 15px;
         text-align: center;
         background-color: #f9f9f9;
         box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
      }

      #app .chat-section table,
      #app .payment-table {
         width: 100%;
         border-collapse: collapse;
         margin-top: 10px;
      }

      #app .chat-section th,
      .chat-section td,
      #app .payment-table th,
      .payment-table td {
         border: 1px solid #ddd;
         padding: 10px;
         text-align: center;
      }

      .status-select {
         padding: 8px 12px;
         border: 1px solid #ccc;
         border-radius: 8px;
         font-size: 14px;
         background-color: #fff;
         box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
         transition: border 0.2s ease-in-out;
      }

      .status-select:focus {
         border-color: #FF5722;
         outline: none;
      }

      .card-grid {
         display: grid;
         grid-template-columns: repeat(3, 1fr);
         gap: 24px;
         margin-top: 20px;
      }

      .box {
         background-color: white;
         border-radius: 10px;
         box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
         padding: 16px;
         text-align: center;
         border: 1px solid #eee;
         transition: all 0.2s ease;
         cursor: pointer;
      }

      .box:hover {
         transform: translateY(-4px);
         box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
      }

      .thumbnail {
         width: 100%;
         height: 180px;
         object-fit: cover;
         border-radius: 8px;
         margin-bottom: 10px;
      }

      .payment-table thead {
         background-color: #f2f2f2;
      }

      .payment-table th {
         font-weight: bold;
         color: #333;
         font-size: 15px;
         padding: 12px;
      }

      .payment-table td {
         font-size: 14px;
         padding: 10px 12px;
         background-color: #fff;
      }

      .payment-table tr:nth-child(even) td {
         background-color: #f9f9f9;
      }

      .payment-table {
         border-radius: 8px;
         overflow: hidden;
         box-shadow: 0 2px 6px rgba(0,0,0,0.05);
      }

      .section-subtitle {
         font-size: 28px;
         font-weight: bold;
         margin-bottom: 30px;
         text-align: center;
         color: #222;
         position: relative;
         display: inline-block;
         padding-top: 40px;
         padding-bottom: 10px;
         display: block;
         text-align: center;
         margin-left: auto;
         margin-right: auto;
      }

      .section-subtitle::after {
         content: "";
         position: absolute;
         left: 50%;
         transform: translateX(-50%);
         bottom: 0;
         width: 150px;
         height: 3px;
         background-color: var(--main-color);
         border-radius: 2px;
      }

      .message {
         text-decoration: none;
         color: #333;
      }

      .message:hover {
         color: #e64a19;
      }

      .pagination-container {
         display: flex;
         justify-content: center;
         align-items: center;
         margin-top: 30px;
         margin-bottom: 20px;
         gap: 6px;
      }

      .btn {
         padding: 10px 18px;
         font-size: 15px;
         border: none;
         border-radius: 8px;
         background-color: #f2f2f2;
         color: #444;
         font-weight: 500;
         cursor: pointer;
         transition: all 0.2s ease;
      }

      .btn:hover {
         background-color: #ffe6db;
         color: #ff5c00;
      }

      .btn.active {
         background-color: #ff5c00;
         color: white;
         font-weight: bold;
         box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }

      .btn:disabled {
         opacity: 0.4;
         cursor: default;
      }

   </style>
   <body>
      <jsp:include page="../common/header.jsp" />
      <div id="app">
         <h2 class="section-subtitle">마이페이지</h2>

         <!-- 내 정보 섹션 -->
         <div class="section">
            <div class="info-header">
              <h3>내 정보</h3>
              <button @click="fnEdit" class="edit-btn">정보 수정</button>
            </div>
          
            <div class="info-section">
               <!-- 프로필 사진 -->
               <div v-if="view">
                 <img :src="view.lawyerImg" alt="변호사 사진"
                   style="width: 200px; height: 220px; border-radius: 10px; object-fit: cover; border: 1px solid #ccc;" />
               </div>
             
               <!-- 텍스트 정보 + 상담 상태 -->
               <div class="info-details" v-if="view.lawyerId" style="flex: 1;">
                 <div style="display: flex; justify-content: space-between; align-items: center;">
                   <p style="margin: 0;">이름 : {{ view.lawyerName }}</p>
                   <div>
                     <label for="counselStatus" style="font-weight: bold; margin-right: 8px;">상담 상태 |</label>
                     <select id="counselStatus" v-model="view.counsel" @change="fnUpdateStatus" class="status-select">
                       <option value="">선택 안함</option>
                       <option value="now">상담 가능</option>
                       <option value="delayed">상담 지연</option>
                       <option value="disabled">상담 불가능</option>
                     </select>
                   </div>
                 </div>
                 <p>핸드폰 번호 : {{ view.lawyerPhone }}</p>
                 <p>이메일 : {{ view.lawyerEmail }}</p>
                 <p>사무소 : {{ view.lawyerAddr }}</p>
               </div>
            </div>
             
         </div>

         <div class="section">
            <div class="info-header" style="margin-bottom: 20px;">
               <h3>내 담당 사건</h3>
               <div style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-weight: bold;">정렬 | </span>
                  <select v-model="boardStatus" @change="fnLawyerBoard" class="status-select">
                    <option value="">전체</option>
                    <option value="DOING">진행중</option>
                    <option value="END">완료</option>
                  </select>
                </div>
            </div>
         
            <div class="card-grid" v-if="boardList.length > 0">
               <div class="box" v-for="item in boardList" :key="item.boardNo" @click="fnBoardView(item.boardNo)">
                  <img 
                     v-if="item.thumbnailPath" 
                     :src="item.thumbnailPath.replace('../', '/')" 
                     alt="썸네일" 
                     class="thumbnail"
                     @error="e => e.target.src='/img/common/image_not_exist.jpg'" 
                  />
                  <img 
                     v-else 
                     src="/img/common/image_not_exist.jpg" 
                     alt="기본 썸네일" 
                     class="thumbnail" 
                  />
                  <h3>{{ item.boardTitle }}</h3>
                  <p @click.stop>
                     사건 진행 상태 | 
                     <select class="status-select" v-model="item.boardStatus" @change="fnChangeBoardStatus(item)">
                       <option value="DOING">진행중</option>
                       <option value="END">완료</option>
                     </select>
                  </p>
                  
                  <p>작성자: {{ item.userName }}</p>
               </div>
            </div>

            <div v-else style="text-align: center; color: #888; margin-top: 30px;" >
               내용이 없습니다.
            </div>

            <div class="pagination-container">
               <button class="btn" @click="fnPageMove('prev')" :disabled="page === 1">〈 이전</button>
            
               <button 
                  v-for="num in index" 
                  :key="num" 
                  @click="fnPage(num)" 
                  :class="['btn', page === num ? 'active' : '']"
               >
                  {{ num }}
               </button>
            
               <button class="btn" @click="fnPageMove('next')" :disabled="page === index">다음 〉</button>
            </div>            
         </div>
          
         <div class="section chat-section">
            <h3>채팅 내역</h3>
            <table class="payment-table">
               <colgroup>
                  <col style="width: 75%;"> <!-- 메시지 열 넓게 -->
                  <col style="width: 25%;"> <!-- 상대방 열 좁게 -->
               </colgroup>
              <thead>
                <tr>
                  <th>메시지</th>
                  <th>상대방</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="chatList && chatList.length > 0" v-for="chat in chatList" :key="chat.chatNo">
                  <td><a href="javascript:;" @click="fnChat(chat.chatNo)" class="message">{{ chat.message }}</a></td>
                  <td>
                     {{ chat.partnerName }}
                     <br>
                     <button class="edit-btn" @click="fnUsePhoneConsult(chat)">
                        전화 상담 차감
                     </button>
                  </td>
                </tr>
                <tr v-else>
                  <td colspan="2" style="text-align: center; color: #999;">채팅 내역이 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>          

          <div class="section">
            <h3>차감된 전화 상담 내역</h3>
            <table class="payment-table">
               <thead>
                  <tr>
                     <th>사용일</th>
                     <th>대상 유저</th>
                     <th>상태</th>
                  </tr>
               </thead>
               <tbody>
                  <tr v-for="item in usedList" :key="item.orderId">
                     <td>{{ item.payTime }}</td>
                     <td>{{ item.userName }}</td>
                     <td>사용됨</td>
                  </tr>
                  <tr v-if="!usedList.length">
                     <td colspan="3" style="text-align:center;">차감 내역이 없습니다.</td>
                  </tr>
               </tbody>
            </table>
         </div>         

         <div class="section">
            <h3>최근 결제 내역</h3>
            <table class="payment-table">
               <thead>
                  <tr>
                     <th>날짜</th>
                     <th>제품명</th>
                     <th>가격</th>
                     <th>상태</th>
                     <th>요청</th>
                  </tr>
               </thead>               
              <tbody>
               <tr v-if="lawyerPayList && lawyerPayList.length" v-for="pay in lawyerPayList" :key="pay.orderId">
                  <td>{{ pay.payTime }}</td>
                  <td>{{ pay.packageName }}</td>
                  <td>{{ pay.price.toLocaleString() }} 원</td>
                  <td>{{  getPayStatusText(pay.payStatus) }}</td>
                  <td>
                     <!-- 환불 가능 상태일 때 -->
                     <button 
                       v-if="pay.payStatus === 'PAID'" 
                       @click="fnRequestRefund(pay.orderId)" 
                       class="edit-btn">
                       환불 요청
                     </button>
                   
                     <!-- 환불 요청 상태일 때 -->
                     <button 
                       v-else-if="pay.payStatus === 'REQUEST'" 
                       @click="fnCancelRefund(pay.orderId)" 
                       class="withdraw-btn">
                       환불 요청 취소
                     </button>
                   
                     <!-- 그 외 상태일 때 -->
                     <span v-else>-</span>
                  </td>
               </tr>
               <tr v-else>
                  <td colspan="5">결제 내역이 없습니다.</td>
               </tr>
            </tbody>            
            </table>
          </div>          

         <div style="text-align: center; margin-top: 20px;">
            <button @click="fnEditProfile" class="edit-btn" style="margin-right: 10px;">
               프로필 수정
            </button>
            <button @click="fnRemoveUser" class="withdraw-btn">
               회원탈퇴
            </button>
         </div>
      </div>
      <jsp:include page="../common/footer.jsp" />
   </body>

   </html>
   <script>
      const app = Vue.createApp({
         data() {
            return {
               view: {},
               sessionId: "${sessionId}", 
               boardList : [],
               boardStatus : "",
               page: 1,
               pageSize: 3,
               index: 0,
               lawyerPayList : [],
               chatList : [],
               usedList : []
            };
         },
         methods: {
            fnGetList() {
               var self = this;
               var nparmap = { sessionId: self.sessionId };
               $.ajax({
                  url: "/lawyerMyPage/view.dox",
                  dataType: "json",
                  type: "POST",
                  data: nparmap,
                  success: function (data) {
                     self.view = data.view;

                     if (!self.view.counsel) {
                        self.view.counsel = '';
                     }
                  }
               });
            },

            fnGetNotification() {
               const self = this;
               $.ajax({
                  url: "/mypage/notification.dox",
                  type: "POST",
                  data: { receiverId: self.sessionId },
                  dataType: "json",
                  success: function (data) {
                     if (data.result === "success" && data.notifications.length > 0) {
                        const message = data.notifications[0].contents;
                        Swal.fire({
                           title: '📢 알림',
                           text: message,
                           icon: 'info',
                           confirmButtonText: '확인'
                        }).then(() => {
                           $.ajax({
                              url: "/mypage/notificationRead.dox",
                              type: "POST",
                              data: { receiverId: self.sessionId }
                           });
                        });
                     }
                  }
               });
            },
            
            fnUpdateStatus() {
                const self = this;
                $.ajax({
                url: "/lawyerMyPage/updateStatus.dox",
                type: "POST",
                data: {
                    lawyerId: self.view.lawyerId,
                    counsel: self.view.counsel
                },
                success: function (data) {
                  Swal.fire("상담 상태가 변경되었습니다.");
                },
                error: function () {
                  Swal.fire("상담 상태 변경 실패");
                }
                });
            },

            fnLawyerBoard() {
               var self = this;
               
               var nparmap = { 
                  sessionId: self.sessionId,
                  boardStatus : self.boardStatus,
                  page: (self.page - 1) * self.pageSize,
                  pageSize: self.pageSize
               };

               if (self.boardStatus) {
                  nparmap.boardStatus = self.boardStatus; // 'DOING' 또는 'END'일 때만 추가
               }

               $.ajax({
                  url: "/lawyerMyPage/board.dox",
                  dataType: "json",
                  type: "POST",
                  data: nparmap,
                  success: function (data) {
                     if (data.result == "success") {
                        self.boardList = data.boardList;
                        self.index = Math.max(1, Math.ceil(data.count / self.pageSize));

                     }
                     else {
                        alert("불러오기 실패");
                     }
                     
                  }
               });
            },

            fnGetPayments() {
               const self = this;
               $.ajax({
                  url: "/lawyerMyPage/payList.dox",
                  type: "POST",
                  data: { sessionId: self.sessionId },
                  dataType: "json",
                  success: function(data) {
                     self.lawyerPayList = data.lawyerPayList; 
                  },
                  error: function() {
                     alert("결제 내역 불러오기 실패");
                  }
               });
            },

            fnRequestRefund(orderId) {
               const self = this;

               Swal.fire({
                  title: "환불 요청",
                  text: "해당 결제 건에 대해 환불을 요청하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#d33",
                  cancelButtonColor: "#aaa",
                  confirmButtonText: "요청",
                  cancelButtonText: "취소"
               }).then((result) => {
                  if (result.isConfirmed) {
                        $.ajax({
                           url: "/mypage/Refund.dox",
                           type: "POST",
                           data: { orderId: orderId },
                           success: function (data) {
                              Swal.fire("요청 완료", "환불 요청이 접수되었습니다.", "success");

                              const pay = self.lawyerPayList.find(p => p.orderId === orderId);
                              if (pay) {
                                    pay.payStatus = "REQUEST";
                              }
                           },
                           error: function () {
                              alert("환불 요청 처리 중 오류가 발생했습니다.");
                           }
                        });
                  }
               });
            },

            fnCancelRefund(orderId) {
               const self = this;

               Swal.fire({
                  title: "환불 요청 취소",
                  text: "환불 요청을 취소하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#d33",
                  cancelButtonColor: "#aaa",
                  confirmButtonText: "취소 요청",
                  cancelButtonText: "닫기"
               }).then((result) => {
                  if (result.isConfirmed) {
                        $.ajax({
                           url: "/mypage/RefundCancel.dox", 
                           type: "POST",
                           data: { orderId: orderId },
                           success: function () {
                              Swal.fire("취소 완료", "환불 요청이 취소되었습니다.", "success");
                              const pay = self.lawyerPayList.find(p => p.orderId === orderId);
                              if (pay) {
                                    pay.payStatus = "PAID"; 
                              }
                           },
                           error: function () {
                              alert("환불 요청 취소 처리 중 오류가 발생했습니다.");
                           }
                        });
                  }
               });
            },

            fnGetChatList() {
               const self = this;
               $.ajax({
                  url: "/mypage/chatList.dox",
                  type: "POST",
                  data: { sessionId: self.sessionId },
                  dataType: "json",
                  success: function(data) {
                     self.chatList = data && data.chatList ? data.chatList : [];
                  },
                  error: function() {
                     alert("채팅 내역을 불러오는 중 오류가 발생했습니다.");
                  }
               });
            },

            fnChat(chatNo) {
               pageChange("/chat/chat.do", {chatNo : chatNo});
            },

            fnUsePhoneConsult(chat) {
               const self = this;
            let chatNo = chat.chatNo;
            let userId = chat.partnerId;
               Swal.fire({
                  title: '전화 상담 1회를 차감하시겠습니까?',
                  icon: 'warning',
                  showCancelButton: true,
                  confirmButtonText: '차감',
                  cancelButtonText: '취소'
               }).then((result) => {
                  if (result.isConfirmed) {
                     $.ajax({
                     url: '/lawyerMyPage/usePhoneConsult.dox',
                     type: 'POST',
                     data: {
                        lawyerId : self.sessionId,
                        userId: userId,
                        sessionId : self.sessionId,
                        chatNo : chatNo,
                        contents  : ""
                     },
                     success: function (res) {
                        if (res.result === 'success') {
                           Swal.fire('차감 완료', '전화 상담 패키지 1회가 차감되었습니다.', 'success');
                        } else {
                           Swal.fire('실패', res.message || '차감 중 문제가 발생했습니다.', 'error');
                        }
                     },
                     error: function () {
                        Swal.fire('오류', '서버와의 통신 중 문제가 발생했습니다.', 'error');
                     }
                     });
                  }
               });
            },

            fnGetUsedPhoneList() {
               const self = this;
               $.ajax({
                  url: "/lawyerMyPage/usedPhoneList.dox",
                  type: "POST",
                  data: { lawyerId: self.sessionId },
                  dataType: "json",
                  success: function(res) {
                     self.usedList = res.usedList || [];
                  }
               });
            },

            getPayStatusText(status) {
               switch (status) {
                  case "PAID":
                     return "결제 완료";
                  case "REQUEST":
                     return "환불 요청";
                  case "REFUNDED":
                     return "환불 완료";
                  case "CANCELLED_REFUND":
                     return "환불 취소";
                  default:
                     return status;
               }
            },

            fnPage(num) {
               this.page = num;
               this.fnLawyerBoard();
            },
            
            fnPageMove(dir) {
               if (dir === "next" && this.page < this.index) {
                  this.page++;
               } else if (dir === "prev" && this.page > 1) {
                  this.page--;
               }
               this.fnLawyerBoard();
            },

            fnBoardView(boardNo) {
               pageChange("/board/view.do", { boardNo: boardNo });
            },

            fnEdit() {
               pageChange("/lawyerMyPage/edit.do", { sessionId: this.sessionId });
            },

            fnEditProfile() {
               const self = this;
               if (!self.sessionId) {
                  alert("변호사 정보가 없습니다.");
                  return;
               }
               pageChange("/profile/lawyerEdit.do", { sessionId: self.sessionId });
            },

            fnChangeBoardStatus(item) {
               const self = this;
               $.ajax({
                  url: "/lawyerMyPage/updateBoardStatus.dox",
                  type: "POST",
                  data: {
                     boardNo: item.boardNo,
                     boardStatus: item.boardStatus
                  },
                  success: function (data) {
                     if (data.result === "success") {
                        Swal.fire("변경 완료", "상태가 변경되었습니다.", "success");
                     } else {
                        alert("상태 변경 실패");
                     }
                  },
                  error: function () {
                     alert("서버 오류로 상태 변경 실패");
                  }
               });
            },

            fnRemoveUser() {
               pageChange("/lawyerMyPage/out.do", { sessionId: this.sessionId });
            }

         },
         mounted() {
            this.fnGetList();
            this.fnLawyerBoard();
            this.fnGetPayments();
            this.fnGetChatList();
            this.fnGetNotification();
            this.fnGetUsedPhoneList();
         }
      });
      app.mount('#app');
   </script>

   ​