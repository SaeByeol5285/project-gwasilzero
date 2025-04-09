<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>변호사 회원가입</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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

            h1 {
                text-align: center;
            }

            input {
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

            .license-box {
                background-color: #f9f9f9;
                padding: 15px;
                margin-top: 20px;
                border-radius: 10px;
                border: 1px solid #ddd;
            }

            .form-group {
                margin-bottom: 12px;
            }

            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 6px;
            }

            .file-name {
                font-size: 0.9rem;
                color: #555;
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

            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
        </style>
    </head>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <h1>변호사 회원가입</h1>

            <!-- ✅ 이용약관 동의 -->
            <div class="terms-check">
                <div style="display: flex; align-items: center; gap: 6px;">
                    <label for="agree">이용약관에 동의합니다</label>
                    <span @click="showTerms = !showTerms">(자세히 보기)</span>
                </div>
                <input type="checkbox" id="agree" v-model="agreeTerms">
            </div>

            <!-- ✅ 약관 내용 -->
            <div v-if="showTerms" class="terms-content">
                <strong>[이용약관]</strong><br />
                제 1 조 (목적)<br />
                본 약관은 과실제로(이하 "회사")가 제공하는 모든 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.<br /><br />
                제 2 조 (정의)<br />
                "회원"이란 회사의 서비스에 접속하여 이 약관에 따라 서비스를 이용하는 고객을 말합니다.<br /><br />
                제 3 조 (약관의 효력 및 변경)<br />
                회사는 관련 법령을 위반하지 않는 범위에서 이 약관을 변경할 수 있으며, 변경 시 공지사항을 통해 안내합니다.
            </div>

            <!-- 입력 필드들 -->
            <div style="margin-bottom: 15px;">
                <label>이름</label>
                <input v-model="lawyer.lawyerName" placeholder="이름 입력" @compositionstart="isComposing = true"
                    @compositionend="checkKoreanName" @input="handleTyping" />
                <div v-if="nameError" class="error-text">한글만 입력해주세요.</div>
            </div>

            <div style="margin-bottom: 15px;">
                <label>아이디 (5자 이상)</label>
                <input v-model="lawyer.lawyerId" placeholder="아이디 입력" @input="checkUserId" />
                <div v-if="idError" class="error-text">영문/숫자만 입력해주세요.</div>
                <button @click="fnIdCheck" style="margin-top: 5px;">중복 체크</button>
            </div>

            <div style="margin-bottom: 15px;">비밀번호 (8자 이상)</div>
            <input type="password" v-model="lawyer.pwd" placeholder="비밀번호 입력">
            <div v-if="lawyer.pwd.length > 0 && lawyer.pwd.length < 8" class="error-text">비밀번호는 8자 이상이어야 합니다.</div>

            <div style="margin-bottom: 15px;">비밀번호 확인</div>
            <input type="password" v-model="lawyer.pwd2" placeholder="비밀번호 확인">
            <div v-if="lawyer.pwd !== lawyer.pwd2 && lawyer.pwd2" class="error-text">비밀번호가 일치하지 않습니다.</div>

            <div style="margin-bottom: 15px;">이메일</div>
            <input v-model="lawyer.lawyerEmail" placeholder="이메일 입력">

            <div style="margin-bottom: 15px;">휴대폰 번호 (11자리)</div>
            <input v-model="lawyer.lawyerPhone" placeholder="휴대폰 번호 입력">
            <div v-if="lawyer.lawyerPhone.length > 11" class="error-text">휴대폰 번호는 11자리를 초과할 수 없습니다.</div>

            <div style="margin-bottom: 15px;">주소</div>
            <input type="text" v-model="address" placeholder="주소" readonly @click="execDaumPostcode">
            <input type="text" v-model="detailAddress" placeholder="상세주소">
            <input type="hidden" :value="lawyer.lawyerStatus">

            <!-- 자격 정보 -->
            <div class="license-box">
                <h3>변호사 자격 정보</h3>
                <div class="form-group">
                    <label>생년월일. (선택)</label>
                    <input type="date" v-model="license.BIRTH" />
                </div>
                <div class="form-group">
                    <label>대한변협 등록번호</label>
                    <input v-model="license.LAWYER_NUMBER" placeholder="등록번호 입력" />
                </div>
                <div class="form-group">
                    <label>합격 연도</label>
                    <input type="text" v-model="license.PASS_YEARS" placeholder="예: 2023" />
                </div>
                <div class="form-group">
                    <label>변호사 자격증 사본</label>
                    <input type="file" @change="handleLicenseFile" />
                    <p class="file-name" v-if="licenseFileName">📎 {{ licenseFileName }}</p>
                </div>
                <div class="form-group" v-if="lawyer.lawyerStatus === 'P'">
                    <label>사무실 재직증명서</label>
                    <input type="file" @change="handleOfficeProofFile" />
                    <p class="file-name" v-if="officeProofFileName">📎 {{ officeProofFileName }}</p>
                </div>
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
            const app = Vue.createApp({
                data() {
                    return {
                        lawyer: {
                            lawyerName: "", lawyerId: "", pwd: "", pwd2: "",
                            lawyerEmail: "", lawyerPhone: "", lawyerAddr: "", lawyerStatus: ""
                        },
                        address: "", detailAddress: "",
                        license: { BIRTH: "", LAWYER_NUMBER: "", PASS_YEARS: "" },
                        licenseFile: null, licenseFileName: "",
                        officeProofFile: null, officeProofFileName: "",
                        isAuthenticated: false, isIdChecked: false,
                        agreeTerms: false, showTerms: false,
                        isComposing: false, nameError: false, idError: false
                    };
                },
                methods: {
                    handleTyping() {
                        if (!this.isComposing) this.checkKoreanName();
                    },
                    checkKoreanName() {
                        this.isComposing = false;
                        const val = this.lawyer.lawyerName;
                        const koreanRegex = /^[가-힣ㄱ-ㅎㅏ-ㅣ\s]*$/;
                        this.nameError = val && !koreanRegex.test(val);
                    },
                    checkUserId() {
                        const val = this.lawyer.lawyerId;
                        const validIdRegex = /^[a-zA-Z0-9]*$/;
                        this.idError = val && !validIdRegex.test(val);
                    },
                    fnJoin() {
                        if (!this.agreeTerms) return alert("이용약관에 동의해주세요.");
                        if (!this.isIdChecked) return alert("중복체크를 먼저 해주세요.");
                        if (!this.isAuthenticated) return alert("본인인증을 먼저 해주세요.");
                        if (!this.lawyer.lawyerName.trim()) return alert("이름을 입력하세요.");
                        if (this.lawyer.lawyerId.length < 5) return alert("아이디는 5자 이상이어야 합니다.");
                        if (this.lawyer.pwd.length < 8) return alert("비밀번호는 8자 이상이어야 합니다.");
                        if (this.lawyer.pwd !== this.lawyer.pwd2) return alert("비밀번호가 일치하지 않습니다.");
                        if (!this.lawyer.lawyerEmail.trim()) return alert("이메일을 입력하세요.");
                        if (this.lawyer.lawyerPhone.length !== 11 || !/^[0-9]+$/.test(this.lawyer.lawyerPhone)) return alert("휴대폰 번호는 11자리 숫자여야 합니다.");

                        this.lawyer.lawyerAddr = this.address + " " + this.detailAddress;

                        const formData = new FormData();
                        Object.entries(this.lawyer).forEach(([key, val]) => formData.append(key, val));
                        Object.entries(this.license).forEach(([key, val]) => formData.append(key, val));

                        if (this.licenseFile) {
                            formData.append("LAWYER_LICENS_NAME", this.licenseFile.name);
                            formData.append("LAWYER_LICENS_PATH", this.licenseFile.name);
                            formData.append("licenseFile", this.licenseFile);
                        }

                        if (this.officeProofFile) {
                            formData.append("OFFICEPROOF_NAME", this.officeProofFile.name);
                            formData.append("OFFICEPROOF_PATH", this.officeProofFile.name);
                            formData.append("officeProofFile", this.officeProofFile);
                        }

                        $.ajax({
                            url: "/join/lawyer-add.dox",
                            type: "POST",
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: () => {
                                alert("회원가입 완료되었습니다.");
                                location.href = "/user/login.do";
                            },
                            error: () => {
                                alert("회원가입 실패. 다시 시도해주세요.");
                            }
                        });
                    },
                    fnIdCheck() {
                        if (!this.lawyer.lawyerId) return alert("아이디를 입력하세요.");
                        $.ajax({
                            url: "/join/checkLawyer.dox",
                            type: "POST",
                            dataType: "json",
                            data: { lawyerId: this.lawyer.lawyerId },
                            success: (data) => {
                                if (data.count == 0) {
                                    alert("사용 가능한 아이디입니다.");
                                    this.isIdChecked = true;
                                } else {
                                    alert("이미 사용 중인 아이디입니다.");
                                    this.isIdChecked = false;
                                }
                            }
                        });
                    },
                    execDaumPostcode() {
                        new daum.Postcode({
                            oncomplete: (data) => {
                                let fullAddr = data.roadAddress || data.jibunAddress;
                                this.address = fullAddr;
                                this.detailAddress = "";
                                this.$nextTick(() => {
                                    document.querySelector("input[placeholder='상세주소']").focus();
                                });
                            }
                        }).open();
                    },
                    handleLicenseFile(event) {
                        const file = event.target.files[0];
                        this.licenseFile = file;
                        this.licenseFileName = file ? file.name : "";
                    },
                    handleOfficeProofFile(event) {
                        const file = event.target.files[0];
                        this.officeProofFile = file;
                        this.officeProofFileName = file ? file.name : "";
                    },
                    requestCert() {
                        const self = this;
                        IMP.init("imp29272276");
                        IMP.certification({
                            merchant_uid: "lawyer_cert_" + new Date().getTime()
                        }, function (rsp) {
                            if (rsp.success) {
                                self.isAuthenticated = true;
                                alert("✅ 본인 인증 성공");
                            } else {
                                alert("❌ 인증 실패: " + rsp.error_msg);
                            }
                        });
                    }
                },
                mounted() {
                    const status = new URLSearchParams(location.search).get("status");
                    this.lawyer.lawyerStatus = status;
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>