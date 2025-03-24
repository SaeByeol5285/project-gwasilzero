<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>상품 관리</title>
    <link rel="stylesheet" href="/css/admin-style.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            display: flex;
        }

        /* 왼쪽 사이드 메뉴 */
        .sidebar {
            width: 180px;
            background-color: #bcd3f8;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
        }

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 40px;
        }

        .menu-btn {
            width: 140px;
            padding: 12px;
            margin: 5px 0;
            border: 1px solid black;
            background-color: #eaeaea;
            text-align: center;
            font-weight: bold;
            cursor: pointer;
        }

        .menu-btn:last-child {
            margin-top: 40px;
        }

        .menu-btn.active {
            background-color: yellow;
        }

        .logout {
            margin-top: auto;
            margin-bottom: 20px;
            padding: 8px 16px;
            border: 1px solid black;
            background-color: white;
            cursor: pointer;
        }

        /* 우측 컨텐츠 */
        .content {
            flex: 1;
            padding: 40px;
            background-color: white;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 20px;
            border: 2px solid black;
            background-color: #dde8fc;
            font-weight: bold;
            font-size: 20px;
        }

        .table-area {
            background-color: #e4e4e4;
            padding: 40px;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }

        thead {
            background-color: #eeeeee;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }

        .row-blue {
            background-color: #e6f5ff;
        }

        .row-green {
            background-color: #e9fce9;
        }

        .row-yellow {
            background-color: #fffce1;
        }

        .btn-area {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            background-color: #f9f9a7;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- 사이드 메뉴 -->
        <div class="sidebar">
            <h2>로고</h2>
            <div class="menu-btn">대시보드</div>
            <div class="menu-btn">회원 관리</div>
            <div class="menu-btn">변호사 관리</div>
            <div class="menu-btn">게시글 관리</div>
            <div class="menu-btn">통계</div>
            <div class="menu-btn active">상품 관리</div>
            <button class="logout">logout</button>
        </div>

        <!-- 우측 콘텐츠 -->
        <div class="content">
            <div class="header">
                <span>상품관리</span>
                <span>Admin님</span>
            </div>

            <div class="table-area">
                <h3>판매 리스트</h3>
                <table>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>상품명</th>
                            <th>상품 설명</th>
                            <th>가격</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in list" :key="index"
                            :class="index === 0 ? 'row-yellow' : index === 1 ? 'row-green' : 'row-blue'">
                            <td><input type="checkbox" :value="item.packageNo"></td>
                            <td>{{ item.packageName }}</td>
                            <td>{{ item.packageInfo }}</td>
                            <td>{{ item.packagePrice.toLocaleString() }}원</td>
                        </tr>
                    </tbody>
                </table>

                <div class="btn-area">
                    <button class="btn">선택 삭제</button>
                    <button class="btn">신규등록</button>
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
				list : []
            };
        },
        methods: {
            fnGetList(){
				var self = this;
				var nparmap = {};
				$.ajax({
					url:"/project/list.dox",
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