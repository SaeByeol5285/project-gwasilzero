<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/common.css">
	<title>과실 zero - 관리자 페이지</title>
    <style>
        .content-container a {
            color: #ff6b00;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }
        
        .content-container a:hover {
            color: #d64d00;
            text-decoration: underline;
        }

    </style>        
</head>
<body>
<div id="mainApp">
    <div class="layout">
        <jsp:include page="../admin/layout.jsp" />

        <div class="content">
            <div class="header">
                <div>관리자페이지</div>
                <div>{{sessionId}}님</div>
            </div>
            <h2>상품 관리</h2>

            <div class="content-container">
                <h3>판매 목록</h3>
                <table>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>상품명</th>
                            <th>상품 설명</th>
                            <th>가격</th>
                            <th>사용자</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in list" :key="index">
                            <td><input type="checkbox" :value="item.packageName" v-model="selectList"/></td>
                            <td><a href="javascript:;" @click="fnEdit(item.packageName)">{{ item.packageName }}</a></td>
                            <td >{{ item.packageInfo }}</td>
                            <td>{{ item.packagePrice.toLocaleString() }}원</td>
                            <td>{{ item.packageStatus === 'U' ? '일반' : '변호사' }}</td>
                        </tr>
                    </tbody>
                </table>
                <div class="pagination-container">
                    <button class="btn" @click="prevPage" :disabled="page === 1" style="font-family: 'Noto Sans KR', sans-serif !important;">〈 이전</button>
                    <button v-for="n in pageCount" :key="n" @click="goToPage(n)" :class="['btn', page === n ? 'active' : '']">{{ n }}</button>
                    <button class="btn" @click="nextPage" :disabled="page === pageCount" style="font-family: 'Noto Sans KR', sans-serif !important;">다음 〉</button>
                </div>
                <div class="btn-area">
                    <button class="btn" @click="fnDelete" style="margin-right: 5px; font-family: 'Noto Sans KR', sans-serif !important;">선택 삭제</button>
                    <button class="btn" @click="fnAdd" style="font-family: 'Noto Sans KR', sans-serif !important;">신규 등록</button>
                </div>
            </div>

            <div class="content-container">
                <h3>환불 요청 목록</h3>
                <table>
                    <thead>
                        <tr>
                            <th>회원 유형</th>
                            <th>이름</th>
                            <th>패키지명</th>
                            <th>결제 금액</th>
                            <th>결제일자</th>
                            <th>상태</th>
                            <th>처리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="refundList.length > 0" v-for="(item, index) in refundList" :key="index">
                            <td>{{ item.userType === 'L' ? '변호사' : '일반 사용자' }}</td>
                            <td>{{ item.name }}</td>
                            <td>{{ item.packageName }}</td>
                            <td>{{ item.price.toLocaleString() }}원</td>
                            <td>{{ item.payTime }}</td>
                            <td>{{ getRefundStatusText(item.payStatus) }}</td>
                            <td>
                                <div v-if="item.payStatus === 'REQUEST'">
                                    <button class="btn" @click="fnCompleteRefund(item.orderId)" style="margin-right: 5px; font-family: 'Noto Sans KR', sans-serif !important;">환불 완료 처리</button>
                                    <button class="btn btn-cancel" @click="fnCancelRefund(item.orderId)" style="font-family: 'Noto Sans KR', sans-serif !important;">환불 취소</button>
                                </div>
                                <span v-else>완료됨</span>
                            </td>                                
                        </tr>
                        <tr v-else>
                            <td colspan="7" style="text-align: center; color: #999;">환불 요청된 내역이 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
                <div class="pagination-container">
                    <button class="btn" @click="prevRefundPage" :disabled="refundPage === 1" style="font-family: 'Noto Sans KR', sans-serif !important;">〈 이전</button>
                    <button v-for="n in refundPageCount" :key="n" @click="goToRefundPage(n)" :class="['btn', refundPage === n ? 'active' : '']">{{ n }}</button>
                    <button class="btn" @click="nextRefundPage" :disabled="refundPage === refundPageCount" style="font-family: 'Noto Sans KR', sans-serif !important;">다음 〉</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

<script>
    const mainApp = Vue.createApp({
        data() {
            return {
                sessionId : "${sessionId}",
				list : [],
                selectList : [],
                refundList : [],
                page: 1,
                pageSize: 5,
                pageCount: 0,
                refundPage: 1,
                refundPageSize: 5,
                refundPageCount: 0
            };
        },
        methods: {
            fnGetList(){
				let self = this;
				$.ajax({
					url:"/admin/product.dox",
					dataType:"json",	
					type : "POST", 
					data : {
                        page: (self.page - 1) * self.pageSize,
                        pageSize: self.pageSize
                    },
					success : function(data) { 
						console.log(data);
						if(data.result == "success"){
							self.list = data.list;
                            self.pageCount = Math.ceil(data.productCount / self.pageSize);
                            if (self.list.length === 0 && self.page > 1) {
                                self.page--;
                                self.fnGetList();
                            }
						} else {
							alert("리스트를 불러오지 못했어요.");
						}
					}
				});
            },
            goToPage(n) {
                this.page = n;
                this.fnGetList();
            },
            prevPage() {
                if (this.page > 1) {
                    this.page--;
                    this.fnGetList();
                }
            },
            nextPage() {
                if (this.page < this.pageCount) {
                    this.page++;
                    this.fnGetList();
                }
            },

            fnGetRefundList() {
                let self = this;
                $.ajax({
                    url: "/admin/product/refund.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        refundPage: (self.refundPage - 1) * self.refundPageSize,
                        refundPageSize: self.refundPageSize
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.refundList = data.refundList;
                            self.refundPageCount = Math.ceil(data.refundCount / self.refundPageSize);
                            if (self.refundList.length === 0 && self.refundPage > 1) {
                                self.refundPage--;
                                self.fnGetRefundList();
                            }
                        }
                    }
                });
            },

            goToRefundPage(n) {
                this.refundPage = n;
                this.fnGetRefundList();
            },
            prevRefundPage() {
                if (this.refundPage > 1) {
                    this.refundPage--;
                    this.fnGetRefundList();
                }
            },
            nextRefundPage() {
                if (this.refundPage < this.refundPageCount) {
                    this.refundPage++;
                    this.fnGetRefundList();
                }
            },
            
            getRefundStatusText(status) {
                switch (status) {
                    case "REQUEST": return "환불 요청";
                    case "REFUNDED": return "환불 완료";
                    default: return status;
                }
            },

            fnCompleteRefund(orderId) {
                let self = this;
                const item = self.refundList.find(i => i.orderId === orderId); // 해당 항목 찾기

                Swal.fire({
                    title: "환불 완료 처리하시겠습니까?",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "처리",
                    cancelButtonText: "취소"
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "/admin/product/refund-complete.dox",
                            type: "POST",
                            data: { orderId: orderId },
                            success: function (data) {
                                if (data.result === "success") {
                                    const receiverId = item.userId || item.lawyerId;
                                    if (!receiverId) {
                                        console.error("⚠️ receiverId가 없습니다. 알림을 보낼 수 없습니다.");
                                        return;
                                    }
                                    // ✅ 알림 insert 요청 추가
                                    $.ajax({
                                        url: "/admin/product/notification.dox",
                                        type: "POST",
                                        data: {
                                            receiverId: receiverId,
                                            senderId: "admin",
                                            notiType: "REFUND",
                                            contents: `[ ` + item.packageName + ` ] 환불이 완료되었습니다.`,
                                            isRead: "N"
                                        },
                                        success: function () {
                                            Swal.fire({
                                                icon: "success",
                                                title: "환불 완료",
                                                text: "환불이 완료되었습니다. 사용자에게 알림이 전달되었습니다.",
                                                confirmButtonText: "확인"
                                            });
                                            self.fnGetRefundList(); // 리스트 새로고침
                                        }
                                    });
                                }
                            }
                        });
                    }
                });
            },

            fnCancelRefund(orderId) {
                let self = this;
                const item = self.refundList.find(i => i.orderId === orderId); // 🔍 해당 항목 찾기

                Swal.fire({
                    title: "환불 요청을 취소하시겠습니까?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "예",
                    cancelButtonText: "아니오"
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "/admin/product/refund-cancel.dox",
                            type: "POST",
                            data: { orderId: orderId },
                            success: function (data) {
                                if (data.result === "success") {
                                    // ✅ 알림 보내기
                                    const receiverId = item.userId || item.lawyerId;
                                    if (!receiverId) {
                                        console.error("⚠️ receiverId가 없습니다. 알림을 보낼 수 없습니다.");
                                        return;
                                    }

                                    $.ajax({
                                        url: "/admin/product/notification.dox",
                                        type: "POST",
                                        data: {
                                            receiverId: receiverId,
                                            senderId: "admin",
                                            notiType: "CANCEL_REFUND",
                                            contents: `[ ` + item.packageName + ` ] 환불 요청이 취소되었습니다.`,
                                            isRead: "N"
                                        },
                                        success: function () {
                                            Swal.fire("처리 완료", "환불 요청이 취소되었고 사용자에게 알림이 전달되었습니다.", "success");
                                            self.fnGetRefundList(); // 리스트 새로고침
                                        }
                                    });
                                }
                            }
                        });
                    }
                });
            },

            fnDelete() {
                var self = this;

                // 선택 항목 없을 때 안내
                if (self.selectList.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: '상품 선택 필요',
                        text: '삭제할 상품을 선택해주세요.',
                        confirmButtonText: '확인'
                    });
                    return;
                }

                // 삭제 확인
                Swal.fire({
                    title: '정말로 삭제하시겠습니까?',
                    text: '선택한 상품은 삭제 후 복구할 수 없습니다.',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#aaa',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // 삭제 요청
                        var nparmap = {
                            selectList: JSON.stringify(self.selectList)
                        };

                        $.ajax({
                            url: "/admin/product/remove.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result === "success") {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '삭제 완료',
                                        text: '상품이 성공적으로 삭제되었습니다.',
                                        confirmButtonText: '확인'
                                    });
                                    self.fnGetList();
                                }
                            }
                        });
                    }
                });
            },

            fnAdd() {
                location.href = "/admin/product/add.do";
            },

            fnEdit : function(packageName){
                pageChange("/admin/product/edit.do", {packageName : packageName});
            },
        },
        mounted() {
			this.fnGetList();
            this.fnGetRefundList();
        }
    });
    mainApp.mount('#mainApp');
</script>
