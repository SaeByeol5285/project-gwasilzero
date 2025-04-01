<%@ page language="java" contentType="text/html; charset=UTF-8" %>
   <% String sessionId=(String) session.getAttribute("sessionId"); %>
      <script>
         window.sessionId = "<%= sessionId %>";
      </script>
      <!DOCTYPE html>
      <html>

      <head>
         <meta charset="UTF-8">
         <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
         <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
         <title>마이페이지</title>
         <style>
            #app {
               max-width: 1000px;
               margin: 0 auto;
               padding: 20px;
            }

            .section {
               border-bottom: 2px solid #ddd;
               margin-bottom: 20px;
               padding-bottom: 15px;
            }

            .info-section {
               display: flex;
               justify-content: space-between;
               align-items: center;
            }

            .info-details {
               line-height: 2;
            }

            .post-section {
               display: flex;
               gap: 20px;
               justify-content: center;
               flex-wrap: wrap;
            }

            .post-card {
               width: 30%;
               border: 1px solid #ddd;
               border-radius: 8px;
               padding: 15px;
               text-align: left;
               background-color: #f9f9f9;
               box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
            }

            .post-title {
               font-weight: bold;
               margin-bottom: 8px;
            }

            table {
               width: 100%;
               border-collapse: collapse;
               margin-top: 10px;
            }

            th,
            td {
               border: 1px solid #ddd;
               padding: 10px;
               text-align: center;
            }

            button {
               background-color: #FF5722;
               border: none;
               border-radius: 8px;
               padding: 5px 10px;
               color: #ffffff;
               cursor: pointer;
            }

            /* 리뷰 작성 카드 전용 스타일 */
            .review-section {
               background-color: #fff9f4;
               padding: 20px;
               border-radius: 12px;
            }

            .review-card {
               background-color: #fff;
               border: 1px solid #ffd8b3;
               border-radius: 10px;
               padding: 20px;
               margin-bottom: 20px;
               box-shadow: 1px 2px 5px rgba(0, 0, 0, 0.05);
               transition: box-shadow 0.3s ease;
            }

            .review-card:hover {
               box-shadow: 2px 4px 10px rgba(0, 0, 0, 0.1);
            }

            .review-title {
               font-size: 18px;
               margin-bottom: 5px;
               color: #333;
            }

            .review-lawyer {
               color: #999;
               margin-bottom: 15px;
            }

            .review-score select {
               padding: 4px 8px;
               border-radius: 6px;
               border: 1px solid #ccc;
            }

            .review-textarea {
               width: 90%;
               min-height: 100px;
               margin-top: 10px;
               padding: 12px;
               font-size: 15px;
               border: 1px solid #ccc;
               border-radius: 6px;
               resize: vertical;
            }

            .review-submit-btn {
               margin-top: 12px;
               padding: 8px 16px;
               border-radius: 6px;
               background-color: #ff5c00;
               border: none;
               color: white;
               font-weight: bold;
               cursor: pointer;
            }

            .review-submit-btn:hover {
               background-color: #e65300;
            }

            .star {
               cursor: pointer;
            }
         </style>
      </head>

      <body>
         <jsp:include page="../common/header.jsp" />
         <div id="app">
            <h2>마이페이지</h2>

            <!-- 내 정보 -->
            <div class="section info-section">
               <div>
                  <h3>내 정보</h3>
                  <div class="info-details" v-if="info && info.userName">
                     이름: {{ info.userName }}<br>
                     핸드폰 번호: {{ info.userPhone }}<br>
                     이메일: {{ info.userEmail }}
                  </div>
               </div>
               <button @click="fnEdit">정보 수정</button>
            </div>

            <!-- 내가 쓴 글 -->
            <div class="section">
               <h3>내가 쓴 글</h3>
               <div class="post-section">
                  <div v-for="post in boardList" :key="post.boardNo" class="post-card">
                     <div class="post-title">{{ post.BOARDTITLE }}</div>
                     <div>{{ post.CONTENTS }}</div>
                  </div>
               </div>
            </div>
            <!-- 리뷰 작성 섹션 -->
            <div v-if="availReviewList.length" class="section review-section">
               <h3>📝 리뷰 작성 가능한 항목</h3>
               <!-- 리뷰 작성 가능한 항목 -->
               <div class="review-card" v-for="item in availReviewList" :key="item.boardNo">
                  <div>
                     <span class="review-title"><strong>게시글 제목 : {{ item.boardTitle }}</strong></span>
                  </div>
                  <div>
                     <span class="review-lawyer">담당 변호사 : {{ item.lawyerId }}</span>
                  </div>
                  <p>평점 :
                     <span class="star" v-for="index in 5" :key="index" @click="item.score = index">
                        <span v-if="index <= item.score">⭐</span>
                        <span v-else>☆</span>
                     </span>
                  </p>
                  <textarea v-model="item.contents" placeholder="리뷰 내용을 입력해주세요" class="review-textarea"></textarea>
                  <button class="btn btn-primary review-submit-btn" @click="fnWriteReview(item)">리뷰 등록</button>
               </div>
            </div>

            <!-- 이미 작성한 리뷰 -->
            <div class="review-card" v-for="item in writtenReviewList" :key="item.reviewNo">
               <p class="review-title">{{ item.boardTitle }}</p>

               <div v-if="item.isEditing">
                  <p>평점 :
                     <span class="star" v-for="index in 5" :key="index" @click="item.score = index">
                        <span v-if="index <= item.score">⭐</span>
                        <span v-else>☆</span>
                     </span>
                  </p>
                  <textarea v-model="item.contents" class="review-textarea"></textarea>
                  <div>
                     <button class="btn btn-primary review-submit-btn" @click="fnEditReview(item)">저장</button>
                     <button class="btn btn-outline" @click="item.isEditing = false">취소</button>
                  </div>
               </div>

               <div v-else>
                  <div>
                     <span class="review-lawyer">담당 변호사 : {{ item.lawyerId }}</span>
                  </div>
                  <p>평점 :
                     <span class="star" v-for="index in item.score" :key="index">⭐</span>
                  </p>
                  <p>{{ item.contents }}</p>
                  <button class="btn btn-outline" @click="item.isEditing = true">수정</button>
                  <button class="btn btn-danger" @click="fnRemoveReview(item.reviewNo)">삭제</button>
               </div>
            </div>

            <!-- 채팅 내역 -->
            <div class="section">
               <h3>채팅 내역</h3>
               <table>
                  <tr v-for="chat in chatList" :key="chat.chatNo">
                     <td>{{ chat.message }}</td>
                     <td>{{ chat.receiverId }}</td>
                  </tr>
               </table>
            </div>

            <!-- 결제 내역 (단일 결제) -->
            <div class="section">
               <h3>최근 결제 내역</h3>
               <table>
                  <thead>
                     <tr>
                        <th>날짜</th>
                        <th>제품명</th>
                        <th>가격</th>
                     </tr>
                  </thead>
                  <tbody>
                     <tr v-if="payList && payList.length" v-for="pay in payList">
                        <td>{{ pay.payTime }}</td>
                        <td>{{ pay.packageName }}</td>
                        <td>{{ pay.price }}</td>
                     </tr>
                     <tr v-else>
                        <td colspan="3">결제 내역이 없습니다.</td>
                     </tr>
                  </tbody>
               </table>
            </div>

            <div style="text-align: center; margin-top: 20px;">
               <button @click="fnRemoveUser">회원탈퇴</button>
            </div>

         </div>
         <jsp:include page="../common/footer.jsp" />
      </body>

      </html>

      <script>
         const app = Vue.createApp({
            data() {
               return {
                  // sessionId: window.sessionId || "",
                  userId: "user_011",
                  sessionId: "user_011",
                  info: {},
                  boardList: [],
                  chatList: [],
                  payList: [],
                  availReviewList: [], // 작성할 수 있는 리뷰 리스트
                  writtenReviewList: [],   // 이미 작성한 리뷰 리스트
                  isEditing: false,  //true일 때만 수정 모드
               };
            },
            methods: {
               fnGetUserInfo() {
                  var self = this;
                  $.ajax({
                     url: "/mypage/mypage-list.dox",
                     type: "POST",
                     data: { userId: self.sessionId },
                     dataType: "json",
                     success: function (data) {
                        if (data.user && data.user.length > 0) {
                           self.info = data.user[0];
                        }
                     }
                  });
               },
               fnGetBoardList() {
                  var self = this;
                  var nparmap = {
                     userId: self.sessionId
                  };
                  $.ajax({
                     url: "/mypage/my-board-list.dox",
                     type: "POST",
                     data: nparmap,
                     dataType: "json",
                     success: function (data) {
                        console.log("✅ 글 : ", data);
                        self.boardList = data.boardList;
                     }
                  });
               },
               fnGetChatList() {
                  var self = this;
                  var nparmap = {
                     userId: self.sessionId
                  };
                  $.ajax({
                     url: "/mypage/my-chat-list.dox",
                     type: "POST",
                     data: nparmap,
                     dataType: "json",
                     success: function (data) {
                        self.chatList = data.list || [];
                     }
                  });
               },
               fnGetPayList() {
                  var self = this;
                  var nparmap = {
                     userId: self.sessionId
                  };
                  $.ajax({
                     url: "/mypage/my-pay-list.dox",
                     type: "POST",
                     data: nparmap,
                     dataType: "json",
                     success: function (data) {
                        console.log("✅ 결제 내역 응답: ", data);
                        self.payList = data.payList || [];
                     }
                  });
               },

               fnEdit() {
                  location.href = "/join/edit.do";
               },
               fnRemoveUser() {
                  location.href = "/mypage-remove.do";
               },
               //리뷰리스트
               fnLoadReview() {
                  const self = this;
                  const params = {
                     userId: self.sessionId,
                  };
                  $.ajax({
                     url: "/review/list.dox",
                     type: "POST",
                     dataType: "json",
                     data: params,
                     success: function (data) {
                        console.log(data);
                        if (data.result == "success") {
                           self.availReviewList = data.availReviewList;
                           self.writtenReviewList = data.writtenReviewList;
                           self.isEditing = false;
                        }
                     }
                  });
               },
               //리뷰작성
               fnWriteReview(item) {
                  const self = this;
                  if (!item.contents?.trim()) {
                     alert("내용을 입력해주세요.");
                     return;
                  }
                  const params = {
                     userId: self.sessionId,
                     lawyerId: item.lawyerId,
                     boardNo: item.boardNo,
                     score: item.score,
                     contents: item.contents
                  };
                  $.ajax({
                     url: "/review/add.dox",
                     type: "POST",
                     dataType: "json",
                     data: params,
                     success: function (data) {
                        console.log(data);
                        if (data.result === 'success') {
                           alert("리뷰가 등록되었습니다.");
                           self.fnLoadReview();
                        } else {
                           alert("리뷰 등록 실패");
                        }
                     }
                  });
               },
               //작성한 리뷰 수정
               fnEditReview(item) {
                  const self = this;
                  if (!item.contents?.trim()) {
                     alert("리뷰 내용을 입력해주세요.");
                     return;
                  }
                  const params = {
                     reviewNo: item.reviewNo,
                     score: item.score,
                     contents: item.contents,
                     lawyerId: item.lawyerId,
                     userId: self.sessionId
                  };

                  $.ajax({
                     url: "/review/eidt.dox",
                     type: "POST",
                     dataType: "json",
                     data: params,
                     success: function (data) {
                        if (data.result === "success") {
                           alert("리뷰가 수정되었습니다.");
                           self.fnLoadReview(); // 리스트 새로 불러오기
                        } else {
                           alert("리뷰 수정 실패");
                        }
                     }
                  });
               },
               //작성한 리뷰 삭제
               fnRemoveReview(reviewNo) {
                  const self = this;
                  if (!confirm("정말 삭제하시겠습니까?")) return;

                  $.ajax({
                     url: "/review/remove.dox",
                     type: "POST",
                     dataType: "json",
                     data: { reviewNo: reviewNo },
                     success: function (data) {
                        if (data.result === "success") {
                           alert("리뷰가 삭제되었습니다.");
                           self.fnLoadReview(); // 리스트 새로 불러오기
                        } else {
                           alert("리뷰 삭제 실패");
                        }
                     }
                  });
               },
            },
            mounted() {
               this.fnGetUserInfo();
               this.fnGetBoardList();
               this.fnGetChatList();
               this.fnGetPayList();
               this.fnLoadReview();
            }
         });
         app.mount("#app");
      </script>