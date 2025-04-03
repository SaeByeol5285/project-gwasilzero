<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <title>사용자 회원가입</title>
        <style>
            #app {
                width: 100%;
                max-width: 400px;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                padding: 20px;
                text-align: center;
                margin: 20px auto;
            }

            #app input,
            #app select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }

            #app button {
                width: 100%;
                padding: 10px;
                margin-top: 10px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background-color: #FF5722;
                color: #fff;
            }

            #app button:hover {
                background-color: #FF7043;
            }

            .error-text {
                color: red;
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h1>사용자 회원가입</h1>
            <div>이름</div>
            <input v-model="user.userName" placeholder="이름 입력" />
            <div>아이디 (5글자 이상)</div>
            <input v-model="user.userId" placeholder="아이디 입력" />
            <button @click="fnIdCheck" style="margin-bottom: 10px;">중복체크</button>
            <div>비밀번호 (8자리 이상)</div>
            <input v-model="user.pwd" type="password" placeholder="비밀번호 입력" />
            <div v-if="user.pwd.length > 0 && user.pwd.length < 8" class="error-text">비밀번호는 8자 이상이어야 합니다.</div>
            <div>비밀번호 확인</div>
            <input v-model="user.pwd2" type="password" placeholder="비밀번호 확인" />
            <div v-if="user.pwd !== user.pwd2 && user.pwd2" class="error-text">비밀번호 불일치</div>
            <div>이메일</div>
            <input v-model="user.userEmail" placeholder="이메일 입력" />
            <div>휴대폰 (11자리)</div>
            <input v-model="user.userPhone" placeholder="휴대폰 번호 입력" />
            <div v-if="user.userPhone.length > 11" class="error-text">휴대폰 번호는 11자리를 초과할 수 없습니다.</div>

            <button @click="requestCert">📱 본인인증</button>
            <button @click="fnJoin" :disabled="!isAuthenticated">회원가입</button>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>

    <script>
        IMP.init("imp29272276"); // ✅ 본인인증 imp 키

        const app = Vue.createApp({
            data() {
                return {
                    user: {
                        userName: "",
                        userId: "",
                        pwd: "",
                        pwd2: "",
                        userEmail: "",
                        userPhone: ""
                    },
                    isAuthenticated: false
                };
            },
            methods: {
                requestCert() {
                    const self = this;
                    IMP.certification({
                        merchant_uid: "cert_" + new Date().getTime(),
                    }, function (rsp) {
                        if (rsp.success) {
                            self.isAuthenticated = true;
                            alert("✅ 본인 인증 성공!");
                        } else {
                            alert("❌ 인증 실패. 다시 시도해주세요.");
                        }
                    });
                },
                fnJoin() {
                    if (!this.user.userName.trim()) return alert("이름을 입력하세요.");
                    if (this.user.userId.length < 5) return alert("아이디는 5자 이상이어야 합니다.");
                    if (this.user.pwd.length < 8) return alert("비밀번호는 8자 이상이어야 합니다.");
                    if (this.user.pwd !== this.user.pwd2) return alert("비밀번호가 일치하지 않습니다.");
                    if (!this.user.userEmail.trim()) return alert("이메일을 입력하세요.");
                    if (this.user.userPhone.length !== 11 || !/^[0-9]+$/.test(this.user.userPhone)) {
                        return alert("휴대폰 번호는 11자리 숫자여야 합니다.");
                    }

                    const nparmap = { ...this.user };

                    $.ajax({
                        url: "/join/user-add.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function () {
                            alert("회원가입 완료되었습니다.");
                            location.href = "/user/login.do";
                        },
                        error: function () {
                            alert("회원가입 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnIdCheck() {
                    if (this.user.userId === "") return alert("아이디 입력하셈");
                    $.ajax({
                        url: "/join/check.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: this.user.userId },
                        success: function (data) {
                            alert(data.count == 0 ? "사용 가능" : "사용 불가능");
                        }
                    });
                }
            }
        });
        app.mount('#app');
    </script>