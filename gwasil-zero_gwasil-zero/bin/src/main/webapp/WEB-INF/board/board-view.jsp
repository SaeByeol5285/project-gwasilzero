<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="/js/page-change.js"></script>
        <link rel="icon" type="image/png" href="/img/common/logo3.png">
        <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
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

            .view-title {
                font-size: 32px;
                font-weight: 800;
                margin-bottom: 18px;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .btn-report {
                padding: 8px 12px;
                font-size: 14px;
                background-color: #ffcccc;
                color: #c00;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                margin-left: 10px;
                white-space: nowrap;
                transition: all 0.2s ease;
            }

            .title-icon {
                font-size: 34px;
                color: #FF5722;
            }

            .view-meta {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                font-size: 15px;
                color: #666;
                margin-bottom: 20px;
            }

            .view-meta small {
                font-size: 14px;
                color: #888;
            }

            .view-content {
                font-size: 17px;
                line-height: 1.7;
                white-space: pre-line;
                margin-bottom: 30px;
            }

            .media-section {
                display: flex;
                flex-wrap: wrap;
                gap: 24px;
                margin-bottom: 30px;
            }

            .media-section img {
                width: 280px;
                height: auto;
                border-radius: 8px;
                border: 1px solid #ccc;
            }

            .media-section video {
                width: 100%;
                max-width: 520px;
                border-radius: 8px;
                border: 1px solid #ccc;
            }

            /* 댓글 영역 개선 */
            .comment-list {
                width: 1200px;
                max-width: 100%;
                margin: 60px auto;
                padding-top: 30px;
                border-top: 2px solid #eee;
                box-sizing: border-box;
            }

            .comment-list h4 {
                margin-bottom: 20px;
                font-size: 22px;
                font-weight: bold;
            }

            .comment-item {
                margin-bottom: 18px;
                padding: 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                background-color: #f9f9f9;
            }

            .comment-meta {
                font-size: 15px;
                color: #555;
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .comment-actions {
                display: flex;
                gap: 14px;
                font-size: 14px;
                color: #FF5722;
                cursor: pointer;
            }

            .comment-text {
                font-size: 16px;
                line-height: 1.6;
            }

            .comment-flex {
                display: flex;
                align-items: flex-start;
                gap: 16px;
            }

            .comment-profile {
                width: 52px;
                height: 52px;
                border-radius: 50%;
                object-fit: cover;
                border: 1px solid #ccc;
            }

            textarea {
                width: 100%;
                max-width: 100%;
                box-sizing: border-box;
                padding: 12px;
                font-size: 16px;
                border-radius: 6px;
                border: 1px solid #ccc;
                margin-bottom: 14px;
                resize: vertical;
            }

            .btn-orange,
            .btn-green,
            .btn-blue {
                padding: 8px 14px;
                font-size: 15px;
                border-radius: 6px;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .btn-orange {
                background-color: #FF5722;
                color: white;
            }

            .btn-orange:hover {
                background-color: #e64a19;
            }

            .btn-green {
                background-color: #28a745;
                color: white;
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

            .text-green {
                color: #28a745;
                font-weight: 500;
                cursor: pointer;
            }

            .text-green:hover {
                text-decoration: underline;
            }

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
            }

            .related-cards {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 30px;
            }

            .related-card {
                width: 220px;
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
                height: 140px;
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

            .review-section {
                width: 1200px;
                max-width: 100%;
                margin: 60px auto 0 auto;
                padding: 20px;
                border-top: 2px solid #ccc;
                font-family: 'Arial', sans-serif;
                box-sizing: border-box;
            }

            .review-textarea {
                width: 100%;
                padding: 12px;
                font-size: 16px;
                border-radius: 6px;
                border: 1px solid #ccc;
                resize: vertical;
                margin-bottom: 10px;
                box-sizing: border-box;
            }

            .review-display {
                background-color: #f4f8ff;
                padding: 18px;
                border: 1px solid #d0e3ff;
                border-radius: 6px;
                margin-top: 20px;
            }

            .review-content {
                font-size: 16px;
                line-height: 1.6;
                white-space: pre-wrap;
            }

            .review-meta {
                font-size: 13px;
                color: #666;
                margin-top: 12px;
                text-align: right;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .comment-actions img,
            .comment-meta img {
                width: 22px;
                height: 22px;
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
                <div class="view-title"><span class="title-icon">📣</span>{{ board.boardTitle }}
                    <div style="margin-left: auto; display: flex; gap: 8px; align-items: center;">
                        <div v-if="sessionType === 'lawyer'" @click="fnChatWithUser"
                            style="display: flex; align-items: center; gap: 6px; cursor: pointer; background-color: #e6f3ff; border-radius: 6px; padding: 4px 10px;"
                            title="문의자와 채팅하기">
                            <img src="/img/icon-chat.png" style="width: 20px; height: 20px;" />
                            <span style="font-size: 14px; color: #333;">채팅하기</span>
                        </div>
                        <button class="btn-report" @click="fnReport">🚨 신고하기</button>
                    </div>
                </div>

                <div class="view-meta">
               <div>
                   작성자: {{ board.userName }} |
                   담당 변호사: {{ board.lawyerName ? board.lawyerName : '미정' }} |
                   등록일: {{ board.cdate }}
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
            <!-- 버튼 묶음 -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
              
              <div>
                <button v-if="sessionId === board.userId" @click="EditBoard" class="btn btn-write">✏️ 수정하기</button>
                <button v-if="sessionId === board.userId" @click="deleteBoard" class="btn btn-red">🗑️ 삭제</button>
              </div>

              
              <div>
                <button class="btn btn-blue" @click="goToList">📋 목록 보기</button>
              </div>
            </div>

            </div>



            <!-- 관련된 게시글 영역 -->
            <div class="related-wrapper" v-if="relatedBoards.length > 0">
                <div class="related-title">연관된 게시글</div>
                <div class="related-cards">
                    <div class="related-card" v-for="item in relatedBoards" :key="item.boardNo"
                        @click="goToBoard(item.boardNo)">
                        <img 
                            :src="item.thumbnailPath ? item.thumbnailPath.replace('../', '/') : '/img/common/image_not_exist.jpg'" 
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
                    <div class="comment-flex">
                        <!-- 변호사 프로필 이미지 -->
                        <img class="comment-profile"
                            :src="cmt.lawyerImg ? cmt.lawyerImg.replace('../', '/') : '/img/common/image_not_exist.jpg'"
                            alt="변호사 이미지"
                            @error="e => { e.target.onerror = null; e.target.src='/img/common/image_not_exist.jpg' }" />
                        <!-- 댓글 본문 -->
                        <div style="flex: 1;">
                            <div class="comment-meta">
                                <span>{{ cmt.lawyerName }} | {{ cmt.cdate }}</span>
                                <div style="display: flex; align-items: center; gap: 6px; margin-left: auto;">
                                    <span class="comment-actions"
                                        v-if="sessionType === 'lawyer' && cmt.lawyerId === sessionId">
                                        <span class="text-green" @click="updateComment(cmt.cmtNo)">수정</span>
                                        <span style="font-weight: bold;" @click="deleteComment(cmt.cmtNo)">삭제</span>
                                    </span>

                                    <!-- 북마크 아이콘 -->
                                    <img v-if="sessionType === 'user'"
                                        :src="isBookmarked(cmt.lawyerId) ? '/img/selectedBookmark.png' : '/img/Bookmark.png'"
                                        @click="toggleBookmark(cmt.lawyerId)"
                                        style="width: 25px; height: 25px; margin-left: 8px; cursor: pointer;" />

                                    <!-- 계약 아이콘 -->
<<<<<<< HEAD
									<img v-if="sessionType === 'user'"
									     :src="board.lawyerId === cmt.lawyerId ? '/img/selectedContract.png' : '/img/contract.png'"
									     @click="startContract(cmt.lawyerId)"
									     :title="board.lawyerId === cmt.lawyerId ? '이미 계약된 변호사입니다' : '계약하기'"
									     style="width: 25px; height: 25px; margin-left: 8px; cursor: pointer;" />

=======
                                    <img v-if="sessionType === 'user'" src="/img/contract.png"
                                        @click="startContract(cmt.lawyerId)" title="계약하기"
                                        style="width: 25px; height: 25px; margin-left: 8px; cursor: pointer;" />
>>>>>>> branch 'feature/ppt' of https://github.com/SaeByeol5285/project-gwasilzero.git

                                    <!-- 채팅 아이콘 -->
                                    <img v-if="sessionType === 'user'" src="../../img/common/call.png"
                                        @click="startChat(cmt.lawyerId)" title="채팅하기"
                                        style="width: 25px; height: 25px; margin-left: 8px; cursor: pointer;" />
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
                </div>

                <div v-if="sessionType === 'lawyer' ">
                    <textarea v-model="newComment" placeholder="댓글을 입력하세요." rows="3"></textarea>
                    <button class="btn-blue" @click="checkLawyerAndSubmit">💬 댓글 등록</button>
                </div>
            </div>





            <!-- 리뷰 전체 영역 -->
            <div class="review-section" v-if="board && board.boardStatus === 'END'">
                <h4>변호사의 사건 리뷰</h4>

                <!-- 리뷰가 없고, 내가 담당 변호사일 때만 작성창 보여줌 -->
                <div v-if="!lawyerReview && sessionId === boardLawyer">
                    <textarea v-model="reviewContent" class="review-textarea"
                        placeholder="이번 사건에 대한 설명이나 처리 과정을 입력해주세요." rows="4"></textarea>
                    <button class="btn-green" @click="submitReview">리뷰 등록</button>
                </div>

                <!-- 리뷰가 이미 존재할 경우 -->
                <div v-if="lawyerReview" class="review-display">
                    <!-- 수정 중이면 textarea -->
                    <div v-if="isEditingReview && sessionId === boardLawyer">
                        <textarea v-model="reviewContent" class="review-textarea" placeholder="리뷰 내용을 수정해주세요."
                            rows="4"></textarea>
                        <button class="btn-green" @click="updateReview">리뷰 수정</button>
                        <button class="btn-orange" @click="cancelReviewEdit" style="margin-left: 5px;">취소</button>
                    </div>

                    <!-- 수정 중 아닐 때는 리뷰 보여주기 -->
                    <div v-else>
                        <p class="review-content">{{ lawyerReview }}</p>
                        <div class="review-meta"
                            style="display: flex; justify-content: space-between; align-items: center;">
                            <span>계약 금액: {{ contractPrice.toLocaleString() }}원</span>
                            <span v-if="sessionId === boardLawyer">
                                <span class="text-green" style="cursor: pointer;" @click="editReview">✏️ 수정</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/profile/recentViewBox.jsp" />
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
                    authResult: "",
                    boardTitle: "",
                    lawyerReview: "",
                    reviewContent: "",
                    boardLawyer: "",
                    contractPrice: 0,
                    isEditingReview: false,
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
                            self.board = data.board;
                            self.boardTitle = data.board.boardTitle;
                            self.makerId = data.board.userId;
                            self.comments = data.comment || [];
                            self.bookmarkList = data.bookmark;
                            self.lawyerReview = data.board.lawyerReview || "";
                            self.boardLawyer = data.board.lawyerId || "";
                            self.contractPrice = data.board.contractPrice;
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
                                    title: "회원권 필요",
                                    text: "변호사 회원권이 필요합니다.",
                                    confirmButtonColor: "#ff5c00"
                                }).then(() => {
                                    location.href = "/package/package.do";
                                });
                                return;
                            }

                            // 조건 통과
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
                            } else {
                                self.bookmarkList.push({ lawyerId: lawyerId });
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
                    // 작성자인지 확인
                    if (self.sessionId !== self.makerId) {
                        Swal.fire({
                            icon: "warning",
                            title: "계약 불가",
                            text: "게시글 작성자만 변호사와 계약할 수 있습니다.",
                            confirmButtonColor: "#ff5c00"
                        });
                        return;
                    }
               // 이미 계약되었는지 확인
               if (self.board.lawyerName) {
                      Swal.fire({
                          icon: "info",
                          title: "계약 불가",
                          text: "이미 담당 변호사가 배정된 사건입니다.",
                          confirmButtonColor: "#ff5c00"
                      });
                      return;
                  }
               
                    pageChange("/contract/newContract.do", { lawyerId: lawyerId, boardNo: self.boardNo, userId: self.makerId });
                },
            startChat(lawyerId) {
                let self = this;

                // 로그인 여부 확인
                if (!self.sessionId) {
                    Swal.fire({
                        icon: "error",
                        title: "로그인 필요",
                        text: "로그인 후 이용해주세요.",
                        confirmButtonColor: "#ff5c00"
                    }).then(() => {
                        location.href = "/user/login.do";
                    });
                    return;
                }

                // 패키지 구매 여부 확인
                $.ajax({
                    url: "/board/checkUserPacakge.dox",
                    type: "POST",
                    data: { userId: self.sessionId },
                    success: function (pkgRes) {
                        if (pkgRes.count == 0) {
                            Swal.fire({
                                icon: "error",
                                title: "패키지 없음",
                                text: "전화 상담 패키지를 구매 후 이용해주세요.",
                                confirmButtonColor: "#ff5c00"
                            }).then(() => {
                                location.href = "/package/package.do";
                            });
                            return;
                        }

                        // 변호사 상태 확인
                        $.ajax({
                            url: "/board/checkLawyerStatus.dox",
                            type: "POST",
                            data: { sessionId: lawyerId },
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
                                        title: "채팅 불가능",
                                        text: "변호사 등록기간이 만료된 변호사와는 채팅할 수 없습니다.",
                                        confirmButtonColor: "#ff5c00"
                                    });
                                    return;
                                }

                                //채팅
                                $.ajax({
                                    url: "/chat/findOrCreate.dox",
                                    type: "POST",
                                    data: {
                                        userId: self.sessionId,
                                        lawyerId: lawyerId
                                    },
                                    success: function (res) {
                                        let chatNo = res.chatNo;
                                        pageChange("/chat/chat.do", { chatNo: chatNo });
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
                    error: function () {
                        Swal.fire({
                            icon: "error",
                            title: "요청 실패",
                            text: "패키지 확인 중 오류가 발생했습니다.",
                            confirmButtonColor: "#ff5c00"
                        });
                    }
                });
            },
                deleteComment(cmtNo) {
                    const self = this;

                    Swal.fire({
                        title: "댓글을 삭제하시겠습니까?",
                        text: "삭제한 댓글은 복구할 수 없습니다.",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#d33",
                        cancelButtonColor: "#aaa",
                        confirmButtonText: "삭제",
                        cancelButtonText: "취소"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: "/board/commentDelete.dox",
                                type: "POST",
                                data: {
                                    cmtNo: Number(cmtNo),
                                    lawyerId: self.sessionId
                                },
                                success: function (res) {
                                    if (res.result === "success") {
                                        Swal.fire({
                                            icon: "success",
                                            title: "삭제 완료",
                                            text: "댓글이 삭제되었습니다.",
                                            confirmButtonText: "확인"
                                        });
                                        self.fnGetBoard();
                                    } else {
                                        Swal.fire({
                                            icon: "error",
                                            title: "삭제 실패",
                                            text: "댓글 삭제에 실패했습니다.",
                                            confirmButtonText: "확인"
                                        });
                                    }
                                }
                            });
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
                                Swal.fire({
                                    icon: "success",
                                    title: "수정 완료",
                                    text: "댓글이 수정되었습니다.",
                                    confirmButtonText: "확인"
                                });
                                self.editingCommentNo = null;
                                self.editedComment = "";
                                self.fnGetBoard();
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "수정 실패",
                                    text: "댓글 수정에 실패했습니다.",
                                    confirmButtonText: "확인"
                                });
                            }
                        }
                    });
                },
                cancelUpdate() {
                    this.editingCommentNo = null;
                    this.editedComment = "";
                },
                fnGetBoardWithKeyword() {
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
                        }
                    });
                },
                fnReport() {
                    const self = this;
                    // 1차 확인: 이미 신고했는지 확인
               
               if (self.sessionId == "" || self.sessionId == null) {
                        Swal.fire({
                            icon: "warning",
                            title: "로그인 필요",
                            text: "로그인 후 이용해주세요.",
                            confirmButtonColor: "#ff5c00"
                        });
                        return;
                    }
               
                    $.ajax({
                        url: "/board/reportCheck.dox",
                        type: "POST",
                        data: {
                            sessionId: self.sessionId,
                            boardNo: self.boardNo
                        },
                        dataType: "json",
                        success: function (res) {
                            if (res.count != 0) {
                                Swal.fire({
                                    icon: "warning",
                                    title: "이미 신고한 게시글입니다.",
                                    text: "중복 신고는 불가능합니다.",
                                    confirmButtonColor: "#ff5c00"
                                });
                                return;
                            }

                            // 신고 팝업 진행
                            Swal.fire({
                                title: "🚨 게시글 신고",
                                html: `
                                <textarea id="reportReason" 
                                    class="swal2-textarea" 
                                    placeholder="신고 사유를 입력하세요"
                                    style="width: 100%; max-width: 400px; height: 120px; box-sizing: border-box; margin-top: 10px;">
                                </textarea>
                                `,
                                icon: "warning",
                                showCancelButton: true,
                                confirmButtonText: "신고 제출",
                                cancelButtonText: "취소",
                                confirmButtonColor: "#d33",
                                preConfirm: () => {
                                    const reason = document.getElementById("reportReason").value.trim();
                                    if (!reason) {
                                        Swal.showValidationMessage("신고 사유를 입력해주세요.");
                                        return false;
                                    }
                                    return reason;
                                }
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    const reason = result.value;

                                    $.ajax({
                                        url: "/board/boardReport.dox",
                                        type: "POST",
                                        data: {
                                            sessionId: self.sessionId,
                                            boardNo: self.boardNo,
                                            reason: reason
                                        },
                                        success: function (res) {
                                            Swal.fire("신고 완료", "정상적으로 신고가 접수되었습니다.", "success");
                                        },
                                        error: function () {
                                            Swal.fire("오류", "신고 처리 중 오류가 발생했습니다.", "error");
                                        }
                                    });
                                }
                            });
                        }
                    });
                },
                submitReview() {
                    const self = this;

                    if (!self.reviewContent.trim()) {
                        Swal.fire("입력 필요", "리뷰 내용을 입력해주세요.", "warning");
                        return;
                    }

                    $.ajax({
                        url: "/board/addReview.dox",
                        type: "POST",
                        data: {
                            boardNo: self.boardNo,
                            lawyerReview: self.reviewContent
                        },
                        success: function (res) {
                            if (res.result === "success") {
                                Swal.fire("등록 완료", "리뷰가 등록되었습니다.", "success");
                                self.reviewContent = "";
                                self.fnGetBoard();  // 갱신
                            } else {
                                Swal.fire("오류", "리뷰 등록 중 문제가 발생했습니다.", "error");
                            }
                        },
                        error: function () {
                            Swal.fire("오류", "서버 요청 중 문제가 발생했습니다.", "error");
                        }
                    });
                },
                editReview() {
                    this.isEditingReview = true;
                    this.reviewContent = this.lawyerReview;
                },
                cancelReviewEdit() {
                    this.isEditingReview = false;
                    this.reviewContent = "";
                },
                updateReview() {
                    const self = this;

                    if (!self.reviewContent.trim()) {
                        Swal.fire("입력 필요", "리뷰 내용을 입력해주세요.", "warning");
                        return;
                    }

                    $.ajax({
                        url: "/board/updateReview.dox",
                        type: "POST",
                        data: {
                            boardNo: self.boardNo,
                            lawyerReview: self.reviewContent
                        },
                        success: function (res) {
                            if (res.result === "success") {
                                Swal.fire("수정 완료", "리뷰가 수정되었습니다.", "success");
                                self.isEditingReview = false;
                                self.reviewContent = "";
                                self.fnGetBoard(); // 다시 불러와서 갱신
                            } else {
                                Swal.fire("오류", "리뷰 수정 중 문제가 발생했습니다.", "error");
                            }
                        },
                        error: function () {
                            Swal.fire("오류", "서버 요청 중 문제가 발생했습니다.", "error");
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
            goToList() {
              pageChange("/board/list.do", {});
            }

            },
            mounted() {
                let self = this;
                self.fnGetBoard();
                self.fnGetBoardWithKeyword();
                self.fnIncreaseViewCount();

                setTimeout(function () {
                    if (!self.info || !self.boardTitle) return;

                    const boardNo = self.boardNo;
                    const boardTitle = self.boardTitle;

                    const item = {
                        type: 'board',
                        id: boardNo,
                        title: boardTitle
                    };


                    let list = JSON.parse(localStorage.getItem('recentViewed') || '[]');
                    list = list.filter(i => !(i.type === item.type && i.id === item.id));
                    list.unshift(item);
                    if (list.length > 5) list = list.slice(0, 5);
                    localStorage.setItem('recentViewed', JSON.stringify(list));
                }, 500);

            }
        });
        app.mount("#app");
    </script>