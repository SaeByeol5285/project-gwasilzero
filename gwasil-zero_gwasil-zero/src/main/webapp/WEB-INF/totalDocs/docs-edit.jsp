<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>공지사항 수정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="card">
                <h2 class="section-title">통합자료실 게시물 수정</h2>

                <div class="form-group mb-20">
                    <label>제목</label>
                    <input v-model="info.totalTitle" class="input-box">
                </div>

                <div class="form-group mb-20">
                    <label>내용</label>
                    <div id="quill-editor" style="height: 300px;"></div>
                </div>

                <div class="form-group mb-20">
                    <label>기존 첨부파일</label>
                    <ul>
                        <li v-for="(file, idx) in fileList" :key="idx">
                            {{ file.fileName }}
                            <template v-if="isPreviewable(file.fileName)">
                                <a :href="file.filePath" target="_blank" style="margin-left: 10px;">보기</a>
                            </template>
                            <a :href="file.filePath" target="_blank" download style="margin-left: 10px;">다운로드</a>
                            <a href="javascript:void(0)" @click="removeFile(file)"
                                style="color: red; margin-left: 10px;">삭제</a>
                        </li>
                    </ul>
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
                    fileList: [],
                    deleteList: [],
                    quill: null,
                    isSubmitting: false
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
                                self.fileList = data.fileList;
                                if (self.quill) {
                                    self.quill.root.innerHTML = data.info.totalContents;
                                }
                            } else {
                                alert("오류발생");
                            }
                        }
                    });
                },
                removeFile(file) {
                    this.deleteList.push(file);
                    this.fileList = this.fileList.filter(f => f !== file);
                },
                fnEdit() {
                    const self = this;
                    if (self.isSubmitting) return;
                    self.isSubmitting = true;

                    const form = new FormData();
                    form.append("totalNo", self.totalNo);
                    form.append("totalTitle", self.info.totalTitle);
                    const content = self.quill.root.innerHTML;
                    form.append("totalContents", content);
                    form.append("kind", "NOTICE");

                    const files = $("#file1")[0].files;
                    for (let i = 0; i < files.length; i++) {
                        form.append("file1", files[i]);
                    }

                    self.deleteList.forEach(file => {
                        form.append("deleteList", file.filePath);
                    });

                    $.ajax({
                        url: "/totalDocs/edit.dox",
                        type: "POST",
                        data: form,
                        processData: false,
                        contentType: false,
                        success(data) {
                            self.isSubmitting = false;
                            if (data.result === "success") {
                                alert("수정 완료!");
                                pageChange("/totalDocs/list.do", { kind: "NOTICE" });
                            } else {
                                alert("수정 실패!");
                            }
                        },
                        error() {
                            self.isSubmitting = false;
                            alert("서버 오류 발생");
                        }
                    });
                },
                goToListPage() {
                    pageChange("/totalDocs/detail.do", { totalNo: this.totalNo, kind: "NOTICE" });
                },
                initQuill() {
                    const self = this;
                    self.quill = new Quill("#quill-editor", {
                        theme: "snow",
                        modules: {
                            toolbar: {
                                container: [
                                    ['bold', 'italic', 'underline'],
                                    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                                    ['image'],
                                    ['clean']
                                ],
                                handlers: {
                                    image: function () {
                                        const input = document.createElement("input");
                                        input.setAttribute("type", "file");
                                        input.setAttribute("accept", "image/*");
                                        input.click();

                                        input.onchange = async () => {
                                            const file = input.files[0];
                                            if (file) {
                                                const formData = new FormData();
                                                formData.append("image", file);

                                                try {
                                                    const response = await fetch("/upload/image.dox", {
                                                        method: "POST",
                                                        body: formData,
                                                    });

                                                    const result = await response.json();
                                                    if (result.url) {
                                                        const range = self.quill.getSelection();
                                                        self.quill.insertEmbed(range.index, "image", result.url);
                                                    } else {
                                                        alert("이미지 업로드 실패");
                                                    }
                                                } catch (err) {
                                                    console.error(err);
                                                    alert("이미지 업로드 중 오류 발생");
                                                }
                                            }
                                        };
                                    }
                                }
                            }
                        }
                    });
                },
                isPreviewable(fileName) {
                    const ext = fileName.split('.').pop().toLowerCase();
                    return ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'pdf'].includes(ext);
                }
            },
            mounted() {
                this.initQuill();
                this.fnDocsView();
            }
        });
        app.mount("#app");
    </script>

    </html>