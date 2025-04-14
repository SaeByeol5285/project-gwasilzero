<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
			      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
    <style>
        :root {
            --main-color: #ff5c00; /* 코랄 톤: 밝고 부드러운 주황 */
            --gray-bg: #f8f8f8;
            --text-dark: #333;
            --text-subtle: #666;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            text-align: center;
            padding-top: 60px;
            background-color: var(--gray-bg);
            color: var(--text-dark);
        }

        h2 {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 30px;
            color: var(--text-dark);
        }

        .info {
            font-size: 16px;
            margin: 10px 0;
            color: var(--text-subtle); /* 회색으로 눈 편하게 */
        }

        .info strong {
            color: var(--text-dark); /* 강조는 그냥 검정 계열로 */
        }

        .pay-btn {
            margin-top: 40px;
            padding: 12px 28px;
            font-size: 16px;
            font-weight: 500;
            border: none;
            border-radius: 8px;
            background-color: var(--main-color);
            color: white;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .pay-btn:hover {
            background-color: #e76a3c; /* hover용 조금 더 진한 코랄 */
        }

    
        /* 반응형 약간만 고려 */
        @media (max-width: 480px) {
            .pay-btn {
                width: 80%;
            }
        }
    </style>
    
</head>
<body>
    <div id="app">
        <h2>결제 정보를 확인해주세요.</h2>
        <div class="info">🧾 주문번호 : <strong>{{ orderId }}</strong></div>
        <div class="info">📦 패키지명 : <strong>{{ packageName }}</strong></div>
        <div class="info">💰 금액 : <strong>{{ price.toLocaleString() }} 원</strong></div>

        <button class="pay-btn" @click="fnPay">결제하기</button>
    </div>

    <script>
        const userCode = "imp38661450";
        IMP.init(userCode);

        const app = Vue.createApp({
            data() {
                return {
                    packageName: "",
                    price: 0,
                    orderId: "",
                    sessionId : "${sessionId}",
                    role : "${role}"
                };
            },
            methods: {
                fnPay() {
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
                            Swal.fire({
                                icon: "success",
                                title: "✅ 결제 완료!",
                                text: "정상적으로 결제되었습니다.",
                                confirmButtonColor: "#ff5c00"
                            }).then(() => {
                                self.fnSave(rsp.merchant_uid);
                            });
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "❌ 결제 실패!",
                                text: "결제가 정상적으로 처리되지 않았습니다.",
                                confirmButtonColor: "#ff5c00"
                            });
                        }
                    });
                },

                fnSave(merchant_uid) {
                    let self = this;
                    var nparmap = {
                        orderId : merchant_uid,           // 받은 merchant_uid 그대로 저장
                        packageName : self.packageName,
                        sessionId : self.sessionId ,
                        price : self.price,
                        role : self.role
                    };

                    $.ajax({
                        url: "/payment.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function(data) {

                            if (self.packageName === "월 회원권" && self.role === "lawyer") {
                                $.ajax({
                                    url: "/lawyer/updateAuthEndtime.dox",
                                    type: "POST",
                                    data: { lawyerId: self.sessionId },
                                    success: function(res) {
                                        if (res.result == "success") {
                                            Swal.fire({
                                                title: "월 회원 등록 완료!",
                                                text: `🗓️ ` + res.authEndtime + `까지 활동 가능합니다!`,
                                                icon: "success",
                                                confirmButtonText: "확인"
                                            }).then(() => {
                                                if (window.opener) {
                                                    window.opener.location.reload(); 
                                                }
                                                window.close();
                                            });
                                        }  
                                    },
                                    error: function(err) {
                                        alert("회원 기간 갱신에 실패했습니다.");
                                        window.close();
                                        location.href = "/package/package.do";
                                    }
                                });
                            } else {
                                if (window.opener) {
                                    window.opener.location.reload(); 
                                }
                                window.close();
                            }
                        },
                        error: function(err) {
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
