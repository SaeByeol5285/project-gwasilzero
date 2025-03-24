<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
			background-color: #fdfd96;
			border: 1px solid #ccc;
			cursor: pointer;
			font-weight: bold;
			border-radius: 6px;
		}
		.btn:hover {
			background-color: #fbe85d;
		}
	</style>
</head>
<body>
    <div id="mainApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />
    
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
                                <td><input type="checkbox" :value="item.packageNo" /></td>
                                <td>{{ item.packageName }}</td>
                                <td>{{ item.packageInfo }}</td>
                                <td>{{ item.packagePrice.toLocaleString() }}원</td>
                                <td>{{ item.packageStatus === 'U' ? '일반' : '변호사' }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 버튼 영역 -->
                    <div class="btn-area">
                        <button class="btn">선택 삭제</button>
                        <button class="btn">신규 등록</button>
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
				list : []
            };
        },
        methods: {
            fnGetList(){
				let self = this;
				$.ajax({
					url:"/product/product.dox",
					dataType:"json",	
					type : "POST", 
					data : {},
					success : function(data) { 
						console.log(data);
						if(data.result == "success"){
							self.list = data.list;
						} else {
							alert("오류발생");
						}
					}
				});
            }
        },
        mounted() {
			this.fnGetList();
        }
    });
    mainApp.mount('#mainApp');
</script>
