<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <title>결제창</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            text-align: center;
            padding-top: 60px;
            background-color: #f4f4f4;
        }
        .info {
            font-size: 18px;
            margin: 10px 0;
        }
        .pay-btn {
            margin-top: 30px;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        .pay-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div id="app">
        <h2>결제 정보를 확인해주세요.</h2>
        <div class="info">🧾 주문번호: <strong>{{ orderId }}</strong></div>
        <div class="info">📦 패키지명: <strong>{{ packageName }}</strong></div>
        <div class="info">💰 금액: <strong>{{ price.toLocaleString() }} 원</strong></div>

        <button class="pay-btn" @click="payNow">결제하기</button>
    </div>

    <script>
        const userCode = "imp38661450";
        IMP.init(userCode);

        const app = Vue.createApp({
            data() {
                return {
                    packageName: "",
                    price: 0,
                    orderId: ""
                };
            },
            methods: {
                payNow() {
                    const self = this;
                    IMP.request_pay({
                        pg: "kakaopay",
                        pay_method: "card",
                        merchant_uid: self.orderId,
                        name: self.packageName,
                        amount: self.price,
                        buyer_tel: "010-0000-0000"
                    }, function (rsp) {
                        if (rsp.success) {
                            alert("✅ 결제 완료!");
                            self.fnSave(rsp.merchant_uid);
                        } else {
                            alert("❌ 결제 실패!");
                        }
                    });
                },

                fnSave(merchant_uid) {
                    let self = this;
                    var nparmap = {
                        orderId : merchant_uid,           // 받은 merchant_uid 그대로 저장
                        packageName : self.packageName,
                        packagePrice : self.price
                        // userId : self.userId (로그인 정보 있으면 추가)
                    };

                    $.ajax({
                        url: "/payment.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function(data) {
                            console.log("결제 내역 저장 완료:", data);
                            window.close();
                            location.href = "/project/package.do";
                        },
                        error: function(err) {
                            console.error("결제 내역 저장 실패", err);
                        }
                    });
                }

            },
            mounted() {
                // JSP에서 전달된 map을 JS에서 불러오기
                const map = JSON.parse('<%= new com.google.gson.Gson().toJson(request.getAttribute("map")) %>');
                this.packageName = map.name;
                this.price = parseInt(map.price);
                this.orderId = map.orderId;
            }
        });

        app.mount('#app');
    </script>
</body>
</html>
