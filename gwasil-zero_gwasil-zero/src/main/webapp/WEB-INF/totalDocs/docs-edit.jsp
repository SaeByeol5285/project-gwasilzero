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
                        <label><strong>기존 첨부파일</strong></label>
                        <ul class="file-list">
                            <li v-for="(file, idx) in fileList" :key="idx">
                                <img src="/img/common/file-attached.png" class="file-icon" />
                                {{ file.fileName }}
                                <template v-if="isPreviewable(file.fileName)">
                                    <a :href="file.filePath" target="_blank" class="btn-blue-small">보기</a>
                                </template>
                                <a :href="file.filePath" target="_blank" download class="btn-blue-small">다운로드</a>
                                <button @click="removeFile(file)" class="btn-red-small">삭제</button>
                            </li>
                        </ul>
                    </div>

                    <div class="attachment-box">
                        <label><strong>새 파일 업로드</strong></label>
                        <div>
                            <input type="file" id="file1" name="file1" multiple @change="handleFileChange" />
                        </div>
                        <ul class="file-list">
                            <li v-for="(file, i) in selectedFiles" :key="i">
                                <img src="/img/common/file-attached.png" class="file-icon" />
                                {{ file.name }}
                                <button @click="removeNewFile(i)" class="btn-red-small">삭제</button>
                            </li>
                        </ul>
                    </div>

                    <div class="post-actions">
                        <div class="right-buttons">
                            <button @click="fnEdit" class="btn btn-write">저장</button>
                            <button @click="goToListPage" class="btn btn-red" style="margin-left: 10px;">취소</button>
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
                    isSubmitting: false,
                    selectedFiles: [],

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
                                console.log(data);
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
                //선택한 파일 리스트로
                handleFileChange(event) {
                    this.selectedFiles = Array.from(event.target.files);
                },
                //첨부파일 삭제
                removeNewFile(index) {
                    this.selectedFiles.splice(index, 1);
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
                                Swal.fire({
                                    icon: "success",
                                    title: "수정 완료",
                                    text: "게시글이 성공적으로 수정되었습니다.",
                                    confirmButtonText: "확인"
                                }).then(() => {
                                    pageChange("/totalDocs/list.do", { kind: self.info.kind });
                                });
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "수정 실패",
                                    text: "수정 중 문제가 발생했습니다.",
                                    confirmButtonText: "확인"
                                });
                            }
                        },
                        error() {
                            self.isSubmitting = false;
                            Swal.fire({
                                icon: "error",
                                title: "서버 오류",
                                text: "서버와의 통신 중 오류가 발생했습니다.",
                                confirmButtonText: "확인"
                            });
                        }
                    });
                },
                goToListPage() {
                    const self = this;
                    Swal.fire({
                        title: "수정을 취소하시겠습니까?",
                        text: "작성한 내용은 저장되지 않습니다.",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "네, 취소할게요",
                        cancelButtonText: "아니오",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            pageChange("/totalDocs/detail.do", {
                                totalNo: self.totalNo,
                                kind: self.info.kind
                            });
                        }
                    });
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