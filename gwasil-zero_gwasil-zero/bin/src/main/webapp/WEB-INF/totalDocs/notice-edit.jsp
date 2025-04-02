<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
        <title>공지사항 상세</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="card">
                <h2 class="section-title">공지사항 수정</h2>

                <div class="form-group mb-20">
                    <label>제목</label>
                    <input v-model="info.totalTitle" class="input-box">
                </div>

                <div class="form-group mb-20">
                    <label>내용</label>
                    <textarea v-model="info.totalContents" class="textarea-box"></textarea>
                </div>
                
                <!-- // TODO: 선택한 파일 경로에 대해 삭제 처리 로직 추가 -->
                <div class="form-group mb-20">
                    <label>기존 첨부파일</label>
                    <div v-for="(file, idx) in imgList" :key="idx">
                        {{ file.fileName }}
                        <a :href="file.filePath" target="_blank">(보기)</a>
                    </div>
                </div>


                <div class="form-group mb-20">
                    <label>새 파일 업로드</label>
                    <input type="file" id="file1" name="file1" multiple>
                </div>

                <div class="btn-area">
                    <button @click="fnEdit" class="btn btn-primary">저장</button>
                    <button @click="goToListPage" class="btn btn-outline">목록</button>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    totalNo: "${map.totalNo}",
                    info: {},
                    imgList: [],
                    deleteFiles: []
                };
            },
            methods: {
                fnNoticeView() {
                    const self = this;
                    $.ajax({
                        url: "/notice/view.dox",
                        type: "POST",
                        dataType: "json",
                        data: { totalNo: self.totalNo },
                        success(data) {
                            if (data.result === "success") {
                                self.info = data.info;
                                self.imgList = data.imgList || [];
                            } else {
                                alert("오류 발생");
                            }
                        }
                    });
                },
                fnEdit() {
                    const self = this;
                    const form = new FormData();
                    form.append("totalNo", self.totalNo);
                    form.append("totalTitle", self.info.totalTitle);
                    form.append("totalContents", self.info.totalContents);

                    // 새 파일만 업로드
                    const files = $("#file1")[0].files;
                    for (let i = 0; i < files.length; i++) {
                        form.append("file1", files[i]);
                    }

                    $.ajax({
                        url: "/notice/edit.dox", // ← 여기에 글 수정 로직 포함돼 있어야 함
                        type: "POST",
                        data: form,
                        processData: false,
                        contentType: false,
                        success(data) {
                            if (data.result === "success") {
                                alert("수정 완료!");
                                location.href = "/notice/list.do";
                            } else {
                                alert("수정 실패!");
                            }
                        }
                    });
                },

                goToListPage() {
                    pageChange("/notice/list.do", {});
                }
            },
            mounted() {
                this.fnNoticeView();
            }
        });
        app.mount("#app");
    </script>

    </html>