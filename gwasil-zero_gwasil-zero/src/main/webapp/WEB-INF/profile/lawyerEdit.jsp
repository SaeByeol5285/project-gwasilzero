<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <title>프로필 수정</title>
    <style>
        body {
            font-family: '맑은 고딕', sans-serif;
            background-color: #f0f0f0;
            padding: 40px;
        }

        .form-container {
            background-color: #ddd;
            padding: 30px;
            border-radius: 14px;
            width: 1000px;
            margin: 0 auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: none;
            padding: 10px;
            vertical-align: top;
        }

        th {
            background-color: #fdf5c9;
            width: 130px;
        }

        td {
            background-color: #ccf5f8;
        }

        textarea,
        input[type="text"] {
            width: 100%;
            padding: 6px;
            box-sizing: border-box;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .case-table {
            width: 100%;
            margin-top: 10px;
        }

        .case-table th {
            background-color: #fdd;
            text-align: left;
        }

        .case-table td {
            background-color: #eee;
        }

        .submit-btn {
            background-color: #fdfda8;
            border: none;
            padding: 12px 30px;
            font-size: 16px;
            border-radius: 10px;
            margin-top: 25px;
            cursor: pointer;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .license-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .license-note {
            font-size: 13px;
            color: #444;
            margin-bottom: 6px;
        }

        .add-license-btn {
            margin-top: 10px;
        }

        .board-note {
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div id="lawEditApp">
        <div class="form-container">
            <form id="lawyerEditForm" @submit.prevent>
                <table>
                    <tr>
                        <th>소개</th>
                        <td><textarea v-model="info.lawyerInfo" rows="3"></textarea></td>
                    </tr>
                    <tr>
                        <th>경력</th>
                        <td><textarea v-model="info.lawyerCareer" rows="3"></textarea></td>
                    </tr>
                    <tr>
                        <th>주요 업무 사례</th>
                        <td><textarea v-model="info.lawyerTask" rows="3"></textarea></td>
                    </tr>
                    <tr>
                        <th>학력</th>
                        <td><textarea v-model="info.lawyerEdu" rows="3"></textarea></td>
                    </tr>
                    <tr>
                        <th>자격 취득</th>
                        <td>
                            <p class="license-note">☑ 선택삭제</p>
                            <div
                                v-for="(item, index) in license"
                                :key="index"
                                class="license-item"
                                v-show="!item._delete"
                            >
                                <input type="checkbox" v-model="item._delete" />
                                <textarea v-model="item.licenseName" rows="2" placeholder="자격증 이름 입력"></textarea>

                                <!-- 이미지 첨부 -->
                                <input 
                                    type="file" 
                                    accept="image/png, image/jpeg" 
                                    @change="onFileChange($event, index)" 
                                    :required="!item.licenseFile"
                                />

                                <!-- 미리보기 -->
                                <div v-if="item.licensePreview">
                                    <img :src="item.licensePreview" alt="미리보기" style="width: 80px; height: auto; border: 1px solid #ccc;" />
                                </div>
                            </div>
                            <button type="button" @click="addLicense" class="add-license-btn">+ 자격 추가</button>
                        </td>
                    </tr>
                    <tr>
                        <th>대표 사건 사례<br>(최대 3개)</th>
                        <td>
                            <p class="board-note">{{ selectedBoards.length }}개 선택됨 (최대 3개까지)</p>
                            <table class="case-table">
                                <tr>
                                    <th style="width: 50px;">선택</th>
                                    <th>게시판 번호</th>
                                    <th>게시판 제목</th>
                                    <th>내용</th>
                                </tr>
                                <tr v-for="board in boardList" :key="board.boardNo">
                                    <td>
                                        <input
                                            type="checkbox"
                                            :value="board.boardNo"
                                            v-model="selectedBoards"
                                            :disabled="selectedBoards.length >= 3 && !selectedBoards.includes(board.boardNo)"
                                        />
                                    </td>
                                    <td>{{ board.boardNo }}</td>
                                    <td>{{ board.boardTitle }}</td>
                                    <td>{{ board.contents }}</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <button type="button" @click="fnEdit" class="submit-btn">수정하기</button>
            </form>
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
                lawyerId: "lawyer_2", // 실제 적용 시 세션에서 가져오기
                info: {},
                boardList: [],
                license: [],
                selectedBoards: []
            };
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
                        self.boardList = data.boardList;
                        self.license = data.license.map(item => ({
                            ...item,
                            _delete: false,
                            licenseFile: null,
                            licensePreview: item.licenseFilePath ? item.licenseFilePath : null
                        }));
                    }
                });
            },
            // fnEdit() {
            //     const self = this;

            //     const formData = new FormData();
            //     formData.append("lawyerId", self.lawyerId);
            //     formData.append("info", JSON.stringify(self.info));
            //     formData.append("selectedBoards", JSON.stringify(self.selectedBoards));

            //     let count = 0;

            //     for (let i = 0; i < self.license.length; i++) {
            //         const item = self.license[i];
                   
            //         if (item._delete) continue;
                    
            //         if (item.licenseFile) {
            //             if (!item.licenseName || !item.licenseName.trim()) {
            //                 alert(`${i + 1}번째 자격증 이름이 비어 있습니다.`);
            //                 return;
            //             }

            //             const nameKey = `licenseName_${count}`;
            //             const fileKey = `licenseFile_${count}`;
            //             formData.append(nameKey, item.licenseName);
            //             formData.append(fileKey, item.licenseFile);
            //             count++;
            //         }
            //     }
            //     formData.append("licenseCount", count);

            //     $.ajax({
            //         url: "/profile/lawyerEdit.dox",
            //         type: "POST",
            //         data: formData,
            //         contentType: false,
            //         processData: false,
            //         success(data) {
            //             if (data.result === "success") {
            //                 alert("수정되었습니다.");
            //                 // location.href = "/profile/innerLawyer.do";
            //             } else {
            //                 alert("수정에 실패했습니다.");
            //             }
            //         },
            //         error() {
            //             alert("서버 오류가 발생했습니다.");
            //         }
            //     });
            // },
            // addLicense() {
            //     this.license.push({
            //         licenseName: '',
            //         _delete: false,
            //         licenseFile: null,
            //         licensePreview: null
            //     });
            // },
            // onFileChange(event, index) {
            //     const file = event.target.files[0];
            //     if (file && (file.type === "image/jpeg" || file.type === "image/png")) {
            //         if (file.size > 5 * 1024 * 1024) {
            //             alert("5MB 이하의 파일만 업로드 가능합니다.");
            //             return;
            //         }

            //         // 이전 미리보기 URL 제거
            //         if (this.license[index].licensePreview) {
            //             URL.revokeObjectURL(this.license[index].licensePreview);
            //         }

            //         this.license[index].licenseFile = file;
            //         this.license[index].licensePreview = URL.createObjectURL(file);
            //     } else {
            //         alert("JPG 또는 PNG 파일만 업로드 가능합니다.");
            //         event.target.value = '';
            //         this.license[index].licenseFile = null;
            //         this.license[index].licensePreview = null;
            //     }
            // }
        },
        mounted() {
            this.fnGetLawyerInfo();
        }
    });
    lawEditApp.mount('#lawEditApp');
</script>
