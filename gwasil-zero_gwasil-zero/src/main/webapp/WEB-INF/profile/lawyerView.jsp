<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>변호사 상세보기</title>
    <style>
        body {
          font-family: '맑은 고딕', sans-serif;
          background-color: #f4f4f4;
          padding: 40px;
        }
    
        .profile-container {
          display: flex;
          background-color: #e8e8e8;
          padding: 30px;
          border-radius: 12px;
          max-width: 900px;
          margin: 0 auto;
        }
    
        .profile-photo {
          width: 200px;
          height: 200px;
          background-color: #f88;
          text-align: center;
          line-height: 200px;
          color: white;
          font-weight: bold;
          margin-right: 30px;
          border-radius: 8px;
          flex-shrink: 0;
        }
    
        .profile-info {
          flex: 1;
        }
    
        .section {
          margin-bottom: 20px;
        }
    
        .section h3 {
          margin-bottom: 8px;
          font-size: 18px;
          border-bottom: 1px solid #ccc;
          padding-bottom: 4px;
        }
    
        ul {
          margin: 0;
          padding-left: 20px;
        }
    
        .case-list {
          display: flex;
          gap: 20px;
          margin-top: 15px;
          flex-wrap: wrap;
        }
    
        .case-card {
          flex: 1;
          min-width: 180px;
          max-width: 220px;
          background-color: #fdd;
          border-radius: 8px;
          padding: 10px;
          text-align: center;
        }
    
        .case-title {
          font-weight: bold;
          margin-bottom: 10px;
        }
    
        .case-desc {
          background-color: #efe;
          padding: 10px;
          border-radius: 6px;
          font-size: 14px;
          min-height: 50px;
        }
      </style>
</head>
<body>
	<div id="lawInfoApp">
		<div class="profile-container">
            <div class="profile-photo">이미지없음</div>
                <div class="profile-info">
                    <div class="section">
                        <h3>이름</h3>
                        <ul>
                            <li>{{info.lawyerName}}</li>
                        </ul>
                    </div>
                    <div class="section">
                        <h3>소개</h3>
                        <ul>
                            <li>{{info.lawyerInfo}}</li>
                        </ul>
                    </div>
                    <div class="section">
                        <h3>경력</h3>
                        <ul>
                            <li>{{info.lawyerCareer}}</li>
                        </ul>
                    </div>
                    <div class="section">
                        <h3>주요 업무사례</h3>
                        <ul>
                            <li>{{info.lawyerTask}}</li>
                        </ul>
                    </div>
                    <div class="section">
                        <h3>학력</h3>
                        <ul>
                            <li>{{info.lawyerEdu}}</li>
                        </ul>
                    </div>
                    <div class="section">
                        <h3>자격 취득</h3>
                        <p v-for="item in license">{{item.licenseName}}</p>
                    </div>
                    <div class="section">
                        <h3>대표 사건 목록</h3>
                        <div class="case-list">
                            <div class="case-card" v-for="file in boardFileList">
                                <div class="case-desc"> {{file.fileName}}</div>
                                <div class="case-title">{{file.boardTitle}}</div>
                            </div>
                        </div>    
                    </div>
                </div>
            </div>
        </div>
	</div>
</body>
</html>
<script>
    const lawInfoApp = Vue.createApp({
        data() {
            return {
                lawyerId : "${map.lawyerId}",
				info : {},
                sessionId : "${sessionId}",
                boardFileList : [],
                license : []
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
                        // console.log(data.boardFileList);
                        self.info = data.info;
                        self.boardFileList = data.boardFileList;
                        self.license = data.license;
					}
				});
            }
        },
        mounted() {
            var self = this;
			self.fnGetLawyerInfo();
        }
    });
    lawInfoApp.mount('#lawInfoApp');
</script>
​