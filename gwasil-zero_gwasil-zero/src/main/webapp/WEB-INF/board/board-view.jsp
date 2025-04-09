<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script src="/js/page-change.js"></script>
      <title>게시글 상세보기</title>
	  <style>
	           .view-container {
	              width: 1200px;
	              max-width: 100%;
	              margin: 40px auto;
	              padding: 30px;
	              box-sizing: border-box;
	              border: 1px solid #ddd;
	              border-radius: 10px;
	              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	              background-color: #fff;
	              font-family: 'Arial', sans-serif;
	           }

	           /* 제목 */
	           .view-title {
	              font-size: 30px;
	              font-weight: 800;
	              margin-bottom: 16px;
	              color: #333;
	              display: flex;
	              align-items: center;
	              gap: 10px;
	           }

	           /* 아이콘 */
	           .title-icon {
	              font-size: 32px;
	              color: #FF5722;
	           }

	           .view-meta {
	              display: flex;
	              justify-content: space-between;
	              flex-wrap: wrap;
	              font-size: 14px;
	              color: #666;
	              margin-bottom: 20px;
	           }

	           .view-meta small {
	              font-size: 13px;
	              color: #888;
	           }

	           .view-content {
	              font-size: 16px;
	              line-height: 1.6;
	              white-space: pre-line;
	              margin-bottom: 30px;
	           }

	           /* 첨부 이미지/비디오 */
	           .media-section {
	              display: flex;
	              flex-wrap: wrap;
	              gap: 20px;
	              margin-bottom: 30px;
	           }

	           .media-section img {
	              width: 250px;
	              height: auto;
	              border-radius: 8px;
	              border: 1px solid #ccc;
	           }

	           .media-section video {
	              width: 100%;
	              max-width: 480px;
	              border-radius: 8px;
	              border: 1px solid #ccc;
	           }

	           /* 댓글 영역 */
	           .comment-list {
	              width: 1200px;
	              max-width: 100%;
	              margin: 40px auto;
	              padding-top: 20px;
	              border-top: 1px solid #eee;
	              box-sizing: border-box;
	           }

	           .comment-list h4 {
	              margin-bottom: 12px;
	              font-size: 18px;
	           }

	           .comment-item {
	              margin-bottom: 12px;
	              padding: 10px;
	              border: 1px solid #ddd;
	              border-radius: 6px;
	              background-color: #f9f9f9;
	           }

	           .comment-meta {
	              font-size: 13px;
	              color: #666;
	              display: flex;
	              justify-content: space-between;
	              align-items: center;
	              margin-bottom: 4px;
	           }

	           .comment-actions {
	              display: flex;
	              gap: 12px;
	              font-size: 13px;
	              color: #FF5722;
	              cursor: pointer;
	           }

	           .comment-actions span:hover {
	              text-decoration: underline;
	           }

	           .comment-text {
	              font-size: 14px;
	           }

	           textarea {
	              width: 100%;
	              max-width: 100%;
	              box-sizing: border-box;
	              padding: 10px;
	              font-size: 14px;
	              border-radius: 6px;
	              border: 1px solid #ccc;
	              margin-bottom: 10px;
	              resize: vertical;
	           }

	           .btn-orange {
	              padding: 6px 12px;
	              font-size: 14px;
	              background-color: #FF5722;
	              color: white;
	              border: none;
	              border-radius: 4px;
	              cursor: pointer;
	           }

	           .btn-green {
	              padding: 6px 12px;
	              font-size: 14px;
	              background-color: #28a745;
	              color: white;
	              border: none;
	              border-radius: 4px;
	              cursor: pointer;
	           }

	           .btn-orange:hover {
	              background-color: #e64a19;
	           }

	           .action-buttons {
	              margin-top: 5px;
	              display: flex;
	              justify-content: flex-end;
	              gap: 6px;
	           }

	           .text-green {
	              color: #28a745;
	              font-weight: 500;
	              cursor: pointer;
	           }

	           .text-green:hover {
	              text-decoration: underline;
	           }

	           /* 연관 게시글 영역 */
	           .related-wrapper {
	              width: 1200px;
	              max-width: 100%;
	              margin: 60px auto;
	              text-align: center;
	              border-top: 3px double #FF5722;
	              border-bottom: 3px double #FF5722;
	              padding: 20px 0;
	              box-sizing: border-box;
	           }

	           .related-title {
	              font-size: 22px;
	              font-weight: bold;
	              color: #333;
	              margin-bottom: 24px;
	              display: flex;
	              align-items: center;
	              justify-content: center;
	              gap: 6px;
	              position: relative;
	           }

	           .related-cards {
	              display: flex;
	              justify-content: center;
	              flex-wrap: wrap;
	              gap: 20px;
	              margin-top: 30px;
	           }

	           
	           .related-card {
	              width: 200px;
	              border: 1px solid #ddd;
	              border-radius: 12px;
	              overflow: hidden;
	              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	              cursor: pointer;
	              transition: transform 0.25s, box-shadow 0.25s;
	              background-color: #fff;
	           }


	           .related-card:hover {
	              transform: translateY(-6px);
	              box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
	           }

	           .related-card img {
	              width: 100%;
	              height: 130px;
	              object-fit: cover;
	              border-bottom: 1px solid #eee;
	              background-color: #f2f2f2;
	           }

	           .card-info {
	              padding: 12px;
	           }

	           .card-info h5 {
	              font-size: 15px;
	              margin: 0 0 6px;
	              color: #333;
	              white-space: nowrap;
	              overflow: hidden;
	              text-overflow: ellipsis;
	           }

	           .card-info p {
	              font-size: 13px;
	              color: #777;
	              margin: 0;
	           }

	           .btn {
	              padding: 8px 16px;
	              font-size: 14px;
	              font-weight: 500;
	              border-radius: 6px;
	              border: none;
	              cursor: pointer;
	              transition: all 0.2s ease;
	           }

	           .btn-write {
	              background-color: #ffece4;
	              color: #ff5c00;
	              font-weight: 600;
	           }

	           .btn-write:hover {
	              background-color: #ff6b1a;
	              color: #fff;
	           }

	           .btn-blue {
	              padding: 8px 16px;
	              font-size: 14px;
	              font-weight: 500;
	              border-radius: 6px;
	              cursor: pointer;
	              transition: all 0.2s ease;
	              background-color: #e3f2ff;
	              color: #007bff;
	              font-weight: 600;
	              border: none;
	           }

	           .btn-blue:hover {
	              background-color: #007bff;
	              color: #fff;
	           }
	        </style>      
   </head>

   <body>
      <jsp:include page="../common/header.jsp" />
      <div id="app">
         <div class="view-container" v-if="board?.boardNo">
            <div class="view-title"><span class="title-icon">📣</span>{{ board.boardTitle }}
               <img 
                 v-if="sessionType === 'lawyer'" 
                 src="/img/icon-chat.png"
                 @click="fnChatWithUser"
                 title="문의자와 채팅하기"
                 style="width: 20px; height: 20px; margin-left: auto; cursor: pointer;"
               />
            </div>

            <div class="view-meta">
               <div>
                  작성자: {{ board.userName }} | 담당 변호사: {{ board.lawyerName }} | 등록일: {{ board.cdate }}
               </div>
               <small>
                 조회수: {{ board.cnt }} | 상태: {{ getStatusLabel(board.boardStatus) }}
               </small>
            </div>

            <div class="view-content">
               {{ board.contents }}
            </div>

            <div class="media-section" v-if="images.length > 0">
               <h4>첨부 이미지</h4>
               <div v-for="img in images" :key="img.fileName">
                  <img :src="img.filePath.replace('../', '/')" alt="첨부 이미지">
               </div>
            </div>

            <div class="media-section" v-if="videos.length > 0">
               <h4>첨부 영상</h4>
               <div v-for="vid in videos" :key="vid.fileName">
                  <video controls>
                     <source :src="vid.filePath.replace('../', '/')" type="video/mp4">
                     브라우저가 video 태그를 지원하지 않습니다.
                  </video>
               </div>
            </div>
            <button v-if="sessionId === board.userId" @click="EditBoard" class="btn btn-write">✏️ 수정하기</button>
         </div>

         
         
         <!-- 관련된 게시글 영역 -->
         <div class="related-wrapper" v-if="relatedBoards.length > 0">
           <div class="related-title">📌 연관된 게시글</div>
           <div class="related-cards">
             <div
               class="related-card"
               v-for="item in relatedBoards"
               :key="item.boardNo"
               @click="goToBoard(item.boardNo)"
             >
               <img
                 :src="item.thumbnailPath?.replace('../', '/')"
                 alt="썸네일"
                 @error="e => e.target.src = '/img/common/image_not_exist.jpg'"
               />
               <div class="card-info">
                 <h5>{{ item.boardTitle }}</h5>
                 <p>작성자: {{ item.userName }}</p>
               </div>
             </div>
           </div>
         </div>
         
         
         <div class="comment-list" v-if="comments.length >= 0">
                   <h4>댓글</h4>

                   <div class="comment-item" v-for="(cmt, index) in comments" :key="index">
                     <div class="comment-meta">
                       <span>{{ cmt.lawyerName }} | {{ cmt.cdate }}</span>
                       <div style="display: flex; align-items: center; gap: 6px; margin-left: auto;">
                        <span class="comment-actions" v-if="sessionType === 'lawyer' && cmt.lawyerId === sessionId">
                           <span class="text-green" @click="updateComment(cmt.cmtNo)">수정</span>
                           <span style="font-weight: bold;" @click="deleteComment(cmt.cmtNo)">삭제</span>
                         </span>
  
                         <!-- 북마크 아이콘 -->
                          <img
                          v-if="sessionType === 'user'"
                          :src="isBookmarked(cmt.lawyerId) ? '/img/selectedBookmark.png' : '/img/Bookmark.png'"
                          @click="toggleBookmark(cmt.lawyerId)"
                          style="width: 18px; height: 18px; margin-left: 8px; cursor: pointer;"
                          />
  
                          <!-- 계약 아이콘 -->
                          <img
                          v-if="sessionType === 'user'"
                          src="/img/contract.png"
                          @click="startContract(cmt.lawyerId)"
                          title="계약하기"
                          style="width: 18px; height: 18px; margin-left: 8px; cursor: pointer;"
                          />
  
                          <!-- 채팅 아이콘 -->
                          <img
                          v-if="sessionType === 'user'"
                          src="/img/icon-chat.png"
                          @click="startChat(cmt.lawyerId)"
                          title="채팅하기"
                          style="width: 18px; height: 18px; margin-left: 8px; cursor: pointer;"
                          />
                       </div>
                       
                     </div>
                    <div class="comment-text">
                      <div v-if="editingCommentNo === cmt.cmtNo">
                        <textarea v-model="editedComment" rows="3"></textarea>
                        <div style="margin-top: 5px;">
                          <button class="btn-green" @click="saveUpdatedComment(cmt.cmtNo)">저장</button>
                          <button class="btn-orange" @click="cancelUpdate" style="margin-left: 5px;">취소</button>
                        </div>
                      </div>
                      <div v-else>
                        {{ cmt.contents }}
                      </div>
                    </div>
                   </div>

                   <div v-if="sessionType === 'lawyer' ">
                     <textarea v-model="newComment" placeholder="댓글을 입력하세요." rows="3"></textarea>
                     <button class="btn-blue" @click="checkLawyerAndSubmit">💬 댓글 등록</button>
                   </div>
                 </div>



         </div>
         <jsp:include page="../common/footer.jsp" />
   </body>

   </html>

   <script>
      const app = Vue.createApp({
         data() {
            return {
               board: {},
               boardNo: "${map.boardNo}",
               sessionId: "${sessionScope.sessionId}",
               images: [],
               videos: [],
               comments: [],
               newComment: "",
               lawyer_id: "",
               sessionType: "${sessionScope.sessionType}",
               bookmarkList: [],
               makerId: "",
               editingCommentNo: null,
               editedComment: "",
               relatedBoards: [],
               authResult : ""
            };
         },
         methods: {
            fnGetBoard() {
               const self = this;
               $.ajax({
                  url: "/board/view.dox",
                  type: "POST",
                  data: {
                     boardNo: self.boardNo,
                     sessionId: self.sessionId
                  },
                  dataType: "json",
                  success: function (data) {
                     console.log(data);
                     console.log(self.sessionType);
                     self.board = data.board;
                     self.makerId = data.board.userId;
                     self.comments = data.comment || [];
                     self.bookmarkList = data.bookmark;
                     self.images = [];
                     self.videos = [];
                     data.boardFile.forEach(file => {
                        if (file.thumbnail === 'Y') return;
                        const lower = file.fileName.toLowerCase();
                        if (lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png') || lower.endsWith('.gif') || lower.endsWith('.jfif')) {
                           self.images.push(file);
                        } else if (lower.endsWith('.mp4') || lower.endsWith('.mov') || lower.endsWith('.avi')) {
                           self.videos.push(file);
                        }
                     });
                  }
               });
            },
            checkLawyerAndSubmit() {
               const self = this;

               if (!self.newComment.trim()) {
                  Swal.fire({
                     icon: "warning",
                     title: "입력 필요",
                     text: "댓글을 입력해주세요.",
                     confirmButtonColor: "#ff5c00"
                  });
                  return;
               }

               $.ajax({
                  url: "/board/checkLawyerStatus.dox",
                  type: "POST",
                  data: {
                     sessionId: self.sessionId
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
                           title: "등록기간 만료",
                           text: "변호사 등록기간이 만료되었습니다.",
                           confirmButtonColor: "#ff5c00"
                        }).then(() => {
                           location.href = "/package/package.do";
                        });
                        return;
                     }

                     // 조건 통과 → 댓글 등록
                     $.ajax({
                        url: "/board/commentAdd.dox",
                        type: "POST",
                        data: {
                           boardNo: self.boardNo,
                           contents: self.newComment,
                           lawyerId: self.sessionId
                        },
                        success: function () {
                           self.newComment = "";
                           self.addNotification();
                           self.fnGetBoard();
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

            EditBoard: function () {
               let self = this;
               pageChange("/board/edit.do", { boardNo: self.boardNo, userId: self.sessionId });
            },
            isBookmarked(lawyerId) {
               return this.bookmarkList.some(bm => bm.lawyerId === lawyerId);
            },
            toggleBookmark(lawyerId) {
               const self = this;

               if (!self.sessionId) {
                  alert("로그인이 필요합니다.");
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
                        alert(data.result);
                     } else {
                        self.bookmarkList.push({ lawyerId: lawyerId });
                        alert(data.result);
                     }
                  },
                  error: function () {
                     alert("북마크 처리 중 오류가 발생했습니다.");
                  }
               });
            },
            addNotification() {
               let self = this;
               var nparmap = {
                  senderId: self.sessionId,
                  notiType: "C",
                  contents: "새 댓글이 달렸습니다",
                  receiverId: self.makerId,
                  boardNo: self.boardNo
               };
               $.ajax({
                  url: "/notification/add.dox",
                  dataType: "json",
                  type: "POST",
                  data: nparmap,
                  success: function (data) {
                     console.log(data);
                     if (data.result == "success") {
                        self.list = data.list;
                     } else {
                        alert("오류발생");
                     }
                  }
               });
            },
            startContract(lawyerId) {
               let self = this;
               pageChange("/contract/newContract.do", { lawyerId: lawyerId, boardNo: self.boardNo, userId: self.makerId });
            },
            startChat(lawyerId) {
               let self = this;
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
            deleteComment(cmtNo) {
               const self = this;
               if (!confirm("댓글을 삭제하시겠습니까?")) return;
               $.ajax({
                  url: "/board/commentDelete.dox",
                  type: "POST",
                  data: {
                     cmtNo: Number(cmtNo),
                     lawyerId: self.sessionId
                  },
                  success: function (res) {
                     if (res.result === "success") {
                        alert("댓글이 삭제되었습니다.");
                        self.fnGetBoard();
                     } else {
                        alert("댓글 삭제 실패");
                     }
                  }
               });
            },
            updateComment(cmtNo) {
               const comment = this.comments.find(c => c.cmtNo === cmtNo);
               this.editingCommentNo = cmtNo;
               this.editedComment = comment.contents;
            },
            saveUpdatedComment(cmtNo) {
               const self = this;
               if (!self.editedComment.trim()) {
                  alert("내용을 입력해주세요.");
                  return;
               }
               $.ajax({
                  url: "/board/commentUpdate.dox",
                  type: "POST",
                  data: {
                     cmtNo: cmtNo,
                     contents: self.editedComment,
                     lawyerId: self.sessionId
                  },
                  success: function (res) {
                     if (res.result === "success") {
                        alert("댓글이 수정되었습니다.");
                        self.editingCommentNo = null;
                        self.editedComment = "";
                        self.fnGetBoard();
                     } else {
                        alert("댓글 수정 실패");
                     }
                  }
               });
            },
            cancelUpdate() {
               this.editingCommentNo = null;
               this.editedComment = "";
            },
            fnGetBoardWithKeyword(){
               let self = this;
               $.ajax({
                 url: "/board/related.dox",
                 type: "POST",
                 data: { boardNo: self.boardNo },
                 dataType: "json",
                 success: function (res) {
                   self.relatedBoards = res.related || [];
                 }
               });
            },
            goToBoard(boardNo) {
               pageChange("/board/view.do", { boardNo: boardNo });
            },
            fnChatWithUser() {
              let self = this;

              if (!self.sessionId || !self.makerId) {
                alert("채팅 정보를 불러올 수 없습니다.");
                return;
              }

              $.ajax({
                url: "/chat/findOrCreate.dox",
                type: "POST",
                data: {
                  userId: self.makerId,
                  lawyerId: self.sessionId
                },
                success: function (res) {
                  let chatNo = res.chatNo;
                  pageChange("/chat/chat.do", {
                    chatNo: chatNo
                  });
                },
                error: function () {
                  alert("채팅 연결에 실패했습니다.");
                }
              });
            },
            getStatusLabel(status) {
                switch (status) {
                  case 'DOING':
                    return '진행중';
                  case 'WAIT':
                    return '대기중';
                  case 'END':
                    return '종료됨';
                  default:
                    return status;
                }
              },
              fnIncreaseViewCount() {
                  let self = this;
                  $.ajax({
                    url: "/board/increaseView.dox",
                    type: "POST",
                    data: { boardNo: self.boardNo },
                    success: function (res) {
                      // 증가 성공 시 다시 board 정보 불러올 수도 있음
                      if (res.result === "success") {
                        self.board.cnt++;  // 혹은 res.newCount로 대체 가능
                      }
                    },
                    error: function () {
                      console.error("조회수 증가 실패");
                    }
                  });
                },
         },
         mounted() {
            let self = this;
            console.log(self.sessionType);
            self.fnGetBoard();
            self.fnGetBoardWithKeyword();
            self.fnIncreaseViewCount();
         }
      });
      app.mount("#app");
   </script>