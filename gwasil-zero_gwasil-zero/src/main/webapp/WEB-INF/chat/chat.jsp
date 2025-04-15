<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>채팅</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://unpkg.com/vue@3.3.4/dist/vue.global.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
          <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
		  <link rel="icon" type="image/png" href="/img/common/logo3.png">
		        <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      height: 100vh;
    }

    .chat-wrapper {
      width: 80%;
      max-width: 800px;
      margin: 0 auto;
      flex: 1;
      display: flex;
      flex-direction: column;
      padding: 10px;
      box-sizing: border-box;
    }

    #chatBox {
      height: 70vh;
      overflow-y: auto;
      border: 1px solid #ccc;
      border-radius: 10px;
      padding: 15px;
      background-color: #eee;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
      margin-bottom: 15px;
    }

    .input-area {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 10px;
    }

    input[type="text"],
    input[type="file"] {
      padding: 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    input[type="text"] {
      flex: 1;
      min-width: 60%;
    }

    button {
      padding: 10px 18px;
      font-size: 14px;
      background-color: #FF8A65;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }

    button:hover {
		background-color: #ffe6db;
			color: #ff5c00;
    }

    .bubble-container {
      display: flex;
      justify-content: flex-start;
      margin: 10px 0;
    }

    .bubble {
      max-width: 40%;
      background-color: #FFAB91;
      color: #333;
      border-radius: 12px;
      padding: 10px 14px;
      font-size: 14px;
      line-height: 1.5;
      word-wrap: break-word;
      box-shadow: 0 2px 5px rgba(0,0,0,0.08);
    }

    .bubble img,
    .bubble video {
      max-width: 100%;
      max-height: 200px;
      margin-top: 8px;
      border-radius: 8px;
    }

    .sender-name {
      font-weight: bold;
      margin-bottom: 6px;
      display: block;
    }
	.section-subtitle {
		font-size: 28px;
		font-weight: bold;
		margin-bottom: 30px;
		text-align: center;
		color: #222;
		position: relative;
		display: inline-block;
		padding-top: 40px;
		padding-bottom: 10px;
		display: block;
		text-align: center;
		margin-left: auto;
		margin-right: auto;
	}
	
	.section-subtitle::after {
		content: "";
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
		bottom: 0;
		width: 150px;
		height: 3px;
		background-color: var(--main-color);
		border-radius: 2px;
	}
	.chat-notice {
	  background-color: #888; /* 회색 배경 */
	  color: #fff;            /* 흰색 글씨 */
	  font-size: 14px;
	  text-align: center;
	  padding: 12px 20px;
	  border-radius: 8px;
	  margin: 10px auto 30px auto;
	  max-width: 800px;
	  line-height: 1.6;
	}
	.bubble.me {
	  background-color: #fdc4b3; /* 내 메시지는 주황 */
	  color: #333;
	}

	.bubble.other {
	  background-color: #FFFFFF; 
	  color: #333;
	}

	.sender-name {
	  font-weight: bold;
	  font-size: 15px;
	  color: #000;
	  margin-bottom: 6px;
	  display: block;
	}
  </style>
</head>
<body>
	<jsp:include page="../common/header.jsp"/>
  <div id="app">
	<h2 class="section-subtitle">
	  {{ targetName }}{{ sessionType === 'user' ? ' 변호사' : '' }} 님과의 채팅
	</h2>
	
	<div class="chat-notice">
	  이 채팅은 <strong>본격적인 상담 전</strong> 간단한 <strong>사고 설명</strong>과 <strong>상담 일정 조율</strong>을 위한 용도로 제공됩니다. <br>
	  개인정보나 중요한 서류는 정식 상담 시작 후에 공유해주세요.
	</div>
	
    <div class="chat-wrapper">
      <div id="chatBox">
        <div
          v-for="(msg, index) in messages"
          :key="index"
          class="bubble-container"
          :style="{ justifyContent: msg.senderId === senderId ? 'flex-end' : 'flex-start' }"
        >
		<div
		  class="bubble"
		  :class="msg.senderId === senderId ? 'me' : 'other'"
		>
            <span class="sender-name">{{ msg.senderName }}</span>
            <span v-if="msg.type === 'text'">{{ msg.message }}</span>
            <img v-if="msg.type === 'file' && isImage(msg.filePath)" :src="msg.filePath" />
            <video v-if="msg.type === 'file' && isVideo(msg.filePath)" controls>
              <source :src="msg.filePath" type="video/mp4" />
            </video>
            <span v-if="msg.type === 'file' && !isImage(msg.filePath) && !isVideo(msg.filePath)">
              [파일] <a :href="msg.filePath" target="_blank">{{ msg.filePath }}</a>
            </span>
          </div>
        </div>
      </div>

      <div class="input-area">
        <input type="text" v-model="message" placeholder="채팅을 입력하세요..." @keyup.enter="handleSend"/>
        <input type="file" id="chatFile" multiple @change="handleFileChange" />
        <button @click="handleSend">전송</button>
		<button v-if="reviewNo > 0" @click="openReviewModal">리뷰 남기기</button>
      </div>
    </div>
  </div>
  <jsp:include page="../common/footer.jsp"/>
  <script>
  const app = Vue.createApp({
    data() {
      return {
        senderId: "${sessionScope.sessionId}",
        chatNo: Number("${param.chatNo}"),
        stompClient: null,
        message: "",
        files: [],
        messages: [],
		targetName : "",
		sessionType : "${role}",
		reviewNo : 0
      };
    },
    methods: {
      connect() {
        const socket = new SockJS('/ws-chat');
        this.stompClient = Stomp.over(socket);
        this.stompClient.connect({}, (frame) => {
		  
		  //chatNo로 연결
		  this.stompClient.subscribe('/topic/chat/' + this.chatNo, (message) => {
		        this.showMessage(JSON.parse(message.body));
		      });
        }, (error) => {
        });
      },
	  handleSend() {
	    const trimmedMsg = this.message.trim();

	    if (trimmedMsg) {
	      const chatTextMsg = {
	        type: "text",
	        payload: {
	          chatNo: this.chatNo,
	          senderId: this.senderId,
	          message: trimmedMsg
	        }
	      };
	      this.stompClient.send("/app/sendMessage", {}, JSON.stringify(chatTextMsg));

	      // 바로 표시
	      /*this.showMessage({
	        type: "text",
	        payload: {
	          senderId: this.senderId,
	          senderName: "나", // 혹은 본인 이름 변수 있으면 그걸 사용
	          message: trimmedMsg
	        }
	      });*/

	      this.message = "";
	    }

	    if (this.files.length > 0) {
	      const formData = new FormData();
	      this.files.forEach(file => formData.append("files", file));
	      formData.append("chatNo", this.chatNo);
	      formData.append("senderId", this.senderId);

	      $.ajax({
	        url: "/chat/uploadFiles",
	        type: "POST",
	        data: formData,
	        processData: false,
	        contentType: false,
	        success: (filePaths) => {
	          filePaths.forEach(path => {
	            const chatFileMsg = {
	              type: "file",
	              payload: {
	                chatNo: this.chatNo,
	                senderId: this.senderId,
	                chatFilePath: path
	              }
	            };
	            this.stompClient.send("/app/sendMessage", {}, JSON.stringify(chatFileMsg));

	            // 바로 표시
	            this.showMessage({
	              type: "file",
	              payload: {
	                senderId: this.senderId,
	                senderName: "나", // 마찬가지로 실제 이름 가능
	                chatFilePath: path
	              }
	            });
	          });
	          this.files = [];
	          document.getElementById("chatFile").value = "";
	        }
	      });
	    }

	    if (!trimmedMsg && this.files.length === 0) {
	      alert("메시지를 입력하거나 파일을 첨부하세요.");
	    }
	  },
      handleFileChange(event) {
        this.files = Array.from(event.target.files);
      },
      isImage(path) {
        return /\.(jpg|jpeg|png|gif|jfif)$/i.test(path);
      },
      isVideo(path) {
        return /\.(mp4|mov|avi)$/i.test(path);
      },
	  showMessage(message) {
	    const msg = message.payload;
	    this.messages.push({
	      type: message.type,
	      senderId: msg.senderId,
		  senderName:
		      msg.senderId === this.senderId
		        ? "나"
		        : (this.sessionType === "user" ? msg.senderName + " 변호사" : msg.senderName),
	      message: msg.message,
	      filePath: msg.chatFilePath
	    });
	    this.scrollToBottom();
	  },
      scrollToBottom() {
        this.$nextTick(() => {
          const chatBox = document.getElementById("chatBox");
          if (chatBox) {
            chatBox.scrollTop = chatBox.scrollHeight;
          }
        });
      },
	  loadChatHistory() {
	    $.ajax({
	      url: "/chat/history.dox",
	      type: "POST",
	      data: { chatNo: this.chatNo },
	      success: (data) => {
	        this.messages = [];

	        data.history.forEach(item => {
	          const isMe = item.senderId === this.senderId;
	          const baseMessage = {
	            type: item.message ? "text" : "file",
	            senderId: item.senderId,
	            senderName: isMe ? "나" : (this.sessionType === "user" ? item.senderName + " 변호사" : item.senderName),
	            message: item.message || null,
	            filePath: item.chatFilePath || null
	          };

	          this.messages.push(baseMessage);
	        });

	        this.$nextTick(() => {
	          setTimeout(() => {
	            const chatBox = document.getElementById("chatBox");
	            if (chatBox) {
	              chatBox.scrollTop = chatBox.scrollHeight;
	            }
	          }, 100);
	        });
	      }
	    });
	  },
	 	getTargetName(){
			$.ajax({
		      url: "/chat/getTargetName.dox",
		      type: "POST",
		      data: { 
				chatNo: this.chatNo,
				senderId : this.senderId
			  },
		      success: (data) => {
		        this.targetName = data.targetName;
		      }
		    });
		},
		getIsEnd() {
		  $.ajax({
		    url: "/chat/getIsEnd.dox",
		    type: "POST",
		    data: {
		      chatNo: this.chatNo
		    },
		    success: (data) => {
		      if (data.result === "success") {
		        this.reviewNo = data.reviewNo;
		      }
		    }
		  });
		},
		openReviewModal() {
		  const self = this;

		  Swal.fire({
		    title: '리뷰 작성',
		    html: `
		      <textarea id="reviewText" 
		                class="swal2-textarea" 
		                placeholder="리뷰 내용을 입력하세요"
		                style="width:100%; height: 150px;"></textarea>
		      <br>
		      <div style="text-align:center; margin-top:10px;">
		        <label><input type="radio" name="score" value="0"> 0점</label>&nbsp;
		        <label><input type="radio" name="score" value="1"> 1점</label>&nbsp;
		        <label><input type="radio" name="score" value="2"> 2점</label>&nbsp;
		        <label><input type="radio" name="score" value="3"> 3점</label>&nbsp;
		        <label><input type="radio" name="score" value="4"> 4점</label>&nbsp;
		        <label><input type="radio" name="score" value="5" checked> 5점</label>
		      </div>
		    `,
		    showCancelButton: true,
		    confirmButtonText: '등록하기',
		    cancelButtonText: '취소',
		    confirmButtonColor: '#28a745',
		    preConfirm: () => {
		      const content = document.getElementById('reviewText').value.trim();
		      const score = document.querySelector('input[name="score"]:checked')?.value;

		      if (!content) {
		        Swal.showValidationMessage("리뷰 내용을 입력해주세요.");
		        return false;
		      }

		      if (score === null || score === undefined) {
		        Swal.showValidationMessage("별점을 선택해주세요.");
		        return false;
		      }

		      return { contents: content, score: parseInt(score) };
		    }
		  }).then(result => {
		    if (result.isConfirmed) {
		      const { contents, score } = result.value;

		      $.ajax({
		        url: '/chat/reviewUpdate.dox',
		        type: 'POST',
		        data: {
		          chatNo: self.chatNo,
		          contents: contents,
		          score: score
		        },
		        success: (res) => {
		          if (res.result === 'success') {
		            Swal.fire("등록 완료", "리뷰가 등록되었습니다.", "success");
		          } else {
		            Swal.fire("오류", "리뷰 등록에 실패했습니다.", "error");
		          }
		        },
		        error: () => {
		          Swal.fire("서버 오류", "통신에 실패했습니다.", "error");
		        }
		      });
		    }
		  });
		}



    },
    mounted() {
      	this.connect();
      	this.loadChatHistory();
	 	 this.getTargetName();
	 	this.getIsEnd();
    }
  });

  app.mount("#app");
  </script>
</body>
</html>
