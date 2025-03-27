<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
        <title>글수정</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="card">
                <h2 class="section-title">수정</h2>

                <div class="form-group mb-20">

                    <div class="form-group mb-20">
                        <label>카테고리</label>
                        <select v-model="info.kind" class="input-box">
                            <option v-for="category in categoryList" :value="category">{{ category }}</option>
                        </select>
                    </div>

                    <div class="form-group mb-20">
                        <label>제목</label>
                        <input v-model="info.totalTitle" class="input-box">
                    </div>


                    <div class="form-group mb-20">
                        <label>내용</label>
                        <div id="quill-editor" style="height: 300px;" v-model="info.totalContents"></div>
                    </div>

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
                    deleteFiles: [],
                    quill: null,
                    sessionStatus: "",
                    categoryList: []

                };
            },
            methods: {
                fnDocsView() {
                    const self = this;
                    $.ajax({
                        url: "/totalDocs/view.dox",
                        type: "POST",
                        dataType: "json",
                        data: { totalNo: self.totalNo },
                        success(data) {
                            if (data.result === "success") {
                                self.info = data.info;
                                self.imgList = data.imgList;

                                // Quill 에디터에 내용 삽입
                                if (self.quill) {
                                    self.quill.root.innerHTML = data.info.totalContents;
                                }
                            } else {
                                alert("오류발생");
                            }
                        }
                    });
                },

                fnEdit() {
                    const self = this;
                    const form = new FormData();
                    form.append("totalNo", self.totalNo);
                    form.append("totalTitle", self.info.totalTitle);

                    // Quill 에디터에서 HTML 가져오기
                    const content = self.quill.root.innerHTML;
                    form.append("totalContents", content);
                    form.append("kind", self.info.kind); // ← kind 값도 꼭 넘겨줘야 함

                    const files = $("#file1")[0].files;
                    for (let i = 0; i < files.length; i++) {
                        form.append("file1", files[i]);
                    }

                    $.ajax({
                        url: "/totalDocs/edit.dox",
                        type: "POST",
                        data: form,
                        processData: false,
                        contentType: false,
                        success(data) {
                            if (data.result === "success") {
                                alert("수정 완료!");
                                pageChange("/totalDocs/list.do", { kind: self.kind });
                            } else {
                                alert("수정 실패!");
                            }
                        }
                    });
                },

                goToListPage() {
                    pageChange("/totalDocs/detail.do", { totalNo: totalNo, kind: 'NOTICE' });
                },

                initQuill() {
                    this.quill = new Quill("#quill-editor", {
                        theme: "snow"
                    });
                },
            },
            mounted() {
                this.fnDocsView();
                this.initQuill();
                if (this.sessionStatus === 'A') {
                    this.categoryList = ['NOTICE', 'QNA'];
                } else {
                    this.categoryList = ['QNA'];
                }

            }
        });
        app.mount("#app");
    </script>

    </html>