<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<title>user-add.jsp</title>
	</head>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f8f9fa;
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100vh;
			margin: 0;
		}

		#app {
			background: white;
			padding: 40px;
			border-radius: 10px;
			box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
			width: 400px;
			text-align: center;
		}

		h2 {
			font-size: 20px;
			margin-bottom: 20px;
		}

		div {
			margin-bottom: 15px;
			text-align: left;
		}

		input {
			width: 100%;
			padding: 10px;
			margin-top: 5px;
			border: 1px solid #ccc;
			border-radius: 5px;
			font-size: 14px;
		}

		button {
			background-color: #a7c7f2;
			color: white;
			border: none;
			padding: 10px 15px;
			border-radius: 5px;
			cursor: pointer;
			font-size: 14px;
		}

		button:hover {
			background-color: #6b9df3;
		}

		button:disabled {
			background-color: #ccc;
			cursor: not-allowed;
		}

		.double-input {
			display: flex;
			gap: 10px;
		}

		.double-input input {
			flex: 1;
		}

		.double-input button {
			flex: 0.5;
			padding: 10px;
		}

		#signup-button {
			width: 100%;
			background-color: #b0c4de;
			padding: 12px;
			font-size: 16px;
			border-radius: 5px;
			margin-top: 10px;
		}

		.additional-buttons {
			display: flex;
			justify-content: space-between;
			margin-top: 15px;
		}

		.additional-buttons button {
			background-color: #e0e0e0;
			color: black;
			width: 32%;
			padding: 10px;
			font-size: 14px;
		}
	</style>

	<body>
		<div id="app">
			<div>
				이름 : <input v-model="user.userName" placeholder="이름 입력">
			</div>
			<div>
				아이디 : <input v-model="user.userId" placeholder="아이디 입력">
				<button @click="fnIdCheck">중복체크</button>
			</div>
			<div>
				비밀번호 : <input v-model="user.pwd" type="password" placeholder="비밀번호 입력">
			</div>
			<div>
				비밀번호 확인 : <input v-model="user.pwd2" type="password" placeholder="비밀번호 확인">
			</div>
			<div>
				핸드폰 번호 : <input v-model="user.phone" placeholder="번호 입력">
				<button @click="fnSmsAuth">인증요청</button>
			</div>
			<div>
				<input v-model="authInputNum" :placeholder="timer">
				<button @click="fnNumAuth">인증 확인</button>
			</div>
			<div>
				<button @click="fnJoin">회원가입</button>
			</div>
		</div>
	</body>

	</html>
	<script>
		function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
			window.vueObj.fnResult(roadFullAddr, roadAddrPart1, addrDetail, engAddr);
		}
		const app = Vue.createApp({
			data() {
				return {
					user: {
						userName: "",
						userId: "",
						pwd: "",
						pwd2: "",
						phoneNum: ""
					},
					authNum: "",
					authInputNum: "",
					authFlg: false,
					joinFlg: false,
					timer: "",
					count: 180


				};
			},
			methods: {
				fnJoin() {
					var self = this;
					// if (self.joinFlg == false) {
					// 	alert("문자 인증 먼저 해주세요")
					// 	return;
					// }
					var nparmap = self.user;
					$.ajax({
						url: "/user/user-add.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result == "success") {
								self.list = data.list;
								alert("회원가입 완료");
							} else {
								alert("오류발생");
							}
						}
					});
				},
				fnIdCheck: function () {
					var self = this;
					if (self.userId == "") {
						alert("아이디를 입력해주세요")
						return;
					}
					var nparmap = {
						userId: self.user.userId
					}
					$.ajax({
						url: "/user/check.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.count == 0) {
								alert("사용 가능");
							} else {
								alert("사용 불가능");
							}
						}
					});
				},
				fnSmsAuth: function () {
					var self = this;
					var nparmap = {
						phoneNum: self.user.phoneNum
					};
					$.ajax({
						url: "/send-one",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.response.statusCode == 2000) {
								alert("문자 발송 완료");
								self.authNum = data.ranStr;
								self.authFlg = true;
								setInterval(self.fnTimer, 1000);
							} else {
								alert("잠시 후 다시 시도 해주셈");
							}
						}
					});
				},
				fnNumAuth: function () {
					let self = this;
					if (self.authNum == self.authInputNum) {
						alert("인증되었습니다.");
					} else {
						alert("인증 번호 다시 확인해주세요");
					}
				},
				fnTimer: function () {
					let self = this;
					let min = "";
					let sec = "";
					min = parseInt(self.count / 60);
					sec = parseInt(self.count % 60);
					min = min < 10 ? "0" + min : min;
					sec = sec < 10 ? "0" + sec : sec;
					self.timer = min + ":" + sec;
					self.count--;
				}
			},
			mounted() {
				var self = this;
				window.vueObj = this;
			}
		});
		app.mount('#app');
	</script>
	​