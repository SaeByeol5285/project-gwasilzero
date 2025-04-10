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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

            .email-row {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .email-row span {
                margin: 0 5px;
            }

            .email-row select {
                height: 42px;
                padding: 0 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 14px;
                background-color: white;
                appearance: none;
                /* 기본 화살표 없애기 */
                background-image: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6"><polygon points="0,0 10,0 5,6" style="fill:%23666;" /></svg>');
                background-repeat: no-repeat;
                background-position: right 10px center;
                background-size: 10px 6px;
            }

            /* 전문 분야 체크박스 그룹 스타일 */
            .category-box {
                display: flex;
                flex-wrap: wrap;
                gap: 8px 12px;
                margin-top: 8px;
            }

            /* 체크박스 + 라벨 */
            .category-box label {
                font-size: 13px;
                display: inline-flex;
                align-items: center;
                /* ✅ 이거랑 같이 써야 깔끔 */
                gap: 6px;
                width: 45%;
                margin-bottom: 6px;
                line-height: 1.2;
                vertical-align: middle;

            }

            /* 체크박스 스타일 - 기본 색상 적용 */
            .category-box input[type="checkbox"] {
                accent-color: #FF5722;
                width: 16px;
                height: 16px;
                margin-bottom: 0px;
                cursor: pointer;
                vertical-align: middle;
                /* ✅ 중앙 정렬 포인트 */
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
                <input v-model="lawyer.lawyerName" placeholder="이름 입력" />
                <div v-if="lawyer.lawyerName.trim().length === 0" class="error-text">이름을 입력해주세요.</div>
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

            <!-- 이메일 -->
            <div>
                <div>이메일</div>
                <div class="email-row">
                    <input v-model="emailId" @blur="emailIdTouched = true" placeholder="이메일 아이디" style="flex: 1;" />
                    <span>@</span>
                    <select v-model="emailDomain" class="email-select" style="flex: 1;">
                        <option value="">선택</option>
                        <option value="naver.com">naver.com</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="daum.net">daum.net</option>
                        <option value="hanmail.net">hanmail.net</option>
                        <option value="nate.com">nate.com</option>
                        <option value="직접입력">직접입력</option>
                    </select>
                </div>
                <input v-if="emailDomain === '직접입력'" v-model="customDomain" placeholder="도메인 입력"
                    style="margin-top: 8px;" />
                <div v-if="emailIdTouched && !isEmailValid" class="error-text">이메일 형식이 아닙니다.</div>
            </div>

            <div style="margin-bottom: 15px;">휴대폰 번호 (11자리)</div>
            <input v-model="lawyer.lawyerPhone" placeholder="휴대폰 번호 입력">
            <div v-if="lawyer.lawyerPhone.length > 11" class="error-text">휴대폰 번호는 11자리를 초과할 수 없습니다.</div>

            <div style="margin-bottom: 15px;">주소</div>
            <input type="text" v-model="address" placeholder="주소" readonly @click="execDaumPostcode">
            <input type="text" v-model="detailAddress" placeholder="상세주소">
            <input type="hidden" :value="lawyer.lawyerStatus">
            <div class="form-group">
                <label>메인 전문 분야 (2개 선택 필수)</label>
                <div class="category-box">
                    <label v-for="(item, index) in categoryOptions" :key="index">
                        <input type="checkbox" :value="item" v-model="mainCategories"
                            :disabled="mainCategories.length >= 2 && !mainCategories.includes(item)" />
                        {{ item }}
                    </label>
                </div>
                <div v-if="mainCategories.length !== 2" class="error-text">2개의 분야를 선택해야 합니다.</div>
            </div>

            <!-- 자격 정보 -->
            <div class="license-box">
                <h3>변호사 자격 정보</h3>
                <div class="form-group">
                    <label>생년월일 (선택)</label>
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
                <!-- 프로필 사진 -->
                <div class="form-group">
                    <label>프로필 사진</label>
                    <input type="file" @change="handleProfileImg" />
                    <p class="file-name" v-if="profileImgFileName">📎 {{ profileImgFileName }}</p>
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
                        profileImgFile: null, profileImgFileName: "", // ✅ 프로필 사진 관련
                        isAuthenticated: false, isIdChecked: false,
                        agreeTerms: false, showTerms: false,
                        isComposing: false, nameError: false, idError: false,
                        emailId: "", emailDomain: "", customDomain: "",
                        emailIdTouched: false,
                        mainCategories: [],
                        categoryOptions: [
                            "신호 위반", "보행자 사고", "음주/무면허 사고", "끼어들기/진로 변경",
                            "주차/문 개방", "중앙선 침범", "과속/안전거리 미확보", "역주행/일방통행",
                            "불법 유턴/좌회전", "기타/복합 사고"
                        ],
                        categoryMap: {
                            "신호 위반": "01",
                            "보행자 사고": "02",
                            "음주/무면허 사고": "03",
                            "끼어들기/진로 변경": "04",
                            "주차/문 개방": "05",
                            "중앙선 침범": "06",
                            "과속/안전거리 미확보": "07",
                            "역주행/일방통행": "08",
                            "불법 유턴/좌회전": "09",
                            "기타/복합 사고": "10"
                        }
                    };
                },
                computed: {
                    fullEmail() {
                        const domain = this.emailDomain === '직접입력' ? this.customDomain : this.emailDomain;
                        return this.emailId && domain ? this.emailId + "@" + domain : '';
                    },
                    isEmailValid() {
                        const email = this.fullEmail;
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        return emailRegex.test(email);
                    }
                },
                methods: {
                    handleProfileImg(event) {
                        const file = event.target.files[0];
                        this.profileImgFile = file;
                        this.profileImgFileName = file ? file.name : "";
                    },
                    fnJoin() {
                        // ...기존 유효성 검사 및 기본 값 조립
                        if (!this.agreeTerms) return alert("⚠️ 이용약관에 동의해주세요.");
                        if (!this.isIdChecked) return alert("⚠️ 중복체크 하세요.");
                        if (!this.isAuthenticated) return alert("⚠️ 본인인증 하세요.");
                        if (!this.lawyer.lawyerName.trim()) return alert("이름을 입력하세요.");
                        if (this.lawyer.lawyerId.length < 5) return alert("아이디는 5자 이상이어야 합니다.");
                        if (this.lawyer.pwd.length < 8) return alert("비밀번호는 8자 이상이어야 합니다.");
                        if (this.lawyer.pwd !== this.lawyer.pwd2) return alert("비밀번호가 일치하지 않습니다.");
                        if (!this.fullEmail || !this.isEmailValid) return alert("유효한 이메일을 입력하세요.");
                        if (this.lawyer.lawyerPhone.length !== 11 || !/^[0-9]+$/.test(this.lawyer.lawyerPhone)) {
                            return alert("휴대폰 번호는 11자리 숫자여야 합니다.");
                        }
                        if (this.mainCategories.length !== 2) return alert("전문 분야는 2개를 선택해야 합니다.");
                        this.lawyer.lawyerEmail = this.fullEmail;
                        this.lawyer.lawyerAddr = this.address + " " + this.detailAddress;

                        const formData = new FormData();

                        Object.entries(this.lawyer).forEach(([k, v]) => formData.append(k, v));
                        formData.append("lawyerEmail", this.fullEmail);
                        Object.entries(this.license).forEach(([k, v]) => formData.append(k, v));
                        formData.append("mainCategoryName1", this.categoryMap[this.mainCategories[0]]);
                        formData.append("mainCategoryName2", this.categoryMap[this.mainCategories[1]]);

                        // 프로필 이미지 경로 저장
                        if (this.profileImgFile) {
                            formData.append("LAWYER_IMG", "/img/" + this.profileImgFile.name); // 💡 DB 경로로 저장
                            formData.append("profileImgFile", this.profileImgFile); // 💡 파일 자체도 업로드
                        }

                        // 라이선스/재직 파일들도 동일하게 추가
                        if (this.licenseFile) {
                            formData.append("LAWYER_LICENSE_NAME", this.licenseFile.name);
                            formData.append("LAWYER_LICENSE_PATH", this.licenseFile.name);
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
                                Swal.fire({
                                    icon: "success",
                                    title: "회원가입 완료",
                                    text: "회원가입이 정상적으로 처리되었습니다.",
                                    confirmButtonText: "확인"
                                }).then(() => {
                                    location.href = "/user/login.do";
                                });
                            },
                            error: () => {
                                Swal.fire({
                                    icon: "error",
                                    title: "회원가입 실패",
                                    text: "다시 시도해주세요.",
                                    confirmButtonText: "확인"
                                });
                            }
                        });
                    },
                    checkUserId() {
                        const val = this.lawyer.lawyerId;
                        const validIdRegex = /^[a-zA-Z0-9]*$/;
                        this.idError = val && !validIdRegex.test(val);
                        this.isIdChecked = false;  // ✅ 아이디 입력시 중복체크 상태 초기화
                    },
                    fnIdCheck() {
                        if (!this.lawyer.lawyerId) return alert("아이디를 입력해주세요.");
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
                    // ✅ 프로필 이미지 처리 메서드
                    handleProfileImgFile(event) {
                        const file = event.target.files[0];
                        this.profileImgFile = file;
                        this.profileImgFileName = file ? file.name : "";
                    },
                    requestCert() {
                        const self = this;
                        IMP.init("imp29272276");
                        IMP.certification({
                            merchant_uid: "lawyer_cert_" + new Date().getTime()
                        }, function (rsp) {
                            if (rsp.success) {
                                self.isAuthenticated = true;
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