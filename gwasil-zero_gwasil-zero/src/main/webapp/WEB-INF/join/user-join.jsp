<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>사용자 회원가입</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <style>
            #app {
                width: 100%;
                max-width: 400px;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin: 20px auto;
                text-align: left;
            }

            input,
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }

            button {
                width: 100%;
                padding: 10px;
                margin-top: 10px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background-color: #FF5722;
                color: #fff;
            }

            button:hover {
                background-color: #FF7043;
            }

            .error-text {
                color: red;
                font-size: 0.9rem;
            }

            .terms-check {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                font-size: 0.9rem;
            }

            .terms-check span {
                color: #FF5722;
                cursor: pointer;
                margin-left: 5px;
            }

            .terms-check input[type="checkbox"] {
                accent-color: #FF5722;
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .terms-content {
                font-size: 0.85rem;
                background: #f9f9f9;
                padding: 12px;
                border-radius: 8px;
                border: 1px solid #ddd;
                margin-bottom: 15px;
                line-height: 1.5;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h1 style="text-align: center;">사용자 회원가입</h1>

            <div class="terms-check">
                <div style="display: flex; align-items: center; gap: 6px;">
                    <label for="agree">이용약관에 동의합니다</label>
                    <span @click="showTerms = !showTerms">(자세히 보기)</span>
                </div>
                <input type="checkbox" id="agree" v-model="agreeTerms">
            </div>

            <div v-if="showTerms" class="terms-content">
                <strong>[이용약관]</strong><br />
                제 1 조 (목적)<br />
                본 약관은 과실제로(이하 "회사")가 제공하는 모든 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.<br /><br />
                제 2 조 (정의)<br />
                "회원"이란 회사의 서비스에 접속하여 이 약관에 따라 서비스를 이용하는 고객을 말합니다.<br /><br />
                제 3 조 (약관의 효력 및 변경)<br />
                회사는 관련 법령을 위반하지 않는 범위에서 이 약관을 변경할 수 있으며, 변경 시 공지사항을 통해 안내합니다.
            </div>

            <div style="margin-bottom: 15px;">
                <div>이름(닉네임)</div>
                <input v-model="user.userName" placeholder="이름(닉네임) 입력" />
            </div>

            <div style="margin-bottom: 15px;">
                <div>아이디 (5자 이상)</div>
                <input v-model="user.userId" placeholder="아이디 입력" @input="checkUserId" />
                <div v-if="idError" class="error-text">영문/숫자만 입력해주세요.</div>
                <button @click="fnIdCheck" style="margin-top: 5px;">중복체크</button>
            </div>

            <div style="margin-bottom: 15px;">
                <div>비밀번호 (8자 이상)</div>
                <input type="password" v-model="user.pwd" placeholder="비밀번호 입력" />
                <div v-if="user.pwd.length > 0 && user.pwd.length < 8" class="error-text">비밀번호는 8자 이상이어야 합니다.</div>
            </div>

            <div style="margin-bottom: 15px;">
                <div>비밀번호 확인</div>
                <input type="password" v-model="user.pwd2" placeholder="비밀번호 확인" />
                <div v-if="user.pwd !== user.pwd2 && user.pwd2" class="error-text">비밀번호 불일치</div>
            </div>

            <div style="margin-bottom: 15px;">
                <div>이메일</div>
                <input v-model="user.userEmail" placeholder="이메일 입력" />
            </div>

            <div style="margin-bottom: 15px;">
                <div>휴대폰 (11자리)</div>
                <input v-model="user.userPhone" placeholder="휴대폰 번호 입력" />
                <div v-if="user.userPhone.length > 11" class="error-text">휴대폰 번호는 11자리를 초과할 수 없습니다.</div>
            </div>

            <button @click="requestCert">📱 본인인증</button>
            <button @click="fnJoin" :disabled="!isAuthenticated" :style="{
        backgroundColor: isAuthenticated ? '#FF5722' : '#ccc',
        cursor: isAuthenticated ? 'pointer' : 'not-allowed'
    }">
                회원가입
            </button>
        </div>
        <jsp:include page="../common/footer.jsp" />

        <script>
            IMP.init("imp29272276");

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
                        isAuthenticated: false,
                        isIdChecked: false,
                        agreeTerms: false,
                        showTerms: false,
                        nameError: false,
                        isComposing: false,
                        idError: false
                    };
                },
                methods: {
                    checkUserId() {
                        const val = this.user.userId;
                        const validIdRegex = /^[a-zA-Z0-9]*$/;
                        this.idError = val && !validIdRegex.test(val);
                    },
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
                        if (!this.agreeTerms) return alert("⚠️ 이용약관에 동의해주세요.");
                        if (!this.isIdChecked) return alert("⚠️ 중복체크 하세요.");
                        if (!this.isAuthenticated) return alert("⚠️ 본인인증 하세요.");

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
                        const self = this;
                        if (this.user.userId === "") return alert("아이디 입력하셈");

                        $.ajax({
                            url: "/join/check.dox",
                            dataType: "json",
                            type: "POST",
                            data: { userId: this.user.userId },
                            success: function (data) {
                                if (data.count == 0) {
                                    alert("사용 가능");
                                    self.isIdChecked = true;
                                } else {
                                    alert("사용 불가능");
                                    self.isIdChecked = false;
                                }
                            }
                        });
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>