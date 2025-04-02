<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" 
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
    <title>내 정보 수정</title>
    <style>
        #user-info-edit {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 12px;
            background-color: #F8F9FC;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        #user-info-edit h1 {
            text-align: center;
            color: #666;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E3E7EE;
        }

        #user-info-edit label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
        }

        #user-info-edit input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #CCC;
            border-radius: 6px;
            background-color: #FFF;
            box-sizing: border-box;
        }

        #user-info-edit button {
            width: 100%;
            background-color: #FF5722;
            color: #FFF;
            border: none;
            border-radius: 6px;
            padding: 10px 0;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #user-info-edit button:hover {
            background-color: #FF5722;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div id="app">
        <div id="user-info-edit">
            <h1>내 정보 수정</h1>
            <div>
                <label>이름</label>
                <input v-model="user.userName">
            </div>
            <div>
                <label>핸드폰 번호</label>
                <input v-model="user.userPhone">
            </div>
            <div>
                <label>이메일</label>
                <input v-model="user.userEmail">
            </div>
            <div>
                <button @click="fnUpdate">수정 완료</button>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                user: {
                    userName: "",
                    userPhone: "",
                    userEmail: ""
                }
            };
        },
        methods: {
            fnUpdate() {
                const nparmap = {
                    userId: this.user.userId,
                    userName: this.user.userName,
                    userPhone: this.user.userPhone,
                    userEmail: this.user.userEmail
                };

                $.ajax({
                    url: "/join/user-edit.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        alert("수정 완료.");
                        location.href = "/mypage-home.do";
                    },
                    error: function () {
                        alert("수정 오류");
                    }
                });
            }
        },
        mounted() {
            this.user.userId = '<%= session.getAttribute("userId") %>'
            this.fnGetList();
        }
    });
    app.mount('#app');
</script>