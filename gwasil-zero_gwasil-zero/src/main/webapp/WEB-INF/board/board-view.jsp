<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                background-color: #fff;
                font-family: 'Arial', sans-serif;
            }

            .view-title {
                font-size: 30px;
                font-weight: 800;
                margin-bottom: 16px;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
            }

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

            .comment-list {
                width: 70%;
                margin: 40px auto;
                padding-top: 20px;
                border-top: 1px solid #eee;
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
        </style>


    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <div class="view-container" v-if="board?.boardNo">
                <div class="view-title"><span class="title-icon">📣</span>{{ board.boardTitle }}</div>

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

            <div>

                <div class="comment-list">
                    <h4>댓글</h4>


                    <div v-if="comments.length > 0">
                        <div class="comment-item" v-for="(cmt, index) in comments" :key="index">
                            <div class="comment-meta">
                                {{ cmt.lawyerName }} | {{ cmt.cdate }}
                                <div class="comment-actions"
                                    v-if="sessionType === 'lawyer' && cmt.lawyerId === sessionId">
                                    <span class="text-green" @click="updateComment(cmt.cmtNo)">수정</span>
                                    <span @click="deleteComment(cmt.cmtNo)">삭제</span>
                                </div>
                            </div>
                            <div class="comment-text">
                                <div v-if="editingCommentNo === cmt.cmtNo">
                                    <textarea v-model="editedComment" rows="3"></textarea>
                                    <div style="margin-top: 5px;">
                                        <button class="btn-green" @click="saveUpdatedComment(cmt.cmtNo)">저장</button>
                                        <button class="btn-orange" @click="cancelUpdate"
                                            style="margin-left: 5px;">취소</button>
                                    </div>
                                </div>
                                <div v-else>
                                    {{ cmt.contents }}
                                </div>
                            </div>
                        </div>
                    </div>


                    <div v-if="sessionType === 'lawyer'">
                        <textarea v-model="newComment" placeholder="댓글을 입력하세요" rows="3"></textarea>
                        <button class="btn-orange" @click="submitComment">등록</button>
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
                    editedComment: ""
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
                submitComment() {
                    const self = this;

                    // 승인 여부 먼저 체크
                    $.ajax({
                        url: "/board/checkLawyerStatus.dox",
                        type: "POST",
                        data: {
                            sessionId: self.sessionId
                        },
                        dataType: "json",
                        success: function (res) {
                            if (res.result === "true") {
                                // 승인된 경우에만 댓글 등록
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
                                        self.fnGetBoard();
                                    }
                                });
                            } else if (res.result === "false") {
                                alert("아직 승인되지 않은 변호사 계정입니다.");
                            } else {
                                alert("변호사 상태 확인 중 오류가 발생했습니다.");
                            }
                        },
                        error: function () {
                            alert("변호사 상태 확인 요청 실패");
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