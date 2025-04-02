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
                     <label for="counselStatus" style="font-weight: bold; margin-right: 8px;">상담 상태 |</label>
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
         
            <div class="card-grid">
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
            <div style="text-align: center; margin-top: 20px;">
               <a v-if="page > 1" href="javascript:;" @click="fnPageMove('prev')">◀</a>
               <a
                 v-for="num in index"
                 :key="num"
                 href="javascript:;"
                 @click="fnPage(num)"
               >
                 <span
                   v-if="page === num"
                   style="margin: 0 5px; font-weight: bold; color: blue;"
                   >{{ num }}</span
                 >
                 <span v-else style="margin: 0 5px;">{{ num }}</span>
               </a>
               <a v-if="page < index" href="javascript:;" @click="fnPageMove('next')">▶</a>
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
               index: 0
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

            fnLawyerBoard() {
               var self = this;
               self.page = 1;
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
                     console.log("확인 : ", data);
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
               pageChange("/lawyerMyPage/edit.dox", { sessionId: this.sessionId });
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
                        alert("상태가 변경되었습니다.");
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
               pageChange("/lawyerMyPage/remove.dox", { sessionId: this.sessionId });
            }

         },
         mounted() {
            this.fnGetList();
            this.fnLawyerBoard();
         }
      });
      app.mount('#app');
   </script>

   ​