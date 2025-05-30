<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
				      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
        <style>
            #app {
                max-width: 500px;
                margin: 80px auto;
                font-family: 'Segoe UI', sans-serif;
                font-size: 16px;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }

            h2 {
                text-align: center;
                color: #444;
                margin-bottom: 30px;
            }

            label {
                display: block;
                margin: 10px 0 6px;
                font-weight: 600;
                color: #333;
            }

            .full-width {
                width: 100%;
                padding: 12px 14px;
                box-sizing: border-box;
                border: 1px solid #ddd;
                border-radius: 10px;
                background-color: #fdfdfd;
                transition: border-color 0.3s;
            }

            .full-width:focus {
                border-color: #ff7a3d;
                outline: none;
            }

            .save-button {
                width: 100%;
                padding: 14px;
                background-color: #ff7a3d;
                color: #fff;
                font-size: 16px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: bold;
                margin-top: 20px;
                transition: background-color 0.3s, box-shadow 0.3s;
            }

            .save-button:hover {
                background-color: #ff5a1a;
                box-shadow: 0 4px 10px rgba(255, 122, 61, 0.3);
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h2>내 정보 수정</h2>
            <div>
                <label>프로필 사진</label>
                <input type="file" @change="handleProfileImg">
                <div v-if="lawyerInfo.lawyerImg">
                    <img :src="lawyerInfo.lawyerImg" style="width: 100px; height: 100px; margin-top: 10px;">
                </div>
            </div>
            <div>
                <label>이름</label>
                <input v-model="lawyerInfo.lawyerName" class="full-width">
            </div>
            <div>
                <label>핸드폰 번호</label>
                <input v-model="lawyerInfo.lawyerPhone" class="full-width">
            </div>
            <div>
                <label>이메일</label>
                <input v-model="lawyerInfo.lawyerEmail" class="full-width">
            </div>
            <div>
                <label>사무소 주소</label>
                <input v-model="lawyerInfo.lawyerAddr" class="full-width">
            </div>
            <button @click="fnSave" class="save-button">저장</button>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    lawyerInfo: {}
                };
            },
            methods: {
                handleProfileImg(event) {
                    const file = event.target.files[0];
                    if (file) {
                        this.fnUploadImg(file);
                        this.lawyerInfo.lawyerImg = "/img/" + file.name;
                    }
                },
                fnGetInfo() {
                    const self = this;
                    $.ajax({
                        url: "/lawyerMyPage/info.dox",
                        type: "POST",
                        data: { sessionId: self.sessionId },
                        dataType: "json",
                        success: function (data) {
                            self.lawyerInfo = data.lawyerInfo;
                        }
                    });
                },

                fnUploadImg(file) {
                    const self = this;
                    const formData = new FormData();
                    formData.append("uploadFile", file);
                    formData.append("lawyerId", self.sessionId);

                    $.ajax({
                        url: "/lawyerMyPage/uploadImg.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            if (data.result === "success") {
                                self.lawyerInfo.lawyerImg = data.imgPath;
                            }
                        }
                    });
                },

                fnSave() {
                    const self = this;

                    Swal.fire({
                        title: "수정하시겠습니까?",
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonColor: "#ff5c00",
                        cancelButtonColor: "#aaa",
                        confirmButtonText: "확인",
                        cancelButtonText: "취소"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const nparmap = {
                                sessionId: self.sessionId,
                                lawyerName: self.lawyerInfo.lawyerName,
                                lawyerPhone: self.lawyerInfo.lawyerPhone,
                                lawyerEmail: self.lawyerInfo.lawyerEmail,
                                lawyerAddr: self.lawyerInfo.lawyerAddr,
                                lawyerImg: self.lawyerInfo.lawyerImg
                            };

                            $.ajax({
                                url: "/lawyerMyPage/edit.dox",
                                type: "POST",
                                data: nparmap,
                                dataType: "json",
                                success: function (data) {
                                    if (data.result === "success") {
                                        Swal.fire({
                                            icon: "success",
                                            title: "수정 완료",
                                            text: "정보가 성공적으로 수정되었습니다.",
                                            confirmButtonColor: "#ff5c00"
                                        }).then(() => {
                                            location.href = "/mypage/lawyerMyPage.do";
                                        });
                                    } else {
                                        Swal.fire({
                                            icon: "error",
                                            title: "수정 실패",
                                            text: "다시 시도해주세요.",
                                            confirmButtonColor: "#ff5c00"
                                        });
                                    }
                                }
                            });
                        }
                    });
                }
            },
            mounted() {
                this.fnGetInfo();
            }
        });
        app.mount("#app");
    </script>