<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>회원탈퇴</title>
        <style>
            #app {
                max-width: 500px;
                margin: 50px auto;
                padding: 20px;
                border: 2px solid #ddd;
                border-radius: 8px;
                box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
          
            input,
            select {
                width: 100%;
                padding: 8px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
                height: 36px;
            }

            textarea {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
                height: 80px;
                resize: none;
            }

            button {
                width: 100%;
                padding: 10px;
                background-color: #FF5722;
                color: #fff;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .cancel-btn {
                background-color: #888;
                margin-top: 10px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h2>회원탈퇴</h2>
            <div>
                <label for="password">비밀번호 확인</label>
                <input type="password" id="password" v-model="password" placeholder="비밀번호를 입력하세요">

                <label for="reason">탈퇴 사유 (선택)</label>
                <select id="reason" v-model="reason">
                    <option value="">선택 안 함</option>
                    <option value="서비스 불만족">서비스 불만족</option>
                    <option value="사용 빈도 낮음">사용 빈도 낮음</option>
                    <option value="기타">기타</option>
                </select>

                <label for="comments">기타 의견 (선택)</label>
                <textarea id="comments" v-model="comments" rows="3"></textarea>

                <button @click="fnDeleteAccount">탈퇴하기</button>
                <button class="cancel-btn" @click="fnCancel">취소</button>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    password: "",
                    reason: "",
                    comments: ""
                };
            },
            methods: {
                fnDeleteAccount() {
                    const self = this;
                    if (!self.password.trim()) {
                        alert("비밀번호를 입력해주세요");
                        return;
                    }
                    const params = {
                        userId: self.sessionId,
                        password: self.password,
                        reason: self.reason,
                        comments: self.comments
                    };
                    $.ajax({
                        url: "/mypage/mypage-remove.dox",
                        type: "POST",
                        data: params,
                        dataType: "json",
                        success: function (data) {
                            if (data.result === "success") {
                                // 로그아웃 요청 보내기
                                $.ajax({
                                    url: "/user/logout.dox",
                                    type: "POST",
                                    dataType: "json",
                                    success: function (logoutRes) {
                                        if (logoutRes.result === "success") {
                                            alert("탈퇴되었습니다.");
                                            location.href = "/common/main.do";
                                        } else {
                                            alert("세션 정리에 실패했습니다.");
                                        }
                                    },
                                    error: function () {
                                        alert("로그아웃 중 오류 발생");
                                    }
                                });
                            } else {
                                alert("탈퇴 실패: " + data.message);
                            }
                        },
                        error: function () {
                            alert("서버 오류 발생");
                        }
                    });
                },
                fnCancel() {
                    alert("취소되었습니다");
                    location.href = "/mypage-home.do";
                }
            }
        });
        app.mount('#app');
    </script>