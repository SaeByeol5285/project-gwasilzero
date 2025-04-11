<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script src="/js/page-change.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<title>package.jsp</title>
	<style>
		.package-section-title::before {
			content: "📦 ";
			font-size: 20px;
		}
		.package-section-title {
			font-size: 22px;
			font-weight: bold;
			color: #FF5722;
			text-align: center;
			margin: 40px auto 20px auto;
		}

		.package-container,
		.lawyer-package-container {
			display: flex;
			gap: 20px;
			justify-content: center;
			flex-wrap: wrap;
			margin-bottom: 50px;
		}
	
		.package-box {
			width: 330px;
			background-color: white;
			border-radius: 10px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
			padding: 24px;
			text-align: center;
			transition: transform 0.2s ease, box-shadow 0.2s ease;
			border: 1px solid #eee;
		}
	
		.package-box:hover {
			transform: translateY(-5px);
			box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
		}
	
		.package-title {
			font-size: 20px;
			font-weight: bold;
			margin-bottom: 12px;
			color: #222;
		}
	
		.package-info {
			font-size: 16px;
			margin-bottom: 16px;
			color: #666;
			min-height: 48px;
		}
	
		.package-price {
			font-size: 18px;
			font-weight: bold;
			color: var(--main-color);
		}
	
		.buy-btn {
			margin-top: 20px;
			padding: 10px 16px;
			border-radius: 8px;
			background-color: var(--main-color);
			color: white;
			font-size: 14px;
			font-weight: 500;
			cursor: pointer;
			text-decoration: none;
			display: inline-block;
			transition: background-color 0.2s ease;
			border: none;
		}
	
		.buy-btn:hover {
			background-color: #e55300; /* 조금 짙은 주황 */
		}
	
		.section-subtitle {
			font-size: 28px;
			font-weight: bold;
			margin-bottom: 30px;
			text-align: center;
			color: #222;
			position: relative;
			display: inline-block;
			padding-top: 40px;
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
			background-color: var(--main-color);
			border-radius: 2px;
		}
	</style>
</head>
<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app">
		<h2 class="section-subtitle">패키지 구매</h2>

		<!-- 사용자용 패키지 (위쪽 가로 배치) -->
		<div class="package-section-title">일반 사용자용 <span style="color: #333;">패키지</span></div>
		<div class="package-container">
			<template v-for="item in list" :key="item.packageName">
				<div class="package-box" v-if="item.packageStatus === 'U'">
					<div class="package-title">{{ item.packageName }}</div>
					<div class="package-info">
						<div v-for="(line, idx) in item.packageInfo.split('\n')" :key="idx">
						  {{ line }}
						</div>
					  </div>
					<div class="package-price">₩{{ item.packagePrice.toLocaleString() }}</div>

					<a v-if="!isPurchased(item) && canBuy(item)" href="javascript:;" @click="fnBuy(item)" class="buy-btn">
					구매하기
					</a>
					<span v-else-if="isPurchased(item)" class="buy-btn" style="background-color: #ccc; cursor: default;">
					구매 완료
					</span>
					<span v-else class="buy-btn" style="background-color: #eee; cursor: not-allowed;" title="해당 사용자는 구매할 수 없습니다.">
					구매 불가
					</span>

				</div>
			</template>
		</div>

		<!-- 변호사용 패키지 (아래쪽 따로) -->
		<div class="package-section-title">변호사용 <span style="color: #333;">패키지</span></div>
		<div class="lawyer-package-container">
			<template v-for="item in list" :key="item.packageName">
				<div class="package-box" v-if="item.packageStatus === 'L'">
					<div class="package-title">{{ item.packageName }}</div>
					<div class="package-info">
						<div v-for="(line, idx) in item.packageInfo.split('\n')" :key="idx">
						  {{ line }}
						</div>
					  </div>
					<div class="package-price">₩{{ item.packagePrice.toLocaleString() }}</div>

					<a v-if="!isPurchased(item) && canBuy(item)" href="javascript:;" @click="fnBuy(item)" class="buy-btn">
						구매하기
					</a>
					<span v-else-if="isPurchased(item)" class="buy-btn" style="background-color: #ccc; cursor: default;">
					구매 완료
					</span>
					<span v-else class="buy-btn" style="background-color: #eee; cursor: not-allowed;" title="해당 사용자는 구매할 수 없습니다.">
					구매 불가
					</span>

				</div>
			</template>
		</div>
	</div>
	<jsp:include page="../common/footer.jsp" />
</body>
<script>
	const app = Vue.createApp({
		data() {
			return {
				list: [],
				sessionId: "${sessionId}",
				purchasedList: [],
				role: "${role}",
			};
		},
		methods: {
			fnGetList() {
				let self = this;
				$.ajax({
					url: "/package/package.dox",
					dataType: "json",
					type: "POST",
					data: {},
					success: function (data) {
						if (data.result == "success") {
							self.list = data.list;

						} else {
							alert("오류 발생");
						}
					}
				});
			},
			// 구매 여부 판단
			isPurchased(item) {
				if (!this.sessionId || this.sessionId === "") return false;

				const found = this.purchasedList.find(p => p.packageName === item.packageName);
				return found && found.payStatus === "PAID";
			},

			// 구매 가능한지 판단
			canBuy(item) {
				if (!this.sessionId || this.sessionId === "") return true;

				// 권한 체크
				if (item.packageStatus === 'U' && this.role === 'lawyer') return false;
				if (item.packageStatus === 'L' && this.role === 'user') return false;

				const found = this.purchasedList.find(p => p.packageName === item.packageName);

				// 구매 완료 상태일 경우만 구매 불가
				if (found && found.payStatus === "PAID") return false;

				// 환불 완료, 취소 등은 다시 구매 가능
				return true;
			},

			fnBuy(item) {
				if (!this.sessionId || this.sessionId === "") {
					Swal.fire({
						title: "구매 불가!",
						text: "로그인 후 이용하실 수 있습니다.",
						icon: "warning",
						showCancelButton: true,
						confirmButtonColor: "#ff5c00", // 주황색
						cancelButtonColor: "#aaa",
						confirmButtonText: "로그인하러 가기",
						cancelButtonText: "취소"
					}).then((result) => {
						if (result.isConfirmed) {
							location.href = "/user/login.do";
						}
					});
					return;
				}

				var popupW = 700;
				var popupH = 700;
				var left = Math.ceil((window.screen.width - popupW)/2);
				var top = Math.ceil((window.screen.height - popupH)/2);


				const popup = window.open(
					"/package/packagePay.do?name=" + encodeURIComponent(item.packageName)
					+ "&price=" + item.packagePrice
					+ "&orderId=" + new Date().getTime(),
					"결제창",
					`width=` + popupW + `,height=` + popupH + `,left=` + left + `,top=` + top
				);

				let timer = setInterval(() => {
					if (popup.closed) {
						clearInterval(timer);
						this.fnGetPurchased();  // 🆕 구매완료 목록 갱신
					}
				}, 1000);
			},

			fnGetPurchased() {
				let self = this;
				$.ajax({
					url: "/package/purchased.dox",  // 📝 userId로 구매 내역 조회
					data: {sessionId: self.sessionId},
					type: "POST",
					dataType: "json",
					success: function(res) {
						if (res.result === "success") {
							self.purchasedList = res.purchasedList.map(item => item.packageName);
						}
					}
				});
			},

		},
		mounted() {
			this.fnGetList();
			this.fnGetPurchased();
		}
	});
	app.mount('#app');
</script>
</html>