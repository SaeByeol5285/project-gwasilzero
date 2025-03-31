<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>sample.jsp</title>
    </head>
    <style>
        
    </style>

    <body>
        <div id="app">
            <div>
                이름 : <input v-model="info.userName">
            </div>
            <div>
                핸드폰 번호 : <input v-model="info.userPhone">
            </div>
            <div>
                이메일 : <input v-model="info.userEmail">
            </div>
            <div>
                <button @click="fnSave">저장</button>
            </div>
        </div>
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "${map.userId}",
                    info: {},
                   
                };
            },
            methods: {
                fnGetInfo() {
                    var self = this;
                    var nparmap = {
                        sessionId: self.sessionId
                    };
                    $.ajax({
                        url: "/mypage/mypage-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.info = data.info
                        }
                    });
                },
                fnSave: function () {
                    var self = this;
                    var nparmap = {
                        userName : self.info.userName,
                        userPhone : self.info.userPhone,
                        userEmail : self.info.userEmail,
                        userId : self.info.userId

                    };
                    $.ajax({
                        url: "/mypage/mypage-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {                         
                            console.log(data);
                            location.href = "/mypage-home.do"
                            alert("수정되었습니다");
                        //     if(data.result == "success"){
                  // } else {
                  //    alert("오류발생");
                  // }

                        }
                    });
                }
            },
            mounted() {
                var self = this;
                self.fnGetInfo();
                console.log(self.userId);
            }
        });
        app.mount('#app');
    </script>
    ​