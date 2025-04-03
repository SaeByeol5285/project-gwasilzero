<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>이용문의 등록</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="card">
                <h2 class="section-title">이용문의 등록</h2>

                <div class="form-group mb-20">
                    <label>제목</label>
                    <input v-model="totalTitle" class="input-box" placeholder="제목을 입력하세요">
                </div>

                <div class="form-group mb-20">
                    <label>첨부파일</label>
                    <input type="file" id="file1" name="file1" multiple>
                </div>

                <div class="form-group mb-20">
                    <label>내용</label>
                    <div id="quill-editor" style="height: 300px;"></div>
                </div>

                <div class="btn-area">
                    <button @click="fnAddNotice" class="btn btn-primary" :disabled="isSubmitting">등록</button>
                    <button @click="goToListPage" class="btn btn-outline">목록보기</button>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    totalTitle: "",
                    userId: "${sessionId}",
                    kind: "HELP",
                    quill: null,
                    isSubmitting: false // 중복 방지용 플래그

                };
            },
            methods: {
                fnAddNotice() {
                    const self = this;

                    if (self.isSubmitting) return; // 제출 중이면 막기
                    self.isSubmitting = true;

                    const content = self.quill.root.innerHTML;

                    if (!self.totalTitle || !content || content === "<p><br></p>") {
                        alert("제목과 내용을 모두 입력해주세요.");
                        self.isSubmitting = false;
                        return;
                    }

                    const nparmap = {
                        totalTitle: self.totalTitle,
                        totalContents: content,
                        userId: self.userId,
                        kind: self.kind
                    };

                    $.ajax({
                        url: "/totalDocs/add.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result === "success") {
                                if ($("#file1")[0].files.length > 0) {
                                    const form = new FormData();
                                    for (let i = 0; i < $("#file1")[0].files.length; i++) {
                                        form.append("file1", $("#file1")[0].files[i]);
                                    }
                                    form.append("totalNo", data.totalNo); // 서버에서 리턴한 PK
                                    self.upload(form);
                                } else {
                                    alert("글쓰기가 완료되었습니다.");
                                    pageChange("/totalDocs/list.do", { kind: "HELP" });
                                }
                            } else {
                                alert("글쓰기 실패!");
                                self.isSubmitting = false;

                            }
                        },
                        error: function () {
                            alert("서버 오류가 발생했습니다.");
                            self.isSubmitting = false;

                        }
                    });
                },
                upload(form) {
                    $.ajax({
                        url: "/fileUpload.dox",
                        type: "POST",
                        processData: false,
                        contentType: false,
                        data: form,
                        success: function (data) {
                            if (data.result === "success") {
                                alert("글쓰기가 완료되었습니다.");
                                pageChange("/totalDocs/list.do", { kind: "HELP" });
                            } else {
                                alert("파일 업로드 실패.");
                            }
                        }
                    });
                },
                goToListPage() {
                    pageChange("/totalDocs/list.do", { kind: "HELP" });
                },
                initQuill() {
                    const self = this;
                    const toolbarOptions = [
                        ['bold', 'italic', 'underline'],
                        [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                        ['image'],
                        ['clean']
                    ];

                    self.quill = new Quill("#quill-editor", {
                        theme: "snow",
                        modules: {
                            toolbar: {
                                container: toolbarOptions,
                                handlers: {
                                    image: function () {
                                        // 이미지 업로드 핸들러
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

            },
            mounted() {
                this.initQuill();
            }
        });

        app.mount("#app");
    </script>

    </html>