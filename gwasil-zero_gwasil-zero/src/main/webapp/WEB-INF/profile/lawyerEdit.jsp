<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>sample.jsp</title>
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
    
        textarea, input[type="text"] {
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
                            <div v-for="item in license">
                                <textarea v-model="item.licenseName" rows="2"></textarea>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>대표 사건 사례<br>(최대 3개)</th>
                        <td>
                            <p style="font-size: 12px; color: #888;">
                                {{ selectedFiles.length }}개 선택됨 (최대 3개까지)
                            </p>
                            <table class="case-table">
                                <tr>
                                    <th style="width: 50px;">선택</th>
                                    <th>게시판 번호</th>
                                    <th>게시판 제목</th>
                                    <th>실제 파일명</th>
                                </tr>
                                <tr v-for="file in fileList" :key="file.boardNo">
                                    <td>
                                        <input
                                            type="checkbox"
                                            :value="file.boardNo + '-' + file.fileName"
                                            v-model="selectedFiles"
                                            :disabled="selectedFiles.length >= 3 && !selectedFiles.includes(file.boardNo + '-' + file.fileName)"
                                        />
                                    </td>
                                    <td>{{ file.boardNo }}</td>
                                    <td>{{ file.boardTitle }}</td>
                                    <td>{{ file.fileName }}</td>
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
                fileList : [],
                license : [],
                selectedFiles: []
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
                        console.log(data.fileList);
                        self.info = data.info;
                        self.fileList = data.fileList;
                        self.license = data.license;
					}
				});
            },
            fnEdit: function(){
                var self = this;
                var nparmap = {
                    ...self.info,
                    lawyerId: self.lawyerId,
                    licenseList: self.license,
                    selectedFiles: self.selectedFiles
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
            }
        },
        mounted() {
            var self = this;
			self.fnGetLawyerInfo();
        }
    });
    lawEditApp.mount('#lawEditApp');
</script>
​