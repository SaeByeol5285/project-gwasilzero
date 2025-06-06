<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
		<link rel="icon" type="image/png" href="/img/common/logo3.png">
				      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/common.css">
        <link rel="stylesheet" href="/css/totalDocs.css">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <div class="container-detail">
                <div class="detail-box">
                    <div class="post-header">
                        <h2 class="section-title">이용문의 등록</h2>
                    </div>

                    <div class="form-group">
                        <input v-model="totalTitle" class="input-box" placeholder="제목을 입력하세요" />
                    </div>

                    <!-- 첨부파일 -->
                    <div class="attachment-box">
                        <label><strong>첨부파일</strong></label>
                        <div>
                            <input id="file1" type="file" multiple @change="handleFileChange" />
                        </div>
                        <ul class="file-list">
                            <li v-for="(file, i) in selectedFiles" :key="i">
                                <img src="/img/common/file-attached.png" class="file-icon" />
                                {{ file.name }}
                                <button @click="removeFile(i)" class="btn-red-small">삭제</button>
                            </li>
                        </ul>
                    </div>

                    <div class="form-group">
                        <div id="quill-editor" style="height: 300px;"></div>
                    </div>

                    <div class="post-actions">
                        <div class="right-buttons">
                            <button @click="fnAddNotice" class="btn btn-write" :disabled="isSubmitting">✏️ 등록</button>
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
                    totalTitle: "",
                    userId: "${sessionId}",
                    kind: "HELP",
                    quill: null,
                    isSubmitting: false, // 중복 방지용 플래그
                    selectedFiles: [],

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
                                    Swal.fire({
                                        icon: "success",
                                        title: "글쓰기 완료",
                                        text: "성공적으로 등록되었습니다.",
                                        confirmButtonText: "확인"
                                    }).then(() => {
                                        pageChange("/totalDocs/list.do", { kind: "HELP" });
                                    });
                                }
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "글쓰기 실패",
                                    text: "작성 중 문제가 발생했습니다.",
                                    confirmButtonText: "확인"
                                });
                                self.isSubmitting = false;
                            }
                        },
                        error: function () {
                            Swal.fire({
                                icon: "error",
                                title: "서버 오류",
                                text: "서버와의 통신 중 오류가 발생했습니다.",
                                confirmButtonText: "확인"
                            });
                            self.isSubmitting = false;
                        }
                    });

                },
                //선택한 파일 리스트로
                handleFileChange(event) {
                    this.selectedFiles = Array.from(event.target.files);
                },
                //첨부파일 삭제
                removeFile(index) {
                    this.selectedFiles.splice(index, 1);
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
                                Swal.fire({
                                    icon: "success",
                                    title: "글쓰기 완료",
                                    text: "성공적으로 작성되었습니다.",
                                    confirmButtonText: "확인"
                                }).then(() => {
                                    pageChange("/totalDocs/list.do", { kind: "HELP" });
                                });
                            } else {
                                Swal.fire({
                                    icon: "error",
                                    title: "업로드 실패",
                                    text: "파일 업로드 중 문제가 발생했습니다.",
                                    confirmButtonText: "확인"
                                });
                            }
                        },
                        error: function () {
                            Swal.fire({
                                icon: "error",
                                title: "서버 오류",
                                text: "파일 업로드 요청 중 서버 오류가 발생했습니다.",
                                confirmButtonText: "확인"
                            });
                        }
                    });
                },

                goToListPage() {
                    Swal.fire({
                        title: "작성을 취소하시겠습니까?",
                        text: "작성 중인 내용은 저장되지 않습니다.",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "네, 취소할게요",
                        cancelButtonText: "계속 작성할게요"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            pageChange("/totalDocs/list.do", { kind: "HELP" });
                        }
                    });
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