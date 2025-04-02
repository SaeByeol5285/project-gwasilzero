<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
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
            margin-bottom: 8px;
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
	<div id="lawEditApp">
		<div class="form-container">
            <form id="lawyerEditForm">
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
                            >
                                <input type="checkbox" v-model="item._delete" />
                                <textarea v-model="item.licenseName" rows="2"></textarea>
                            </div>
                            <button type="button" @click="addLicense" class="add-license-btn">+ 자격 추가</button>
                        </td>
                    </tr>
                    <tr>
                        <th>대표 사건 사례<br>(최대 3개)</th>
                        <td>
                            <p class="board-note">
                                {{ selectedBoards.length }}개 선택됨 (최대 3개까지)
                            </p>
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
</body>
</html>
<script>
    const lawEditApp = Vue.createApp({
        data() {
            return {
				// lawyerId : "${sessionId}",
                lawyerId : "lawyer_2",
				info : {},
                boardList : [],
                license : [],
                selectedBoards: []
            };
        },
        methods: {
            fnGetLawyerInfo(){
				var self = this;
				var nparmap = {
                    lawyerId : self.lawyerId
                };
				$.ajax({
					url:"/profile/info.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
                        console.log(data.boardList);
                        self.info = data.info;
                        self.boardList = data.boardList;
                        self.license = data.license;
					}
				});
            },
            fnEdit: function(){
                var self = this;
                // 1. 삭제 체크 안 된 항목만
                // 2. licenseName이 비어있지 않은 항목만
                var filteredLicense = self.license.filter(item => {
                    return !item._delete && item.licenseName && item.licenseName.trim() !== '';
                });

                // board 번호 숫자로 변환
                self.selectedBoards = self.selectedBoards.map(b => Number(b));
                var nparmap = {
                    ...self.info,
                    lawyerId: self.lawyerId,
                    licenseList: filteredLicense,
                    selectedBoards: self.selectedBoards
                };
				$.ajax({
                    url: "/profile/lawyerEdit.dox",
                    type: "POST",
                    data: JSON.stringify(nparmap), // JSON으로 변환
                    contentType: "application/json;charset=UTF-8",
                    success: function(data) {
                        alert("수정되었습니다");
                        location.href = "/profile/innerLawyer.do";
                    }
				});
                // console.log("전송할 licenseList:", self.license);
                // console.log("전송할 전체 데이터:", nparmap);
            },
            addLicense() {
                this.license.push({ licenseName: '', _delete: false });
            },
        },
        mounted() {
            var self = this;
			self.fnGetLawyerInfo();
        }
    });
    lawEditApp.mount('#lawEditApp');
</script>
​