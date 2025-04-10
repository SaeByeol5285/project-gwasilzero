<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script src="/js/page-change.js"></script>
      <title>게시글 수정</title>
      <style>
         body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
         }

         .view-container {
            width: 1200px;
            max-width: 100%;
            margin: 40px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            box-sizing: border-box;
         }

         .input-title {
            width: 100%;
            font-size: 22px;
            font-weight: bold;
            padding: 10px 14px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
         }

         .textarea-content {
            width: 100%;
            min-height: 180px;
            padding: 14px;
            font-size: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            resize: vertical;
            margin-bottom: 30px;
         }

         h4 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
         }

         .media-preview {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 15px;
         }

         .media-preview img,
         .media-preview video {
            max-width: 250px;
            max-height: 180px;
            border-radius: 6px;
            border: 1px solid #ddd;
         }

         .media-preview span {
            font-size: 14px;
            color: #555;
            flex: 1;
         }

         .media-preview button {
            padding: 6px 12px;
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
         }

         .media-preview button:hover {
            background-color: #e60000;
         }

         input[type="file"] {
            margin: 20px 0;
         }

         /* 댓글 스타일 */
         .comment-wrapper {
            width: 1200px;
            max-width: 100%;
            margin: 60px auto 0;
            padding-top: 30px;
            border-top: 1px solid #eee;
            box-sizing: border-box;
         }

         .comment-wrapper h4 {
            margin-bottom: 12px;
            font-size: 18px;
         }

         .comment-wrapper textarea {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ccc;
            margin-bottom: 10px;
            resize: vertical;
         }

         .comment-list {
            margin-top: 20px;
         }

         .comment-item {
            padding: 12px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-bottom: 10px;
         }

         .comment-meta {
            font-size: 13px;
            color: #666;
            margin-bottom: 4px;
         }

         .comment-text {
            font-size: 14px;
         }

         .btn {
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 6px;
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

         .btn-red {
            background-color: #ffe1e1;
            color: #e60000;
            font-weight: 600;
         }

         .btn-red:hover {
            background-color: #e60000;
            color: #fff;
         }

         .btn-blue {
            background-color: #e3f2ff;
            color: #007bff;
            font-weight: 600;
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
            <input v-model="board.boardTitle" placeholder="제목을 입력하세요" class="input-title" />
            <textarea v-model="board.contents" placeholder="내용을 입력하세요" class="textarea-content"></textarea>

            <h4>첨부파일</h4>
            <div v-for="(file, index) in boardFile" :key="file.fileName" class="media-preview">
               <img v-if="isImage(file.fileName)" :src="file.filePath.replace('../', '/')" alt="이미지 미리보기" />
               <video v-else-if="isVideo(file.fileName)" controls>
                  <source :src="file.filePath.replace('../', '/')" type="video/mp4" />
               </video>
               <span>{{ file.fileRealName }}</span>
               <button @click="removeFile(index)">삭제</button>
            </div>

            <input type="file" multiple @change="handleFileUpload" />

            <button @click="submitEdit" class="btn btn-write" style="margin-right: 5px;">✏️ 수정 완료</button>
            <button @click="deleteBoard" class="btn btn-red">🗑️ 삭제</button>
         </div>
         <div class="comment-wrapper">
            <h4>댓글</h4>
            <textarea v-model="newComment" placeholder="댓글을 입력하세요" rows="3"></textarea>
            <button @click="submitComment" class="btn btn-blue">💬 댓글 등록</button>

            <div class="comment-list" v-if="comments.length > 0">
               <div class="comment-item" v-for="(cmt, index) in comments" :key="index">
                  <div class="comment-meta">{{ cmt.lawyerName }} | {{ cmt.cdate }}</div>
                  <div class="comment-text">{{ cmt.contents }}</div>
               </div>
            </div>
         </div>
      </div>
      <jsp:include page="../common/footer.jsp" />
   </body>

   <script>
      const app = Vue.createApp({
         data() {
            return {
               board: {},
               deletedFiles: [],
               boardNo: "${map.boardNo}",
               sessionId: "${sessionScope.sessionId}",
               boardFile: [],
               newFiles: [],
               images: [],
               videos: [],
               comments: [],
               newComment: ""
            };
         },
         methods: {
            fnGetBoard() {
               const self = this;
               $.ajax({
                  url: "/board/view.dox",
                  type: "POST",
                  data: { boardNo: self.boardNo, sessionId: self.sessionId },
                  dataType: "json",
                  success: function (data) {
                     if (data.result === 'success') {
                        self.board = data.board;
                        self.comments = data.comment || [];

                        // 썸네일이 아닌 파일만 필터링
                        self.boardFile = (data.boardFile || []).filter(file => file && file.thumbnail !== 'Y');

                        // 미리보기용 분류
                        self.images = [];
                        self.videos = [];
                        self.boardFile.forEach(file => {
                           const lower = file.fileName?.toLowerCase() || "";
                           if (/\.(jpg|jpeg|png|gif|jfif)$/.test(lower)) {
                              self.images.push(file);
                           } else if (/\.(mp4|mov|avi)$/.test(lower)) {
                              self.videos.push(file);
                           }
                        });
                     } else {
                        alert("게시글 데이터를 불러오지 못했습니다.");
                     }
                  },
                  error: function () {
                     alert("서버 통신 실패");
                  }
               });
            },
            isImage(name) {
               return /\.(jpg|jpeg|png|gif|jfif)$/i.test(name);
            },
            isVideo(name) {
               return /\.(mp4|mov|avi)$/i.test(name);
            },
            removeFile(index) {
               this.boardFile.splice(index, 1);
            },
            handleFileUpload(event) {
               this.newFiles = Array.from(event.target.files);
            },
			submitEdit() {
			    const formData = new FormData();
			    formData.append("boardNo", this.board.boardNo);
			    formData.append("boardTitle", this.board.boardTitle);
			    formData.append("contents", this.board.contents);

			    this.newFiles.forEach(f => formData.append("files", f));
			    this.deletedFiles.forEach(f => formData.append("deletedFiles", f));

			    $.ajax({
			        url: "/board/edit.dox",
			        method: "POST",
			        data: formData,
			        processData: false,
			        contentType: false,
			        success: function () {
			            Swal.fire({
			                icon: "success",
			                title: "수정 완료!",
			                text: "게시글이 성공적으로 수정되었습니다.",
			                confirmButtonText: "확인"
			            }).then(() => {
			                location.href = "/board/list.do";
			            });
			        }
			    });
			},
            deleteBoard() {
               let self = this;

               Swal.fire({
                  title: '정말 삭제하시겠습니까?',
                  text: "삭제된 게시글은 복구할 수 없습니다.",
                  icon: 'warning',
                  showCancelButton: true,
                  confirmButtonColor: '#ff5c00',
                  cancelButtonColor: '#aaa',
                  confirmButtonText: '네, 삭제할게요',
                  cancelButtonText: '취소'
               }).then((result) => {
                  if (result.isConfirmed) {
                     $.post("/board/delete.dox", { boardNo: self.board.boardNo }, () => {
                        Swal.fire({
                           title: '삭제 완료!',
                           text: '게시글이 성공적으로 삭제되었습니다.',
                           icon: 'success',
                           confirmButtonColor: '#ff5c00',
                           confirmButtonText: '확인'
                        }).then(() => {
                           location.href = "/board/list.do";
                        });
                     });
                  }
               });
            },

            submitComment() {
               const self = this;
               if (!self.newComment.trim()) {
                  alert("댓글을 입력해주세요");
                  return;
               }

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
                     self.fnGetBoard(); // 댓글 다시 불러오기
                  }
               });
            },
            removeFile(index) {
               const file = this.boardFile[index];
               this.deletedFiles.push(file.fileName); // 삭제될 파일명 저장
               this.boardFile.splice(index, 1); // 화면에서 제거
            },
         },
         mounted() {
            this.fnGetBoard();
         }
      });
      app.mount("#app");
   </script>

   </html>