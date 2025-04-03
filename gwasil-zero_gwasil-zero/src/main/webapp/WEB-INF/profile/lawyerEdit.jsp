<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/profileEdit.css" />
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" />
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <title>프로필 수정</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawEditApp">
            <div class="layout">
                <div class="content">
                    <div class="title-area">
                        <h2>변호사 프로필 수정</h2>
                    </div>
                    <div class="profile-container">
                        <form id="lawyerEditForm" @submit.prevent>
                            <table class="profile-table">
                                <tr>
                                    <th>소개</th>
                                    <td>
                                        <div id="editor-info" class="quill-editor"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>경력</th>
                                    <td>
                                        <div id="editor-career" class="quill-editor"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주요 업무 사례</th>
                                    <td>
                                        <div id="editor-task" class="quill-editor"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>학력</th>
                                    <td>
                                        <div id="editor-edu" class="quill-editor"></div>
                                    </td>
                                </tr>

                                <!-- 자격증 -->
                                <tr>
                                    <th>자격 취득</th>
                                    <td>
                                        <div v-if="license.length > 0">
                                            <div v-for="(item, index) in license" :key="index" class="license-item">
                                                <template v-if="item.isExisting">
                                                    <input type="text" v-model="item.licenseName" class="readonly-input" readonly />
                                                    <span class="badge-existing">(등록됨)</span>
                                                    <img v-if="item.licensePreview" :src="item.licensePreview" alt="자격증 이미지" class="preview-img" />
                                                    <button type="button" @click="removeExistingLicense(item, index)" class="delete-license-btn">삭제</button>
                                                </template>
                                                <template v-else>
                                                    <input type="text" v-model="item.licenseName" placeholder="자격증 이름 입력" />
                                                    <input type="file" accept="image/png, image/jpeg" @change="onFileChange($event, index)" />
                                                    <img v-if="item.licensePreview" :src="item.licensePreview" class="preview-img" />
                                                </template>
                                            </div>
                                        </div>
                                        <div v-else class="no-data">등록된 자격증이 없습니다.</div>
                                        <div style="margin-top: 10px;">
                                            <button type="button" @click="addLicense" class="add-license-btn">+ 자격 추가</button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 대표 사건 -->
                                <tr>
                                    <th>대표 사건 사례</th>
                                    <td>
                                        <p class="board-note">{{ selectedBoards.length }}개 선택됨 (최대 3개)</p>
                                        <table class="case-table">
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
                                                        <input type="checkbox" :value="board.boardNo" v-model="selectedBoards"
                                                            :disabled="selectedBoards.length >= 3 && !selectedBoards.includes(board.boardNo)" />
                                                    </td>
                                                    <td>{{ board.boardNo }}</td>
                                                    <td>{{ board.boardTitle }}</td>
                                                    <td>{{ board.contents }}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>

                            <div class="mt-20 flex-center">
                                <button type="button" @click="fnEdit" class="add-license-btn">수정하기</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const lawEditApp = Vue.createApp({
            data() {
                return {
                    // lawyerId : "${sessionId}",
                    lawyerId : "lawyer_2",
                    info: {},
                    boardList: [],
                    license: [],
                    selectedBoards: [],
                    deletedLicenseIds: []
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
                            // console.log(data.boardList);
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
                        }
                    });
                },
                fnEdit() {
                    const self = this;

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
                    formData.append("deletedLicenseIds", JSON.stringify(self.deletedLicenseIds));

                    let count = 0;
                    self.license.forEach((item, i) => {
                        if (item.isExisting) return;
                        if (!item.licenseName || !item.licenseFile) {
                            alert(`${i + 1}번째 신규 자격증 항목이 누락되었습니다.`);
                            return;
                        }

                        const nameKey = "licenseName_" + count;
                        const fileKey = "licenseFile_" + count;

                        formData.append(nameKey, item.licenseName.trim());
                        formData.append(fileKey, item.licenseFile);
                        // console.log("🧪", nameKey, ":", item.licenseName);
                        // console.log("🧪", fileKey, ":", item.licenseFile.name);
                        count++;
                    });
                    formData.append("licenseCount", count);
                    // DEBUG 로그
                    // console.log("🧾 삭제 예정 리스트:", self.deletedLicenseIds);
                    // for (let pair of formData.entries()) {
                    //     console.log("📦", pair[0], pair[1]);
                    // }

                    $.ajax({
                        url: "/profile/lawyerEdit.dox",
                        type: "POST",
                        data: formData,
                        contentType: false,
                        processData: false,
                        success(data) {
                            if (data.result === "success") {
                                alert("수정되었습니다.");
                                self.deletedLicenseIds = [];
                                location.href = "/common/main.do"
                            } else {
                                alert("수정에 실패했습니다.");
                                // console.log("🚨 서버 응답 실패:", data);
                            }
                        },
                        error(err) {
                            alert("서버 오류 발생!");
                            console.error(err);
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
                    if (confirm("해당 자격증을 삭제하시겠습니까?")) {
                        this.deletedLicenseIds.push({
                            licenseName: item.licenseName,
                            lawyerId: item.lawyerId
                        });
                        this.license.splice(index, 1);
                    }
                },
                onFileChange(event, index) {
                    const file = event.target.files[0];
                    if (file && (file.type === "image/jpeg" || file.type === "image/png")) {
                        if (file.size > 5 * 1024 * 1024) {
                            alert("5MB 이하의 파일만 업로드 가능합니다.");
                            return;
                        }

                        if (this.license[index].licensePreview) {
                            URL.revokeObjectURL(this.license[index].licensePreview);
                        }

                        this.license[index].licenseFile = file;
                        this.license[index].licensePreview = URL.createObjectURL(file);
                    } else {
                        alert("JPG 또는 PNG 파일만 업로드 가능합니다.");
                        event.target.value = '';
                        this.license[index].licenseFile = null;
                        this.license[index].licensePreview = null;
                    }
                }
            },
            mounted() {
                // if (!this.lawyerId || this.lawyerId === "") {
                //     alert("로그인이 필요합니다.");
                //     location.href = "/user/login.do"; 
                //     return;
                // } 🚨 로그인 없이 접근 불가. 마지막에 추가할것!!! 🚨

                this.fnGetLawyerInfo();

                // Quill 초기화
                quillInfo = new Quill('#editor-info', { theme: 'snow' });
                quillCareer = new Quill('#editor-career', { theme: 'snow' });
                quillTask = new Quill('#editor-task', { theme: 'snow' });
                quillEdu = new Quill('#editor-edu', { theme: 'snow' });
            }
        });
        lawEditApp.mount('#lawEditApp');
    </script>