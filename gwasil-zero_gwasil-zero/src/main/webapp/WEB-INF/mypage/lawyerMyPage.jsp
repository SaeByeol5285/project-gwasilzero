<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <script src="https://code.jquery.com/jquery-3.7.1.js"
         integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
      <script src="/js/page-change.js"></script>
      <title>과실 ZERO - 교통사고 전문 법률 플랫폼</title>
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
   </style>

   <body>
      <jsp:include page="../common/header.jsp" />
      <div id="app">
         <h2>마이페이지</h2>

         <!-- 내 정보 섹션 -->
         <div class="section">
            <div class="info-header">
              <h3>내 정보</h3>
              <button @click="fnEdit" class="edit-btn">정보 수정</button>
            </div>
          
            <div class="info-section">
               <!-- 프로필 사진 -->
               <div>
                 <img :src="view.lawyerImg" alt="변호사 사진"
                   style="width: 130px; height: 130px; border-radius: 10px; object-fit: cover; border: 1px solid #ccc;" />
               </div>
             
               <!-- 텍스트 정보 + 상담 상태 -->
               <div class="info-details" v-if="view.lawyerId" style="flex: 1;">
                 <div style="display: flex; justify-content: space-between; align-items: center;">
                   <p style="margin: 0;">이름: {{ view.lawyerName }}</p>
                   <div>
                     <label for="counselStatus" style="font-weight: bold; margin-right: 8px;">상담 상태</label>
                     <select id="counselStatus" v-model="view.counsel" @change="fnUpdateStatus" class="status-select">
                       <option value="">선택 안함</option>
                       <option value="now">상담 가능</option>
                       <option value="delayed">상담 지연</option>
                       <option value="disabled">상담 불가능</option>
                     </select>
                   </div>
                 </div>
                 <p>핸드폰 번호: {{ view.lawyerPhone }}</p>
                 <p>이메일: {{ view.lawyerEmail }}</p>
               </div>
             </div>
             
          </div>
          

         <div class="section">
            <h3>내가 쓴 글</h3>
            <div class="post-section">
               <div class="post-card">썸네일<br>제목</div>
               <div class="post-card">썸네일<br>제목</div>
               <div class="post-card">썸네일<br>제목</div>
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
               sessionId: "${sessionId}" // JSP에서 받은 userId 그대로 할당
            };
         },
         methods: {
            fnGetList() {
               var self = this;
               console.log(self.userId);  // 값 확인용 로그
               var nparmap = { sessionId: self.sessionId };
               $.ajax({
                  url: "/lawyerMyPage/view.dox",
                  dataType: "json",
                  type: "POST",
                  data: nparmap,
                  success: function (data) {
                     console.log(data);
                     self.view = data.view;

                     if (!self.view.counsel) {
                        self.view.counsel = '';
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
                    alert("상담 상태가 변경되었습니다.");
                },
                error: function () {
                    alert("상담 상태 변경 실패");
                }
                });
            },

            fnEdit() {
               pageChange("/lawyerMyPage/edit.dox", { sessionId: this.sessionId });
            },
            fnRemoveUser() {
               pageChange("/lawyerMyPage/remove.dox", { sessionId: this.sessionId });
            }
         },
         mounted() {
            this.fnGetList();
         }
      });
      app.mount('#app');
   </script>

   ​