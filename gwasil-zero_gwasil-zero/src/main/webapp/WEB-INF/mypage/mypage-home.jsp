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
			<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
			<script src="/js/page-change.js"></script>
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

				.card-grid {
					display: grid;
					grid-template-columns: repeat(3, 1fr);
					gap: 24px;
					margin-top: 20px;
				}

				.thumbnail {
					width: 100%;
					height: 180px;
					object-fit: cover;
					border-radius: 8px;
					margin-bottom: 10px;
				}

				.box {
					background-color: white;
					border-radius: 10px;
					box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
					padding: 16px;
					text-align: center;
					border: 1px solid #eee;
					transition: all 0.2s ease;
					cursor: default;
				}

				.box:hover {
					transform: translateY(-4px);
					box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
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

				.payment-table thead {
					background-color: #f2f2f2;
				}

				.payment-table th {
					font-weight: bold;
					color: #333;
					font-size: 15px;
					padding: 12px;
				}

				.payment-table td {
					font-size: 14px;
					padding: 10px 12px;
					background-color: #fff;
				}

				.payment-table tr:nth-child(even) td {
					background-color: #f9f9f9;
				}

				.payment-table {
					border-radius: 8px;
					overflow: hidden;
					box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
				}

				.section-subtitle {
					font-size: 28px;
					font-weight: bold;
					margin-bottom: 30px;
					text-align: center;
					color: #222;
					position: relative;
					display: inline-block;
					padding-bottom: 10px;

					display: block;
					text-align: center;
					margin-left: auto;
					margin-right: auto;
				}

				.section-subtitle::after {
					content: "";
					position: absolute;
					left: 50%;
					transform: translateX(-50%);
					bottom: 0;
					width: 60px;
					height: 3px;
					background-color: #FF5722;
					/* 주황색 */
					border-radius: 2px;
				}

				.message {
					text-decoration: none;
					color: #333;
				}

				.message:hover {
					color: #e64a19;
				}

				.pagination-container {
					display: flex;
					justify-content: center;
					align-items: center;
					margin-top: 30px;
					margin-bottom: 20px;
					gap: 6px;
				}

				.btn {
					padding: 10px 18px;
					font-size: 15px;
					border: none;
					border-radius: 8px;
					background-color: #f2f2f2;
					color: #444;
					font-weight: 500;
					cursor: pointer;
					transition: all 0.2s ease;
				}

				.btn:hover {
					background-color: #ffe6db;
					color: #ff5c00;
				}

				.btn.active {
					background-color: #ff5c00;
					color: white;
					font-weight: bold;
					box-shadow: 0 2px 4px rgba(0,0,0,0.1);
				}

				.btn:disabled {
					opacity: 0.4;
					cursor: default;
				}
			</style>
		</head>

		<body>
			<jsp:include page="../common/header.jsp" />
			<div id="app">
				<h2 class="section-subtitle">마이페이지</h2>

				<!-- 내 정보 -->
				<div class="section">
					<div class="info-section">
						<div>
							<h3>내 정보</h3>
							<div class="info-details" v-if="info && info.userName">
								이름: {{ info.userName }}<br>
								핸드폰 번호: {{ formatPhone(info.userPhone) }}<br>
								이메일: {{ info.userEmail }}
							</div>
						</div>
						<button @click="fnEdit">정보 수정</button>
					</div>
				</div>

				<div class="section">
					<h3>내가 쓴 글</h3>
					<!-- 내가 쓴 글 -->
					<div class="card-grid" v-if="boardList.length > 0">
						<div class="box" v-for="item in boardList" :key="item.boardNo"
							@click="fnBoardView(item.boardNo)">
							<img v-if="item.thumbnailPath" :src="item.thumbnailPath.replace('../', '/')" alt="썸네일"
								class="thumbnail" @error="e => e.target.src='/img/common/image_not_exist.jpg'" />
							<img v-else src="/img/common/image_not_exist.jpg" alt="기본 썸네일" class="thumbnail" />
							<h3>{{ item.boardTitle }}</h3>
							<p>사건 진행 상태: {{ item.boardStatus === 'DOING' ? '진행중' : item.boardStatus === 'END' ? '완료' :
								'미정' }}</p>
							<p>담당 변호사: {{ item.lawyerName || '미정' }}</p>
						</div>
					</div>
					<div v-else style="text-align: center; color: #888; margin-top: 30px;">
						내용이 없습니다.
					</div>
					<!-- 페이징 영역 -->
					<div class="pagination-container">
						<button class="btn" @click="fnPageMove('prev')" :disabled="page === 1">〈 이전</button>
					
						<button 
						v-for="n in index" 
						:key="n" 
						@click="fnPage(n)" 
						:class="['btn', page === n ? 'active' : '']"
						>
						{{ n }}
						</button>
					
						<button class="btn" @click="fnPageMove('next')" :disabled="page === index">다음 〉</button>
					</div>
				</div>

				<!-- 리뷰 -->
				<div class="section">
					<h3>리뷰</h3>
					<!-- 리뷰 작성 섹션 -->
					<div v-if="availReviewList.length > 0" class="section review-section">
						<h3>📝 리뷰 작성 가능한 항목</h3>
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
							<textarea v-model="item.contents" placeholder="리뷰 내용을 입력해주세요"
								class="review-textarea"></textarea>
							<button class="btn btn-primary review-submit-btn" @click="fnWriteReview(item)">리뷰
								등록</button>
						</div>
					</div>
					<div v-else class="section review-section">
						<h3>📝 리뷰 작성 가능한 항목</h3>
						<div>
							작성 가능한 리뷰가 없습니다.
						</div>
					</div>

					<div v-if="writtenReviewList.length > 0" class="section review-section">
						<h3>📝 내가 작성한 리뷰</h3>
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
									<button class="btn btn-primary review-submit-btn"
										@click="fnEditReview(item)">저장</button>
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
					</div>
					<div v-else class="section review-section">
						<h3>📝 내가 작성한 리뷰</h3>
						<div> 작성한 리뷰가 없습니다.</div>

					</div>
				</div>

				<!-- 채팅 내역 -->
				<div class="section chat-section">
					<h3>채팅 내역</h3>
					<table class="payment-table">
						<colgroup>
							<col style="width: 75%;"> <!-- 메시지 열 넓게 -->
							<col style="width: 25%;"> <!-- 상대방 열 좁게 -->
						</colgroup>
						<thead>
							<tr>
								<th>메시지</th>
								<th>변호사</th>
							</tr>
						</thead>
						<tbody>
							<tr v-if="chatList.length" v-for="chat in chatList" :key="chat.chatNo">
								<td><a href="javascript:;" @click="fnChat(chat.chatNo)" class="message">{{ chat.message
										}}</a></td>
								<td><a href="javascript:;" @click="fnProfile(chat.partnerId)" class="message">{{ chat.partnerName }}</a></td>
							</tr>
							<tr v-else>
								<td colspan="2" style="text-align: center; color: #999;">채팅 내역이 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- 결제 내역 -->
				<div class="section">
					<h3>패키지 결제 내역</h3>
					<table class="payment-table">
						<thead>
							<tr>
								<th>날짜</th>
								<th>제품명</th>
								<th>가격</th>
								<th>상태</th>
								<th>요청</th>
							</tr>
						</thead>
						<tbody>
							<tr v-if="payList && payList.length" v-for="pay in payList" :key="pay.orderId">
								<td>{{ pay.payTime }}</td>
								<td>{{ pay.packageName }}</td>
								<td>{{ pay.price.toLocaleString() }}원</td>
								<td>{{ getPayStatusText(pay.payStatus) }}</td>
								<td>
									<button v-if="pay.payStatus === 'PAID'" @click="fnRequestRefund(pay.orderId)"
										class="edit-btn">환불 요청</button>
									<button v-else-if="pay.payStatus === 'REQUEST'" @click="fnCancelRefund(pay.orderId)"
										class="withdraw-btn">환불 요청 취소</button>
									<span v-else>-</span>
								</td>
							</tr>
							<tr v-else>
								<td colspan="5" style="text-align: center; color: #999;">결제 내역이 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- 변호사 선임 결제 내역 -->
				<div class="section">
					<h3>변호사 선임 결제 내역</h3>
					<table class="payment-table">
					<thead>
						<tr>
						<th>날짜</th>
						<th>변호사</th>
						<th>금액</th>
						<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<tr v-if="contractList.length" v-for="item in contractList" :key="item.contractNo">
						<td>{{ item.cdate }}</td>
						<td>{{ item.lawyerName }}</td>
						<td>{{ item.contractPrice.toLocaleString() }} 원</td>
						<td>{{ getContractStatusText(item.contractStatus) }}</td>
						</tr>
						<tr v-else>
						<td colspan="4" style="text-align: center; color: #999;">결제 내역이 없습니다.</td>
						</tr>
					</tbody>
					</table>
				</div>
  
				<!-- 회원탈퇴 -->
				<div style="text-align: center; margin-top: 20px;">
					<button class="withdraw-btn" @click="fnRemoveUser">회원탈퇴</button>
				</div>

			</div>
			<jsp:include page="../common/footer.jsp" />
		</body>

		</html>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						sessionId: "${sessionId}",
						info: {},
						boardList: [],
						chatList: [],
						payList: [],
						availReviewList: [], // 작성할 수 있는 리뷰 리스트
						writtenReviewList: [],   // 이미 작성한 리뷰 리스트
						isEditing: false,  //true일 때만 수정 모드'
						page: 1,
						pageSize: 3,  // 글 3개씩
						index: 0,
						contractList : [],
					};
				},
				methods: {
					formatPhone(phone) {
						if (!phone || phone.length !== 11) return phone;
						return phone.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
					},
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
							userId: self.sessionId,
							page: (self.page - 1) * self.pageSize,
							pageSize: self.pageSize
						};
						$.ajax({
							url: "/mypage/my-board-list.dox",
							type: "POST",
							data: nparmap,
							dataType: "json",
							success: function (data) {
								console.log("✅ 글 : ", data);
								self.boardList = data.boardList;
								self.index = Math.ceil(data.boardCnt / self.pageSize);
							}
						});
					},

					fnGetNotification() {
						const self = this;
						$.ajax({
							url: "/mypage/notification.dox",
							type: "POST",
							data: { receiverId: self.sessionId },
							dataType: "json",
							success: function (data) {
								if (data.result === "success" && data.notifications.length > 0) {
									console.log("알림", data);
									const message = data.notifications[0].contents;
									Swal.fire({
										title: '📢 알림',
										text: message,
										icon: 'info',
										confirmButtonText: '확인'
									}).then(() => {
										$.ajax({
											url: "/mypage/notificationRead.dox",
											type: "POST",
											data: { receiverId: self.sessionId }
										});
									});
								}
							}
						});
					},

					fnPage(num) {
						this.page = num;
						this.fnGetBoardList();
					},

					fnPageMove(dir) {
						if (dir === "next" && this.page < this.index) {
							this.page++;
						} else if (dir === "prev" && this.page > 1) {
							this.page--;
						}
						this.fnGetBoardList();
					},

					fnBoardView(boardNo) {
						pageChange("/board/view.do", { boardNo: boardNo });
					},

					fnProfile(lawyerId) {
						pageChange("/profile/view.do", {lawyerId : lawyerId});
					},

					fnGetChatList() {
						var self = this;
						var nparmap = {
							sessionId: self.sessionId
						};
						$.ajax({
							url: "/mypage/my-chat-list.dox",
							type: "POST",
							data: nparmap,
							dataType: "json",
							success: function (data) {
								console.log("✅ 채팅 응답: ", data);
								self.chatList = data.chatList || [];
							}
						});
					},
					
					fnGetPayList() {
						var self = this;
						var nparmap = {
							sessionId: self.sessionId
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

					fnRequestRefund(orderId) {
						const self = this;
						if (!confirm("해당 결제 건에 대해 환불을 요청하시겠습니까?")) return;

						$.ajax({
							url: "/mypage/Refund.dox",
							type: "POST",
							data: { orderId: orderId },
							success: function () {
								alert("환불 요청이 접수되었습니다.");
								const pay = self.payList.find(p => p.orderId === orderId);
								if (pay) pay.payStatus = "REQUEST";
							}
						});
					},

					fnCancelRefund(orderId) {
						const self = this;
						if (!confirm("환불 요청을 취소하시겠습니까?")) return;

						$.ajax({
							url: "/mypage/RefundCancel.dox",
							type: "POST",
							data: { orderId: orderId },
							success: function () {
								alert("환불 요청이 취소되었습니다.");
								const pay = self.payList.find(p => p.orderId === orderId);
								if (pay) pay.payStatus = "PAID";
							}
						});
					},

					getPayStatusText(status) {
						switch (status) {
							case "PAID": return "결제 완료";
							case "REQUEST": return "환불 요청";
							case "REFUNDED": return "환불 완료";
							case "USED" : return "사용 완료";
							default: return status;
						}
					},

					fnEdit() {
						location.href = "/mypage-edit.do";
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

					fnGetContractList() {
						const self = this;
						$.ajax({
						url: "/mypage/contractList.dox",
						type: "POST",
						data: { userId: self.sessionId },
						dataType: "json",
						success: function (data) {
							console.log("🔎 계약 내역:", data);
							self.contractList = data.contractList || [];
						}
						});
					},
					
					getContractStatusText(status) {
						switch (status) {
						case "COMPLETE": return "결제 완료";
						case "REQUEST": return "환불 요청";
						case "REFUNDED": return "환불 완료";
						default: return status;
						}
					},
				},
				mounted() {
					console.log("✅ 세션 ID:", this.sessionId); // 🔍 콘솔에서 확인
					this.fnGetUserInfo();
					this.fnGetBoardList();
					this.fnGetChatList();
					this.fnGetPayList();
					this.fnLoadReview();
					this.fnGetContractList();
					this.fnGetNotification();
				}
			});
			app.mount("#app");
		</script>