<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script src="/js/page-change.js"></script>
	<title>package.jsp</title>
	<style>
		body {
			font-family: 'Segoe UI', sans-serif;
			background-color: #f9f9f9;
			padding: 40px;
		}
		h2 {
			margin-bottom: 30px;
			color: #333;
		}
		.package-container {
			display: flex;
			gap: 20px;
			justify-content: center;
			flex-wrap: wrap;
			margin-bottom: 50px;
		}
		.lawyer-package-container {
			display: flex;
			justify-content: center;
			margin-top: 20px;
		}
		.package-section-title {
			font-size: 20px;
			font-weight: bold;
			color: #444;
			text-align: center;
			margin-bottom: 10px;
		}
		.package-box {
			width: 280px;
			background-color: #fff;
			border-radius: 20px;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
			padding: 24px;
			text-align: center;
			transition: transform 0.2s ease;
		}
		.package-box:hover {
			transform: translateY(-5px);
			box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
		}
		.package-title {
			font-size: 20px;
			font-weight: bold;
			margin-bottom: 12px;
			color: #333;
		}
		.package-info {
			font-size: 15px;
			margin-bottom: 16px;
			color: #555;
		}
		.package-price {
			font-size: 18px;
			font-weight: bold;
			color: #007bff;
		}
		.buy-btn {
			margin-top: 20px;
			display: inline-block;
			padding: 10px 16px;
			background-color: #007bff;
			color: white;
			border-radius: 10px;
			text-decoration: none;
			font-size: 14px;
		}
		.buy-btn:hover {
			background-color: #0056b3;
		}
	</style>
</head>
<body>
	<div id="app">
		<h2>패키지 구매</h2>

		<!-- 사용자용 패키지 (위쪽 가로 배치) -->
		<div class="package-section-title">일반 사용자용 패키지</div>
		<div class="package-container">
			<template v-for="item in list" :key="item.packageName">
				<div class="package-box" v-if="item.packageStatus === 'U'">
					<div class="package-title">{{ item.packageName }}</div>
					<div class="package-info">{{ item.packageInfo }}</div>
					<div class="package-price">₩{{ item.packagePrice.toLocaleString() }}</div>
					<a href="javascript:;" @click="fnBuy" class="buy-btn">구매하기</a>
				</div>
			</template>
		</div>

		<!-- 변호사용 패키지 (아래쪽 따로) -->
		<div class="package-section-title">변호사용 패키지</div>
		<div class="lawyer-package-container">
			<template v-for="item in list" :key="item.packageName">
				<div class="package-box" v-if="item.packageStatus === 'L'">
					<div class="package-title">{{ item.packageName }}</div>
					<div class="package-info">{{ item.packageInfo }}</div>
					<div class="package-price">₩{{ item.packagePrice.toLocaleString() }}</div>
					<a href="javascript:;"  @click="fnBuy" class="buy-btn">구매하기</a>
				</div>
			</template>
		</div>
	</div>
</body>
<script>
	const userCode = "imp38661450"; // 식별코드
	IMP.init(userCode);
	const app = Vue.createApp({
		data() {
			return {
				list: [],
				// userId : ${session.Id}
			};
		},
		methods: {
			fnGetList() {
				let self = this;
				$.ajax({
					url: "/project/package.dox",
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

			fnBuy() {
                let self = this;
                IMP.request_pay({
				    pg: "kakaopay", // PG Provider
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(), // 주문 아이디(ORDER_ID)
				    name: self.list[0].packageName,
				    amount: self.list[0].packagePrice,
				    buyer_tel: "010-0000-0000",
				  }	, function (rsp) { // callback
			   	      if (rsp.success) {
						alert("결제되었습니다!");
                        self.fnSave(rsp.merchant_uid);
			   	      } else {
			   	        // 결제 실패 시
						alert("실패");
			   	      }
		   	  	});
            },
            
            fnSave(merchant_uid) {
                let self = this;
                var nparmap = {
					orderId : self.merchant_uid,
					packageName : self.name,
					// userId : self.userId
                    packagePrice : self.amount,
                 };
                $.ajax({
                    url:"/payment.dox",
                    dataType:"json",	
                    type : "POST", 
                    data : nparmap,
                    success : function(data) { 
                        console.log(data);
                    }
                });
            }
		},
		mounted() {
			this.fnGetList();
		}
	});
	app.mount('#app');
</script>
</html>