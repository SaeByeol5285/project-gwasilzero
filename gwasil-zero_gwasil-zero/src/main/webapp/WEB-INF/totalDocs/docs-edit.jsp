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
        <link rel="stylesheet" href="/css/totalDocs.css">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
        <style>
            .input-box {
                width: 100%;
                padding: 12px;
                font-size: 15px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

            .attachment-box {
                background-color: #f9f9f9;
                border: 1px solid #eee;
                padding: 16px 20px;
                border-radius: 8px;
                margin-top: 20px;
                margin-bottom: 20px;
            }

            .file-list {
                padding-left: 20px;
                margin-bottom: 0;
            }

            .file-list li {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
                font-size: 14px;
                color: #333;
            }

            .btn-red-small {
                background-color: #ffe1e1;
                color: #e60000;
                border: none;
                font-size: 13px;
                padding: 4px 10px;
                border-radius: 5px;
                cursor: pointer;
            }

            .btn-red-small:hover {
                background-color: #e60000;
                color: #fff;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="container-detail">
                <div class="detail-box">
                    <div class="post-header">
                        <h2 class="section-title">공지사항 수정</h2>
                    </div>

                    <div class="form-group">
                        <input v-model="info.totalTitle" class="input-box" placeholder="제목을 입력하세요" />
                    </div>

                    <div class="form-group">
                        <div id="quill-editor" style="height: 300px;"></div>
                    </div>

                    <div class="attachment-box">
                        <label><strong>기존 채워진 파일</strong></label>
                        <ul class="file-list">
                            <li v-for="(file, idx) in fileList" :key="idx">
                                <img src="/img/common/file-attached.png" class="file-icon" />
                                {{ file.fileName }}
                                <template v-if="isPreviewable(file.fileName)">
                                    <a :href="file.filePath" target="_blank">보기</a>
                                </template>
                                <a :href="file.filePath" target="_blank" download>다운로드</a>
                                <button @click="removeFile(file)" class="btn-red-small">삭제</button>
                            </li>
                        </ul>
                    </div>

                    <div class="attachment-box">
                        <label><strong>새 파일 업로드</strong></label>
                        <input type="file" id="file1" name="file1" multiple />
                    </div>

                    <div class="post-actions">
                        <div class="left-buttons">
                            <button @click="fnEdit" class="btn btn-write">저장</button>
                        </div>
                        <div class="right-buttons">
                            <button @click="goToListPage" class="btn btn-outline">목록</button>
                        </div>
                    </div>
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
                        placeholder: "내용을 입력하세요",
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