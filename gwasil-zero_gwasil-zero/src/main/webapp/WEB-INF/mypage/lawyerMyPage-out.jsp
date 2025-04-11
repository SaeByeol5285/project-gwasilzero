<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                <input type="password" id="password" v-model="pwd" placeholder="비밀번호를 입력하세요">

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
                    pwd: "",
                    reason: "",
                    comments: ""
                };
            },
            methods: {
                fnDeleteAccount() {
                    const self = this;
                    if (!self.pwd.trim()) {
                        Swal.fire({
                            icon: "warning",
                            title: "입력 필요",
                            text: "비밀번호를 입력해주세요.",
                            confirmButtonColor: "#ff5c00"
                        });
                        return;
                    }
                    const params = {
                        sessionId: self.sessionId,
                        pwd: self.pwd,
                        reason: self.reason,
                        comments: self.comments
                    };
                    $.ajax({
                        url: "/lawyerMyPage/out.dox",
                        type: "POST",
                        data: params,
                        dataType: "json",
                        success: function (data) {
                            if (data.result === "success") {
                                // 로그아웃 요청
                                $.ajax({
                                    url: "/user/logout.dox",
                                    type: "POST",
                                    dataType: "json",
                                    success: function (logoutRes) {
                                        if (logoutRes.result === "success") {
                                            Swal.fire({
                                                icon: "success",
                                                title: "탈퇴 완료",
                                                text: "탈퇴가 정상적으로 처리되었습니다.",
                                                confirmButtonColor: "#ff5c00"
                                            }).then(() => {
                                                location.href = "/common/main.do";
                                            });
                                        } else {
                                            Swal.fire({
                                                icon: "error",
                                                title: "실패",
                                                text: "세션 정리에 실패했습니다.",
                                                confirmButtonColor: "#ff5c00"
                                            });
                                        }
                                    },
                                    error: function () {
                                        Swal.fire({
                                            icon: "error",
                                            title: "오류",
                                            text: "로그아웃 중 오류가 발생했습니다.",
                                            confirmButtonColor: "#ff5c00"
                                        });
                                    }
                                });
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "탈퇴 실패",
                                    text: data.message || "탈퇴 요청에 실패했습니다.",
                                    confirmButtonColor: "#ff5c00"
                                });
                            }
                        },
                        error: function () {
                            Swal.fire({
                                icon: "error",
                                title: "서버 오류",
                                text: "서버 통신 중 문제가 발생했습니다.",
                                confirmButtonColor: "#ff5c00"
                            });
                        }
                    });
                },

                fnCancel() {
                    location.href = "/mypage/lawyerMyPage.do";
                }
            }
        });
        app.mount('#app');
    </script>