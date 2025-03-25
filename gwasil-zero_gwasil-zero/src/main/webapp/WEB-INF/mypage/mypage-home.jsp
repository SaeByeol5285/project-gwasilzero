<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>sample.jsp</title>
	<style>
		.my-page-container {
			padding: 20px;
			max-width: 900px;
			margin: 0 auto;
			font-family: Arial, sans-serif;
		}

		.section-title {
			font-weight: bold;
			margin-top: 20px;
			margin-bottom: 10px;
			border-bottom: 2px solid #ddd;
			padding-bottom: 5px;
		}

		.card-container {
			display: flex;
			gap: 10px;
			flex-wrap: wrap;
		}

		.card {
			flex: 1;
			min-width: 150px;
			background-color: #f2f2f2;
			padding: 15px;
			border-radius: 8px;
			text-align: center;
		}

		.table {
			width: 100%;
			border-collapse: collapse;
			margin-top: 10px;
		}

		.table th, .table td {
			border: 1px solid #ddd;
			padding: 8px;
			text-align: center;
		}
	</style>
</head>
<body>
	<div id="app" class="my-page-container">
		<div class="section-title">내 정보</div>
		<div v-if="userInfo">
			<p>{{ userInfo.name }}</p>
			<p>{{ userInfo.phone }}</p>
			<p>{{ userInfo.email }}</p>
		</div>

		<div class="section-title">내가 쓴 글</div>
		<div class="card-container">
			<div class="card" v-for="post in posts" :key="post.id">
				<p>{{ post.title }}</p>
				<p>{{ post.date }}</p>
			</div>
		</div>

		<div class="section-title">결제 내역</div>
		<table class="table">
			<thead>
				<tr>
					<th>날짜</th>
					<th>상품</th>
					<th>결제 방법</th>
					<th>결제 금액</th>
					<th>유효성</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="payment in payments" :key="payment.id">
					<td>{{ payment.date }}</td>
					<td>{{ payment.product }}</td>
					<td>{{ payment.method }}</td>
					<td>{{ payment.amount }}</td>
					<td>{{ payment.validity }}</td>
				</tr>
			</tbody>
		</table>
        <button @click="fnEdit">정보수정</button>
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                userInfo: {},
                posts: [],
                payments: []
            };
        },
        methods: {
            fnGetList() {
                var self = this;
                $.ajax({
                    url: "/project/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function(data) {
                        if (data.result === "success") {
                            self.userInfo = data.userInfo;
                            self.posts = data.posts;
                            self.payments = data.payments;
                        } else {
                            alert("오류 발생");
                        }
                    }
                });
            },
            fnEdit : function(){
                location.href="/join/edit.do"
            }
        },
        mounted() {
            this.fnGetList();
        }
    });
    app.mount('#app');
</script>
