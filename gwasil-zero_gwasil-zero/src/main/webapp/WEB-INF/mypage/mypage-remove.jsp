<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>회원탈퇴</title>
    </head>
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
            /* 높이 확장 */
            resize: none;
            /* 크기 조절 비활성화 */
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
                    password: "",
                    reason: "",
                    comments: "",
                    sessionId: "juwon1234"
                };
            },
            methods: {
                fnDeleteAccount() {
                    console.log("보내는 데이터: ", this.sessionId);  // 🔎 추가 확인용
                    var nparmap = {
                        sessionId: this.sessionId,  // 여기 확인
                        password: this.password,
                        reason: this.reason,
                        comments: this.comments
                    };

                    $.ajax({
                        url: "/mypage/removeUser.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log("응답 데이터: ", data);
                            if (data && data.result == "success") {
                                alert("회원 탈퇴가 완료되었습니다.");
                                location.href = "/mypage-home.do";
                            } else {
                                alert("오류 발생: " + (data?.message || "알 수 없는 오류"));
                            }
                        }
                    });
                },
                fnCancel: function () {
                    location.href = "/mypage-home.do";
                }
            },
            mounted() {
                console.log("회원탈퇴 페이지 로드 완료");
            }
        });
        app.mount('#app');
    </script>