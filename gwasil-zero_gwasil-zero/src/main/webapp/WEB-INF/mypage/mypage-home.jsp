<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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

			#app .section {
				border-bottom: 2px solid #ddd;
				margin-bottom: 20px;
				padding-bottom: 15px;
			}

			#app .info-section {
				display: flex;
				justify-content: space-between;
				align-items: center;
			}

			#app .info-details {
				line-height: 2;
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
		</style>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">

			<h2>마이페이지</h2>

			<div class="section info-section">
				<div>
					<h3>내 정보</h3>
					<div class="info-details" v-if="info && info.userName">
						이름: {{ info.userName }}<br>
						핸드폰 번호: {{ info.userPhone }}<br>
						이메일: {{ info.userEmail }}
					</div>
				</div>
				<button @click="fnEdit"
					style="background-color: #FF5722; border: none; border-radius: 8px; padding: 5px 10px; color: #ffffff;">정보
					수정</button>
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
				<button @click="fnRemoveUser"
					style="background-color: #FF5722; border: none; border-radius: 8px; padding: 5px 10px; color: #ffffff;">
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
					userId: "",
					info: {},
					sessionId: ""
				};
			},
			methods: {
				fnGetList() {
					var self = this;
					var nparmap = {
						userId: self.sessionId,
						option: "SELECT"
					};
					console.log("보내는 데이터: ", nparmap);  // 🔎 값 확인용

					$.ajax({
						url: "/mypage/mypage-list.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log("응답 데이터: ", data);
							if (data.user && data.user.length > 0) {
								self.info = data.user[0];  // ✅ 응답 데이터 구조에 맞게 수정
							} else {
								alert("사용자 정보를 찾을 수 없습니다.");
							}
						}
					});
				},
				fnEdit: function () {
					location.href = "/join/edit.do";
				},
				fnRemoveUser: function () {
					location.href = "/mypage-remove.do";
				}
			},
			mounted() {
				this.sessionId = "juwon1234"
				this.fnGetList();
			}
		});
		app.mount('#app');
	</script>