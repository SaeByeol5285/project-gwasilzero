<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>admin main</title>
    </head>

    <body>
        <div id="lawyerApp">
            <div class="layout">
                <jsp:include page="layout.jsp" />
                <div class="content">
                    <div class="header">
                        <div>관리자페이지</div>
                        <div>Admin님</div>
                    </div>
                    <div>
                        <h3>변호사 승인 대기 목록</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>승인여부</th>
                            </tr>
                            <tr v-for="lawWait in lawWaitList">
                                <td>{{lawWait.lawyerName}}</td>
                                <td>{{lawWait.lawyerId}}</td>
                                <td>{{lawWait.lawyerPass}}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </body>

    </html>
    <script>
        const lawyerApp = Vue.createApp({
            data() {
                return {

                };
            },
            methods: {

            },
            mounted() {
                var self = this;

            }
        });
        lawyerApp.mount('#lawyerApp');
    </script>