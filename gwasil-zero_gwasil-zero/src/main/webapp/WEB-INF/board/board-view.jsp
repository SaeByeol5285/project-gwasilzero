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
	    .view-container {
	        width: 65%;
	        margin: 40px auto;
	        padding: 30px;
	        border: 1px solid #ddd;
	        border-radius: 10px;
	        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	        background-color: #fff;
	        font-family: 'Arial', sans-serif;
	    }
	    .view-title {
	        font-size: 28px;
	        font-weight: bold;
	        margin-bottom: 16px;
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
		
		.comment-wrapper {
		    max-width: 70%;
		    margin: 40px auto 0 auto;
		    padding: 20px;
		    border-top: 1px solid #eee;
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
		    padding: 6px 12px;
		    font-size: 14px;
		    background-color: #007bff;
		    color: white;
		    border: none;
		    border-radius: 4px;
		    cursor: pointer;
		}

		.comment-wrapper button:hover {
		    background-color: #0056b3;
		}

		.comment-list {
		    margin-top: 20px;
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
		    margin-bottom: 4px;
		}

		.comment-text {
		    font-size: 14px;
		}
		
	</style>
</head>
<body>
	<jsp:include page="../common/header.jsp"/>
	<div id="app">
	    <div class="view-container" v-if="board?.boardNo">
	        <div class="view-title">{{ board.boardTitle }}</div>
	        
	        <div class="view-meta">
	            <div>
	                작성자: {{ board.userName }} | 담당 변호사: {{ board.lawyerName }} | 등록일: {{ board.cdate }}
	            </div>
	            <small>조회수: {{ board.cnt }} | 상태: {{ board.boardStatus }}</small>
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
			<button v-if="sessionId === board.userId" @click="EditBoard">수정</button>

	    </div>
		
		<div class="comment-wrapper">
		  <h4>댓글</h4>
		  <!-- 목록 -->
		  <div class="comment-list" v-if="comments.length > 0">
		    <div class="comment-item" v-for="(cmt, index) in comments" :key="index">
		      <div class="comment-meta">
		        {{ cmt.lawyerName }} | {{ cmt.cdate }}
				<button
				      v-if="sessionType === 'lawyer' && cmt.lawyerId === sessionId"
				      @click="deleteComment(cmt.cmtNo)"
				      style="margin-left: 10px; background: none; border: none; color: red; cursor: pointer;"
				    >
				      삭제
				 </button>
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
		      <div class="comment-text">{{ cmt.contents }}</div>
		    </div>
		  </div>

			  <div v-if="sessionType === 'lawyer' ">
			      <textarea v-model="newComment" placeholder="댓글을 입력하세요" rows="3"></textarea>
			      <button @click="submitComment">등록</button>
			  </div>

		 
		</div>

		
	</div>
	<jsp:include page="../common/footer.jsp"/>
</body>
</html>

<script>
	const app = Vue.createApp({
	    data() {
	        return {
	            board: {},
	            boardNo: "${map.boardNo}",
				sessionId : "${sessionScope.sessionId}",
	            images: [],
	            videos: [],
				comments:[],
				newComment: "",
				lawyer_id:"",
				sessionType : "${sessionScope.sessionType}",
				bookmarkList : [],
				makerId : ""
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
						sessionId : self.sessionId
					},
	                dataType: "json",
	                success: function (data) {
	                    console.log(data);
						console.log(self.sessionType);
	                    self.board = data.board;
						self.makerId = data.board.userId;
						self.comments = data.comment || [];
						self.bookmarkList = data.bookmark;
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
						   lawyerId: self.sessionId
			           },
			           success: function () {
			               self.newComment = "";
						   self.addNotification();
			               self.fnGetBoard(); // 댓글 다시 불러오기
			           }
			       });
			   },
			EditBoard: function(){
				let self = this;
				pageChange("/board/edit.do", {boardNo : self.boardNo, userId : self.sessionId});
			},
			isBookmarked(lawyerId) {
			   return this.bookmarkList.some(bm => bm.lawyerId === lawyerId);
			 },

			 // 북마크 토글
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
			 addNotification(){
				let self = this;
				var nparmap = {
					senderId : self.sessionId,
					notiType : "C",
					contents : "새 댓글이 달렸습니다",
					receiverId : self.makerId,
					boardNo : self.boardNo
				};
				$.ajax({
					url:"/notification/add.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						if(data.result == "success"){
							self.list = data.list;
						} else {
							alert("오류발생");
						}
					}
				});
			 },
			 startContract(lawyerId) {
				let self = this;
			        pageChange("/contract/newContract.do", { lawyerId: lawyerId, boardNo : self.boardNo, userId:self.makerId});
			    },

			    startChat(lawyerId) {
			        // 채팅방으로 이동 (예: chat.do?lawyerId=XXX)
			        pageChange("/chat/chat.do", { lawyerId: lawyerId });
			    },
				deleteComment(cmtNo) {
				  const self = this;
				  if (!confirm("댓글을 삭제하시겠습니까?")) return;
					console.log(cmtNo);
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
				        self.fnGetBoard(); // 댓글 목록 새로고침
				      } else {
				        alert("댓글 삭제 실패");
				      }
				    }
				  });
				}

	    },
	    mounted() {
			let self = this;
			console.log(self.sessionType);
	        self.fnGetBoard();
	    }
	});
	app.mount("#app");
</script>

​