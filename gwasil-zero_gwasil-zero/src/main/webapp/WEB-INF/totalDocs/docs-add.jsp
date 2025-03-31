<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>공지사항 등록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="/css/common.css">
    <!-- ✅ Quill 에디터 -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
</head>

<body>
    <jsp:include page="../common/header.jsp" />
    <div id="app" class="container">
        <div class="card">
            <h2 class="section-title">글쓰기</h2>

            <div class="form-group mb-20">
                <label>카테고리</label>
                <select v-model="kind" class="input-box">
                    <option v-for="category in categoryList" :value="category">{{ category }}</option>
                </select>
            </div>

            <div class="form-group mb-20">
                <label>제목</label>
                <input v-model="totalTitle" class="input-box" placeholder="제목을 입력하세요">
            </div>

            <div class="form-group mb-20">
                <label>첨부파일</label>
                <input type="file" id="file1" name="file1" accept=".jpg, .png" multiple>
            </div>

            <div class="form-group mb-20">
                <label>내용</label>
                <div id="quill-editor" style="height: 300px;"></div>
            </div>

            <div class="btn-area">
                <button @click="fnAddNotice" class="btn btn-primary">등록</button>
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
                userId: "101", // 실제로는 session에서 가져올 수 있음
                kind: "NOTICE", // 초기값
                categoryList: [],
                sessionStatus: "A", // session에서 받은 값으로 바꿔줘야 함
                quill: null
            };
        },
        methods: {
            fnAddNotice() {
                const self = this;
                const content = self.quill.root.innerHTML;

                if (!self.totalTitle || !content || content === "<p><br></p>") {
                    alert("제목과 내용을 모두 입력해주세요.");
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
                                location.href = "/notice/list.do";
                            }
                        } else {
                            alert("글쓰기 실패!");
                        }
                    },
                    error: function () {
                        alert("서버 오류가 발생했습니다.");
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
                            location.href = "/notice/list.do";
                        } else {
                            alert("파일 업로드 실패.");
                        }
                    }
                });
            },
            goToListPage() {
                pageChange("/notice/list.do", {});
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
                                    // self.imageHandler();
                                }
                            }
                        }
                    }
                });
            },
            imageHandler() {
                const self = this;
                const input = document.createElement('input');
                input.setAttribute('type', 'file');
                input.setAttribute('accept', 'image/*');
                input.click();

                input.onchange = function () {
                    const file = input.files[0];
                    const formData = new FormData();
                    formData.append('uploadFile', file);

                    $.ajax({
                        url: '/upload/image.dox', // 서버 이미지 업로드 경로
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success(res) {
                            const range = self.quill.getSelection();
                            self.quill.insertEmbed(range.index, 'image', res.imageUrl);
                        },
                        error() {
                            alert('이미지 업로드 실패');
                        }
                    });
                };
            }
        },
        mounted() {
            this.initQuill();
            // ✅ 카테고리 분기
            if (this.sessionStatus === 'A') {
                this.categoryList = ['NOTICE', 'QNA'];
                this.kind = 'NOTICE';
            } else {
                this.categoryList = ['QNA'];
                this.kind = 'QNA';
            }
        }
    });

    app.mount("#app");
</script>

</html>
