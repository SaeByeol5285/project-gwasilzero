<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/profileEdit.css" />

        <!-- Quill 관련 -->
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" />
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/quill-emoji@0.1.7/dist/quill-emoji.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/quill-emoji@0.1.7/dist/quill-emoji.js"></script>
        
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <title>변호사 프로필 수정</title>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawEditApp">
            <div class="layout">
                <div>
                    <h2 class="section-subtitle">변호사 프로필 수정</h2>
                </div>
                <div class="content">
                    <form id="lawyerEditForm" @submit.prevent>
                        <!-- 상단 프로필 영역 -->
                        <div class="lawyer-header">
                            <div class="profile-left">
                                <img :src="info.lawyerImg" alt="프로필">
                                <h2 class="lawyer-name">
                                    {{ info.lawyerName }}
                                    <span class="lawyer-title">변호사</span>
                                </h2>
                            </div>
                            <div class="profile-right">
                                <h3 class="intro-title">소개글 수정</h3>
                                <div id="editor-info" class="lawyer-quill-editor"></div>
                            </div>
                        </div>
    
                        <hr class="divider" />
    
                        <!-- 하단 정보 박스 -->
                        <div class="tab-content">  
                            <div class="info-box">
                                <h3>법조 경력 수정</h3>
                                <div id="editor-career" class="lawyer-quill-editor"></div>
                            </div>

                            <div class="info-box">
                                <h3>업무 사례 수정</h3>
                                <div id="editor-task" class="lawyer-quill-editor"></div>
                            </div>
    
                            <div class="info-box">
                                <h3>학력 사항 수정</h3>
                                <div id="editor-edu" class="lawyer-quill-editor"></div>
                            </div>
    
                            <div class="info-box">
                                <h3>전문 분야 선택</h3>
                                <p class="lawyer-board-note">{{ selectedCategories.length }}개 선택됨 (2개 모두 선택하세요!)</p>
                                <div class="lawyer-category-checkbox-container">
                                    <div v-for="(category, index) in categoryList" :key="category.CATEGORY_NO" class="lawyer-category-checkbox-item">
                                        <input type="checkbox" 
                                               :id="'category' + category.CATEGORY_NO" 
                                               :value="category.CATEGORY_NO"
                                               v-model="selectedCategories"
                                               :disabled="selectedCategories.length >= 2 && !selectedCategories.includes(category.CATEGORY_NO)" />
                                        <label :for="'category' + category.CATEGORY_NO" 
                                               :class="{ 'lawyer-highlighted': selectedCategories.includes(category.CATEGORY_NO) }">
                                            {{ category.CATEGORY_NAME }}
                                        </label>
                                    </div>
                                </div>
                            </div>
    
                            <div class="info-box">
                                <h3>기타 자격 사항</h3>
                                <div v-if="license.length > 0" class="license-list">
                                    <div v-for="(item, index) in license" :key="index" class="license-card">
                                        <template v-if="item.isExisting">
                                            <img :src="item.licensePreview" class="license-img" />
                                            <div class="license-name">{{ item.licenseName }}</div>
                                            <button type="button" @click="removeExistingLicense(item, index)" class="lawyer-btn lawyer-btn-primary" style="margin-top: 10px;">삭제</button>
                                        </template>
                                        <template v-else>
                                            <input type="text" v-model="item.licenseName" placeholder="자격증 이름 입력" style="margin-bottom: 6px;" />
                                            <input type="file" accept="image/png, image/jpeg" @change="onFileChange($event, index)" />
                                            <img v-if="item.licensePreview" :src="item.licensePreview" class="license-img" />
                                        </template>
                                    </div>
                                </div>
                                <div v-else class="no-data">등록된 자격증이 없습니다.</div>
                                <div style="margin-top: 16px;">
                                    <button type="button" @click="addLicense" class="lawyer-btn lawyer-btn-primary">+ 자격 추가</button>
                                </div>
                            </div>
    
                            <div class="info-box">
                                <h3>대표 사건 선택</h3>
                                <p class="lawyer-board-note">{{ selectedBoards.length }}개 선택됨 (최대 3개)</p>
                                <table class="lawyer-case-table">
                                    <thead>
                                        <tr>
                                            <th>선택</th>
                                            <th>번호</th>
                                            <th>제목</th>
                                            <th>내용</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="board in safeBoardList" :key="board.boardNo">
                                            <td>
                                                <input type="checkbox" :value="board.boardNo"
                                                    v-model="selectedBoards"
                                                    :disabled="selectedBoards.length >= 3 && !selectedBoards.includes(board.boardNo)" />
                                            </td>
                                            <td>{{ board.boardNo }}</td>
                                            <td>{{ board.boardTitle }}</td>
                                            <td>{{ board.contents }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>
                    <div class="lawyer-mt-20 lawyer-flex-center">
                        <button type="button" @click="fnEdit" class="lawyer-btn">수정하기</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>
    
    
    </html>
    <script>
        let quillInfo, quillCareer, quillTask, quillEdu;

        const toolbarOptions = [
        ['bold', 'italic', 'underline', 'strike'],
        [{ 'header': 1 }, { 'header': 2 }],
        [{ 'color': [] }, { 'background': [] }],
        ['emoji'],
        ['clean']
        ];

        const lawEditApp = Vue.createApp({
            data() {
                return {
                    lawyerId : "${sessionId}",
                    info: {},
                    boardList: [],
                    license: [],
                    selectedBoards: [],
                    deletedLicenseIds: [],
                    categoryList: [],  
                    selectedCategories: [] 
                };
            },
            computed: {
                safeBoardList() {
                    return this.boardList.filter(item => item != null);
                }
            },
            methods: {
                fnGetLawyerInfo() {
                    const self = this;
                    $.ajax({
                        url: "/profile/info.dox",
                        type: "POST",
                        dataType: "json",
                        data: { lawyerId: self.lawyerId },
                        success(data) {
                            console.log("%c" +
"╔════════════════════════════╗\n" +
"║ 🐾✨ 마법사 고양이 등장! ✨🐾 ║\n" +
"╚════════════════════════════╝\n" +
"        /\\__/\\\n" +
"      (=｀ω´=)  🔮\n" +
"     /       \\  🧙‍♂️\n" +
"    (  )   (  )\n" +
"   (__(__)___)\n" +
"\n" +
"📦 박스 안에서 마법 준비 완료!\n" +
"💥 오늘도 냥펀치와 마법을 드립니다!", 
"color: hotpink; font-size: 16px; font-weight: bold; font-family: monospace");
                            // console.log(data.info);
                            self.info = data.info;
                            // Quill에 값 설정
                            quillInfo.root.innerHTML = self.info.lawyerInfo || '';
                            quillCareer.root.innerHTML = self.info.lawyerCareer || '';
                            quillTask.root.innerHTML = self.info.lawyerTask || '';
                            quillEdu.root.innerHTML = self.info.lawyerEdu || '';

                            self.boardList = (data.boardList || []).filter(item => item != null);
                            self.license = data.license.map(item => ({
                                ...item,
                                isExisting: true,
                                licenseFile: null,
                                licensePreview: item.licenseFilePath || null,
                                lawyerId: self.lawyerId
                            }));

                            // 대표 사건 선택 초기화
                            self.selectedBoards = [];
                            if (self.info.mainCase1No) self.selectedBoards.push(self.info.mainCase1No);
                            if (self.info.mainCase2No) self.selectedBoards.push(self.info.mainCase2No);
                            if (self.info.mainCase3No) self.selectedBoards.push(self.info.mainCase3No);

                            // LAWYER의 MAIN_CATEGORIES1, 2를 categoryList로 변환하여 선택된 값 세팅
                            self.selectedCategories = [self.info.mainCategories1, self.info.mainCategories2].filter(category => category !== null);
                            self.fnGetCategories();
                        }
                    });
                },
                fnEdit() {
                    const self = this;

                    // 전문분야 선택
                    if (self.selectedCategories.length < 2) {
                        swal.fire({
                            title: "전문 분야 선택 오류",
                            text: "전문 분야를 2개 모두 선택해야 합니다.",
                            icon: "warning",
                            confirmButtonText: "확인"
                        });
                        return;
                    }

                    self.info.mainCategories1 = self.selectedCategories[0] || null;
                    self.info.mainCategories2 = self.selectedCategories[1] || null;

                    // Quill 값 동기화
                    self.info.lawyerInfo = quillInfo.root.innerHTML;
                    self.info.lawyerCareer = quillCareer.root.innerHTML;
                    self.info.lawyerTask = quillTask.root.innerHTML;
                    self.info.lawyerEdu = quillEdu.root.innerHTML;

                    const formData = new FormData();
                    formData.append("lawyerId", self.lawyerId);
                    formData.append("info", JSON.stringify(self.info));
                    formData.append("selectedBoards", JSON.stringify(self.selectedBoards));
                    formData.append("deletedLicenseIds", JSON.stringify(self.deletedLicenseIds));
                    formData.append("selectedCategories", JSON.stringify(self.selectedCategories));

                    let count = 0;
                    let invalid = false;

                    self.license.forEach((item, i) => {
                        if (item.isExisting) return;
                        if (!item.licenseName || !item.licenseFile) {
                            swal.fire({
                                title: "자격증 입력 오류",
                                text: "자격증 항목의 이름과 파일을 확인하세요.",
                                icon: "warning",
                                confirmButtonText: "확인"
                            });
                            invalid = true;
                            return;
                        }

                        const nameKey = "licenseName_" + count;
                        const fileKey = "licenseFile_" + count;

                        formData.append(nameKey, item.licenseName.trim());
                        formData.append(fileKey, item.licenseFile);
                        count++;
                    });

                    if (invalid) return;

                    formData.append("licenseCount", count);

                    $.ajax({
                        url: "/profile/lawyerEdit.dox",
                        type: "POST",
                        data: formData,
                        contentType: false,
                        processData: false,
                        success(data) {
                            if (data.result === "success") {
                                swal.fire({
                                    title: "변호사 프로필이 성공적으로 수정되었습니다!",
                                    icon: "success",
                                    confirmButtonText: "확인"
                                }).then(() => {
                                    self.deletedLicenseIds = [];
                                    location.href = "/common/main.do";
                                });
                            } else {
                                swal.fire({
                                    title: "프로필 수정 중 오류가 발생했습니다.",
                                    icon: "error",
                                    confirmButtonText: "확인"
                                });
                            }
                        },
                        error(err) {
                            console.error(err);
                            swal.fire({
                                title: "서버와의 통신 중 오류가 발생했습니다.",
                                icon: "error",
                                confirmButtonText: "확인"
                            });
                        }
                    });
                },
                addLicense() {
                    this.license.push({
                        licenseName: '',
                        isExisting: false,
                        licenseFile: null,
                        licensePreview: null
                    });
                },
                removeExistingLicense(item, index) {
                    swal.fire({
                        title: "정말 삭제하시겠습니까?",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "삭제",
                        cancelButtonText: "취소",
                        reverseButtons: true
                    }).then((result) => {
                        if (result.isConfirmed) {
                            this.deletedLicenseIds.push({
                                licenseName: item.licenseName,
                                lawyerId: item.lawyerId
                            });
                            this.license.splice(index, 1);
                            swal.fire({
                                title: "자격증이 삭제되었습니다.",
                                icon: "success",
                                confirmButtonText: "확인"
                            });
                        }
                    });
                },
                onFileChange(event, index) {
                    const file = event.target.files[0];
                    if (file && (file.type === "image/jpeg" || file.type === "image/png")) {
                        if (file.size > 5 * 1024 * 1024) {
                            swal.fire({
                                title: "파일 크기 오류",
                                text: "5MB 이하의 파일만 업로드 가능합니다.",
                                icon: "warning",
                                confirmButtonText: "확인"
                            });
                            return;
                        }

                        if (this.license[index].licensePreview) {
                            URL.revokeObjectURL(this.license[index].licensePreview);
                        }

                        this.license[index].licenseFile = file;
                        this.license[index].licensePreview = URL.createObjectURL(file);
                    } else {
                        swal.fire({
                            title: "파일 형식 오류",
                            text: "JPG 또는 PNG 파일만 업로드 가능합니다.",
                            icon: "warning",
                            confirmButtonText: "확인"
                        });
                        event.target.value = '';
                        this.license[index].licenseFile = null;
                        this.license[index].licensePreview = null;
                    }
                },
                fnGetCategories() {
                    const self = this;
                    $.ajax({
                        url: "/profile/getCategories.dox", 
                        type: "GET",
                        dataType: "json",
                        success(data) {
                            self.categoryList = data.categories || [];
                        }
                    });
                },                
            }, // 메소드 영역 끝
            mounted() {
                // if (!this.lawyerId || this.lawyerId === "") {
                //     alert("로그인이 필요합니다.");
                //     location.href = "/user/login.do"; 
                //     return;
                // } 🚨 로그인 없이 접근 불가. 마지막에 추가할것!!! 🚨
                const self = this;

                self.fnGetLawyerInfo();
                self.fnGetCategories();

                self.$nextTick(function () {
                    // Quill 에디터 초기화
                    quillInfo   = new Quill('#editor-info',   { theme: 'snow', modules: { toolbar: toolbarOptions, 'emoji-toolbar': true } });
                    quillCareer = new Quill('#editor-career', { theme: 'snow', modules: { toolbar: toolbarOptions, 'emoji-toolbar': true } });
                    quillTask   = new Quill('#editor-task',   { theme: 'snow', modules: { toolbar: toolbarOptions, 'emoji-toolbar': true } });
                    quillEdu    = new Quill('#editor-edu',    { theme: 'snow', modules: { toolbar: toolbarOptions, 'emoji-toolbar': true } });

                    // emoji palette body로 이동
                    setTimeout(function () {
                        const palette = document.getElementById('emoji-palette');
                        if (palette) {
                            document.body.appendChild(palette);
                            palette.style.position = 'fixed';
                            palette.style.zIndex = '99999';
                            palette.style.display = 'none';
                        }
                    }, 300);

                    // 이모지 버튼 클릭 시 위치 조정 및 보이기
                    document.querySelectorAll('.ql-emoji').forEach(function (btn) {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();

                            setTimeout(function () {
                                const palette = document.getElementById('emoji-palette');
                                if (!palette) return;

                                const rect = btn.getBoundingClientRect();

                                palette.style.top = (rect.bottom + 8) + 'px';
                                palette.style.left = (rect.left - 0) + 'px';
                                palette.style.display = 'block';
                            }, 100);
                        });
                    });

                    // 외부 클릭 시 palette 숨기기
                    document.addEventListener('click', function (e) {
                        const palette = document.getElementById('emoji-palette');
                        if (!palette) return;

                        if (!palette.contains(e.target) && !e.target.closest('.ql-emoji')) {
                            palette.style.display = 'none';
                        }
                    });
                });
            }
        });
        lawEditApp.mount('#lawEditApp');
    </script>