<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <title>sample.jsp</title>
    </head>
    <style>
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 70vh;
        }

        .result-box {
            background-color: #fff;
            border: 2px solid #FF5722;
            border-radius: 12px;
            padding: 30px;
            width: 100%;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #FF5722;
        }

        .btn {
            display: inline-block;
            background-color: #FF5722;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 15px;
        }

        .btn:hover {
            background-color: #E64A19;
        }
    </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <div class="container">
                <div class="result-box">
                    <h2>아이디 찾기 결과</h2>
                    <p><strong>${userName}</strong>님의 아이디는 <strong>${userId}</strong>입니다.</p>
                    <a href="/user/login.do" class="btn">로그인하기</a>
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
                    userName: self.userName,
                    userId: self.userId
                };
            },
            methods: {
                fnGetList() {
                    var self = this;
                    var nparmap = {};
                    $.ajax({
                        url: "/project/list.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
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