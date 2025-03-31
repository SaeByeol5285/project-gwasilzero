<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- alert/confirm 창 수정용 -->
	<title>admin product</title>
	<style>
		table {
			width: 100%;
			border-collapse: collapse;
			background: white;
			box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
		}
		th, td {
			padding: 12px;
			border: 1px solid #ccc;
			text-align: center;
		}
		thead {
			background-color: #f5f5f5;
			font-weight: bold;
		}
		.btn-area {
			text-align: center;
			margin-top: 20px;
		}
		.btn {
			padding: 10px 20px;
			margin: 0 10px;
			background-color: #FF5722;
            color: white;
			border: 1px solid #ccc;
			cursor: pointer;
			font-weight: bold;
			border-radius: 6px;
		}
		.btn:hover {
			background-color: #e55300;
		}

        a {
            text-decoration: none;
            color: #FF5722;
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
                    <div>Admin님</div>
                </div>
                <h2>상품 관리</h2>

                <div class="box">
                    <h3>판매 리스트</h3>
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
                                <td>{{ item.packageInfo }}</td>
                                <td>{{ item.packagePrice.toLocaleString() }}원</td>
                                <td>{{ item.packageStatus === 'U' ? '일반' : '변호사' }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 버튼 영역 -->
                    <div class="btn-area">
                        <button class="btn" @click="fnDelete">선택 삭제</button>
                        <button class="btn" @click="fnAdd">신규 등록</button>
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
				list : [],
                selectList : []
            };
        },
        methods: {
            fnGetList(){
				let self = this;
				$.ajax({
					url:"/admin/product.dox",
					dataType:"json",	
					type : "POST", 
					data : {},
					success : function(data) { 
						console.log(data);
						if(data.result == "success"){
							self.list = data.list;
						} else {
							alert("리스트를 불러오지 못했어요.");
						}
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
        }
    });
    mainApp.mount('#mainApp');
</script>
