<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<script src="/js/page-change.js"></script>
	<title>게시글 상세보기</title>
	<style>
		body {
		    font-family: 'Arial', sans-serif;
		    background-color: #f5f5f5;
		    margin: 0;
		    padding: 0;
		}

		.view-container {
		    width: 65%;
		    margin: 40px auto;
		    padding: 30px;
		    background-color: #fff;
		    border-radius: 10px;
		    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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

		button {
		    padding: 8px 16px;
		    font-size: 14px;
		    border: none;
		    border-radius: 4px;
		    margin-right: 8px;
		    cursor: pointer;
		}

		button:hover {
		    opacity: 0.9;
		}

		button:nth-child(1) {
		    background-color: #007bff;
		    color: white;
		}

		button:nth-child(2) {
		    background-color: #dc3545;
		    color: white;
		}

		/* 댓글 스타일 */
		.comment-wrapper {
		    border-top: 1px solid #eee;
		    margin-top: 40px;
		    padding-top: 30px;
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

		.comment-wrapper button {
		    background-color: #007bff;
		    color: white;
		    border: none;
		    padding: 6px 12px;
		    border-radius: 4px;
		    cursor: pointer;
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
	</style>
</head>
<body>
	<div id="app">
	    <div class="view-container" v-if="board?.boardNo">
			<input v-model="board.boardTitle" placeholder="제목을 입력하세요" class="input-title"/>
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

			<!-- 댓글 출력 -->
			<div v-for="cmt in comments" :key="cmt.commentId" class="comment-item">
			  {{ cmt.lawyerName }} - {{ cmt.contents }}
			</div>

			<!-- 저장/삭제 버튼 -->
			<button @click="submitEdit">수정 완료</button>
			<button @click="deleteBoard">삭제</button>
		
		<div class="comment-wrapper">
		  <h4>댓글</h4>

		  <!-- 입력창 -->
		  <textarea v-model="newComment" placeholder="댓글을 입력하세요" rows="3"></textarea>
		  <button @click="submitComment">등록</button>

		  <!-- 목록 -->
		  <div class="comment-list" v-if="comments.length > 0">
		    <div class="comment-item" v-for="(cmt, index) in comments" :key="index">
		      <div class="comment-meta">{{ cmt.lawyerName }} | {{ cmt.cdate }}</div>
		      <div class="comment-text">{{ cmt.contents }}</div>
		    </div>
		  </div>
		</div>
		
	</div>
</body>
</html>

<script>
	const app = Vue.createApp({
	    data() {
	        return {
	            board: {},
	            boardNo: "${map.boardNo}",
	            images: [],
	            videos: [],
				comments:[],
				newComment: "",
				lawyer_id:"lawyer_2",
				boardFile: [],          
				newFiles: []
	        };
	    },
	    methods: {
	        fnGetBoard() {
	            const self = this;
	            $.ajax({
	                url: "/board/view.dox",
	                type: "POST",
	                data: { boardNo: self.boardNo },
	                dataType: "json",
	                success: function (data) {
	                    console.log(data);
	                    self.board = data.board;
						self.comments = data.comment || [];
						self.boardFile = data.boardFile || [];
						
	                    // 파일 분류
	                    self.images = [];
	                    self.videos = [];
	                    data.boardFile.forEach(file => {
							if (file.thumbnail === 'Y') return; // 썸네일은 건너뜀

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
						   lawyerId: self.lawyer_id
			           },
			           success: function () {
			               self.newComment = "";
			               self.fnGetBoard(); // 댓글 다시 불러오기
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
			       // 서버에서도 삭제하려면 해당 file 정보 저장
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

			       $.ajax({
			         url: "/board/edit.dox",
			         method: "POST",
			         data: formData,
			         processData: false,
			         contentType: false,
			         success: () => alert("수정 완료")
			       });
			     },
			     deleteBoard() {
			       if (!confirm("정말 삭제하시겠습니까?")) return;

			       $.post("/board/delete.dox", { boardNo: this.board.boardNo }, () => {
			         alert("삭제 완료");
			         location.href = "/board/list.do";
			       });
			     }
	    },
	    mounted() {
			let self = this;
	        self.fnGetBoard();
	    }
	});
	app.mount("#app");
</script>

​