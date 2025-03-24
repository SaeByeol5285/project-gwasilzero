<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>상품 관리</title>
    <link rel="stylesheet" href="/css/admin-product-style.css">
</head>
<body>
    <div id="app">
        <div class="sidebar">
            <button @click="fnPageMove('main')" :class="{ active: currentPage === 'main' }">
                관리자 메인</button>
            <button @click="fnPageMove('user')" :class="{ active: currentPage === 'user' }">
                회원 관리</button>
            <button @click="fnPageMove('lawyer')" :class="{ active: currentPage === 'lawyer' }">
                변호사 관리</button>
            <button @click="fnPageMove('board')" :class="{ active: currentPage === 'board' }">
                게시글 관리</button>
            <button @click="fnPageMove('chart')" :class="{ active: currentPage === 'chart' }">
                통계</button>
            <button @click="fnPageMove('product')" :class="{ active: currentPage === 'product' }">
                상품 관리</button>
            <button @click="fnLogout">Logout</button>
        </div>
        <div class="content">
            <div class="header">상품 관리 <span style="float:right">Admin님</span></div>
            
            <div class="box">
                <h3>판매 리스트</h3>
                <table style="width:100%; border-collapse: collapse; background: white;">
                    <thead>
                        <tr style="background: #f0f0f0;">
                            <th style="padding: 10px; border: 1px solid #ccc;">선택</th>
                            <th style="padding: 10px; border: 1px solid #ccc;">상품명</th>
                            <th style="padding: 10px; border: 1px solid #ccc;">상품 설명</th>
                            <th style="padding: 10px; border: 1px solid #ccc;">가격</th>
                            <th style="padding: 10px; border: 1px solid #ccc;">사용자</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in list" :key="index">
                            <td style="padding: 10px; border: 1px solid #ccc;">
                                <input type="checkbox" :value="item.packageNo">
                            </td>
                            <td style="padding: 10px; border: 1px solid #ccc;">{{ item.packageName }}</td>
                            <td style="padding: 10px; border: 1px solid #ccc;">{{ item.packageInfo }}</td>
                            <td style="padding: 10px; border: 1px solid #ccc;">{{ item.packagePrice.toLocaleString() }}원</td>
                            <td v-if="item.packageStatus == 'U'" style="padding: 10px; border: 1px solid #ccc;">일반</td>
                            <td v-if="item.packageStatus == 'L'" style="padding: 10px; border: 1px solid #ccc;">변호사</td>
                        </tr>
                    </tbody>
                </table>
        
                <div style="margin-top: 20px; text-align: center;">
                    <button style="padding: 10px 20px; background: #fdfd96; border: none; margin-right: 20px;">선택 삭제</button>
                    <button style="padding: 10px 20px; background: #fdfd96; border: none;">신규등록</button>
                </div>
            </div>
        </div>
        
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                currentPage: 'product', // ← 여기가 중요!
				list : []
            };
        },
        methods: {
            fnGetList(){
				var self = this;
				var nparmap = {};
				$.ajax({
					url:"/project/admin/product.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
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
            var self = this;
			self.fnGetList();
        }
    });
    app.mount('#app');
</script>
​