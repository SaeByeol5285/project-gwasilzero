<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
      <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
      <script src="/js/page-change.js"></script>
      <title>sample.jsp</title>
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
            margin-top: 15px;
         }

         .post-card {
            width: 30%;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            background-color: #f9f9f9;
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
         }

         .chat-section table,
         .payment-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
         }

         .chat-section th,
         .chat-section td,
         .payment-table th,
         .payment-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
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
            width: 100%;
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
      </style>
   </head>

   <body>
      <jsp:include page="../common/header.jsp" />
      <div id="app">
         <h2>마이페이지</h2>

         <div class="section info-section">
            <div>
               <h3>내 정보</h3>
               <div class="info-details" v-if="info.userName">
                  이름: {{ info.userName }}<br>
                  핸드폰 번호: {{ info.userPhone }}<br>
                  이메일: {{ info.userEmail }}
               </div>
            </div>
            <button @click="fnEdit" class="btn btn-primary">정보 수정</button>
         </div>

         <div class="section">
            <h3>내가 쓴 글</h3>
            <div class="post-section">
               <div class="post-card">썸네일<br>제목</div>
               <div class="post-card">썸네일<br>제목</div>
               <div class="post-card">썸네일<br>제목</div>
            </div>
         </div>

         <!-- 리뷰 작성 가능한 항목 -->
         <div v-if="reviewList.length" class="section review-section">
            <h3>리뷰 작성 가능한 항목</h3>
            <div class="review-card" v-for="item in reviewList" :key="item.boardNo">
               <p class="review-title"><strong>{{ item.boardTitle }}</strong></p>
               <p class="review-lawyer">{{ item.lawyerId }}</p>
               <div class="review-score">
                  <label>별점:
                     <select v-model="item.score">
                        <option v-for="n in 5" :key="n" :value="n">{{ n }}</option>
                     </select>
                  </label>
               </div>
               <textarea v-model="item.contents" placeholder="리뷰 내용을 입력해주세요" class="review-textarea"></textarea>
               <button class="btn btn-primary review-submit-btn" @click="fnWriteReview(item)">리뷰 등록</button>
            </div>
         </div>

         <div class="section chat-section">
            <h3>채팅 내역</h3>
            <table>
               <tr>
                  <td>안녕하세요. OOO 입니다.</td>
                  <td>000 번호사</td>
               </tr>
               <tr>
                  <td>안녕하세요. 사고 관련해서 연락드립니다.</td>
                  <td>XXX 번호사</td>
               </tr>
            </table>
         </div>

         <div class="section">
            <h3>결제 내역</h3>
            <table class="payment-table">
               <thead>
                  <tr>
                     <th>날짜</th>
                     <th>제품명</th>
                     <th>가격</th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td>2025-03-20</td>
                     <td>제품 A</td>
                     <td>₩10,000</td>
                  </tr>
                  <tr>
                     <td>2025-03-21</td>
                     <td>제품 B</td>
                     <td>₩20,000</td>
                  </tr>
               </tbody>
            </table>
         </div>

         <div style="text-align: center; margin-top: 20px;">
            <button @click="fnRemoveUser" class="btn btn-danger">회원탈퇴</button>
         </div>
      </div>
      <jsp:include page="../common/footer.jsp" />
   </body>
   <script>
      const app = Vue.createApp({
         data() {
            return {
               info: {},
               userId: "user_011",
               sessionId: "user_011",
               reviewList: [],
               contents: "",
            };
         },
         methods: {
            fnGetList() {
               const self = this;
               $.post('/mypage/mypage-view.dox', { userId: self.userId }, function (data) {
                  self.info = data.info;
               }, 'json');
            },
            fnEdit() {
               pageChange("/mypage/edit.do", { userId: this.userId });
            },
            fnRemoveUser() {
               pageChange("/mypage/remove.do", { userId: this.userId });
            },
            fnLoadReview() {
               const self = this;
               const params = {
                  userId: self.sessionId,
               };
               $.ajax({
                  url: "/review/available.dox",
                  type: "POST",
                  dataType: "json",
                  data: params,
                  success: function (data) {
                     console.log(data);
                     if (data.result == "success") {
                        self.reviewList = data.list;
                     }
                  }
               });
            },
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

         },
         mounted() {
            this.fnGetList();
            this.fnLoadReview();
         }
      });
      app.mount('#app');
   </script>

   </html>