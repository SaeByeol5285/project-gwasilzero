<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과실 ZERO - 교통사고 전문 법률 플랫폼</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <style>
        .contract-wrapper {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .contract-title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-row {
            margin-bottom: 16px;
        }
        .form-row label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
        }
        .form-row input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .notice {
            font-size: 14px;
            background: #f9f9f9;
            padding: 15px;
            border-left: 5px solid #ff5c00;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .pay-btn {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            background-color: #ff5c00;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<div id="app" class="contract-wrapper">
    <div class="contract-title">변호사 선임 계약서</div>

    <div class="form-row">
        <label>변호사 이름</label>
        {{ lawyer.lawyerName }}
    </div>

    <div class="form-row">
        <label>계약 금액 (원)</label>
        <input type="number" v-model="price" placeholder="금액을 입력하세요" />
    </div>

    <div class="form-row">
        <label>환불 계좌</label>
        <input type="text" v-model="account" placeholder="예: 국민은행 123456-78-901234" />
    </div>

    <div class="notice">
        📌 주의사항<br>
        - 계약 체결 후 환불은 일정 조건에서만 가능합니다.<br>
        - 계약 내용 및 상담 이력은 저장되며, 법적 효력을 가집니다.<br>
        - 계약 전 변호사와 충분한 상담을 진행해 주세요.
    </div>

    <button class="pay-btn" @click="fnPay">결제 및 계약 체결</button>
</div>
<jsp:include page="../common/footer.jsp" />
</body>

<script>
    const userCode = "imp38661450";
    IMP.init(userCode);

    const app = Vue.createApp({
        data() {
            return {
                boardNo: "${map.boardNo}",
                userId: "${map.userId}",
                lawyerId: "${map.lawyerId}",
                lawyerName: "",
                price: 0,
                account: "",
				lawyer : {}
            };
        },
        methods: {
			
            fnPay() {
                if (!this.price || !this.account) {
                    alert("모든 정보를 입력해주세요.");
                    return;
                }

                const self = this;
                IMP.request_pay({
                    pg: "kakaopay",
                    pay_method: "card",
                    name: "법률 계약 - " + self.lawyerName,
                    amount: self.price,
                    buyer_tel: "010-0000-0000"
                }, function (rsp) {
                    if (rsp.success) {
                        alert("✅ 결제 완료!");
                        self.fnSave();
                    } else {
                        alert("❌ 결제 실패!");
                    }
                });
            },

            fnSave() {
                let self = this;
                const nparmap = {
                    userId: self.userId,
                    lawyerId: self.lawyerId,
                    boardNo: self.boardNo,
                    price: self.price,
                    account: self.account
                };

                $.ajax({
                    url: "/contract/addContract.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function(data) {
                        alert("계약이 체결되었습니다.");
						
                        location.href = "/board/list.do";
                    },
                    error: function(err) {
                        alert("계약 저장 실패!");
                        console.error(err);
                    }
                });
            },
            fnGetLawyerInfo() {
                let self = this;
                const nparmap = {
                    lawyerId: self.lawyerId,
                };

                $.ajax({
                    url: "/contract/getLawyerInfo.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function(data) {
						console.log(data);
                        self.lawyer = data.lawyer;
                    },
                    error: function(err) {
                        alert("계약 저장 실패!");
                        console.error(err);
                    }
                });
            }
        },

        mounted() {
            this.fnGetLawyerInfo();
        }
    });

    app.mount('#app');
</script>
</html>
