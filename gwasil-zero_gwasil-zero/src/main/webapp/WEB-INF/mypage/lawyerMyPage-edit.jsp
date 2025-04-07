<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>내 정보 수정</title>
        <style>
            #app {
                max-width: 500px;
                margin: 80px auto;
                font-family: Arial, sans-serif;
                font-size: 16px;
            }

            label {
                display: block;
                margin: 10px 0 5px;
            }

            input {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                width: 100%;
                padding: 12px;
                background-color: #FF5722;
                color: #fff;
                font-size: 16px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
            }

            button:hover {
                background-color: #e64a00;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <h2>내 정보 수정</h2>
            <div>
                <label>프로필 사진</label>
                <input type="file" @change="fnUploadImg" ref="fileInput">
                <div v-if="lawyerInfo.lawyerImg">
                    <img :src="lawyerInfo.lawyerImg" style="width: 100px; height: 100px; margin-top: 10px;">
                </div>
            </div>            
            <div>
                <label>이름</label>
                <input v-model="lawyerInfo.lawyerName">
            </div>
            <div>
                <label>핸드폰 번호</label>
                <input v-model="lawyerInfo.lawyerPhone">
            </div>
            <div>
                <label>이메일</label>
                <input v-model="lawyerInfo.lawyerEmail">
            </div>
            <div>
                <label>사무소 주소</label>
                <input v-model="lawyerInfo.lawyerAddr">
            </div>
            <button @click="fnSave">저장</button>
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

                fnUploadImg(event) {
                    const self = this;
                    const file = event.target.files[0];
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
                                alert("이미지 업로드 성공!");
                                self.lawyerInfo.lawyerImg = data.imgPath;
                            }
                        }
                    });
                },

                fnSave() {
                    const self = this;
                    const nparmap = {
                        sessionId: self.sessionId,
                        lawyerName: self.lawyerInfo.lawyerName,
                        lawyerPhone: self.lawyerInfo.lawyerPhone,
                        lawyerEmail: self.lawyerInfo.lawyerEmail,
                        lawyerAddr : self.lawyerInfo.lawyerAddr,
                        lawyerImg : self.lawyerInfo.lawyerImg
                    };
                    $.ajax({
                        url: "/lawyerMyPage/edit.dox",
                        type: "POST",
                        data: nparmap,
                        dataType: "json",
                        success: function (data) {
                            if (data.result === "success") {
                                alert("수정되었습니다!");
                                location.href = "/mypage/lawyerMyPage.do";
                            } else {
                                alert("수정 실패");
                            }
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