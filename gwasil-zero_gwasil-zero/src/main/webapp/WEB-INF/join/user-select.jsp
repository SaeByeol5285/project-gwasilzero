<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>sample.jsp</title>
    </head>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            height: 100vh;
            justify-content: center;
            align-items: center;
            background-color: #f5f5f5;
        }

        #app {
            text-align: center;
        }

        h1 {
            margin-bottom: 30px;
        }

        .card-container {
            display: flex;
            gap: 20px;
        }

        .card {
            width: 200px;
            padding: 20px;
            border: 2px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            cursor: pointer;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            border-color: #4a90e2;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .selected {
            border-color: #4a90e2;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .card-title {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .card-desc {
            color: #555;
            font-size: 14px;
        }
    </style>

    <body>
        <div id="app">
            <h1>회원가입</h1>
            <div class="card-container">
                <div class="card" @click="fnMoveToJoin('normal')" :class="{selected: selected === 'normal'}">
                    <div class="card-title">사용자</div>
                    <div class="card-desc">
                        교통사고 해결을 위한 변호사를 찾고,<br>법률 지원을 받아보세요!
                    </div>
                </div>

                <div class="card" @click="fnMoveToJoin('lawyer')" :class="{selected: selected === 'lawyer'}">
                    <div class="card-title">변호사</div>
                    <div class="card-desc">
                        교통사고 피해자를 돕고,<br>법률 서비스를 제공하세요!
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
                    selected: ''

                };
            },
            methods: {
                fnGetList() {
                    var self = this;
                    var nparmap = {};
                    $.ajax({
                        url: "/join/user-select.dox",
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
                },
                fnMoveToJoin(status) {
                    this.selected = status;  // 선택된 카드 강조
                    location.href = `/member/add.do?status=${status}`;
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