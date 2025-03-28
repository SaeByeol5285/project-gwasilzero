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
      background-color: #ffffff;
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
      background-color: #ff7043;
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
  </style>
</head>
<body>
  <div id="app">
    <div class="chat-wrapper">
      <div id="chatBox">
        <div
          v-for="(msg, index) in messages"
          :key="index"
          class="bubble-container"
          :style="{ justifyContent: msg.senderId === senderId ? 'flex-end' : 'flex-start' }"
        >
          <div class="bubble">
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
        <input type="text" v-model="message" placeholder="메시지를 입력하세요..." />
        <input type="file" id="chatFile" multiple @change="handleFileChange" />
        <button @click="handleSend">전송</button>
      </div>
    </div>
  </div>

  <script>
  const app = Vue.createApp({
    data() {
      return {
        senderId: "${sessionScope.sessionId}",
        chatNo: 1,
        stompClient: null,
        message: "",
        files: [],
        messages: []
      };
    },
    methods: {
      connect() {
        const socket = new SockJS('/ws-chat');
        this.stompClient = Stomp.over(socket);
        this.stompClient.connect({}, (frame) => {
          console.log("WebSocket 연결 성공");
          this.stompClient.subscribe('/topic/public', (message) => {
            this.showMessage(JSON.parse(message.body));
          });
        }, (error) => {
          console.error("WebSocket 연결 실패", error);
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
          senderName: msg.senderName,
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
	          if (item.message) {
	            this.messages.push({
	              type: "text",
	              senderId: item.senderId,
	              senderName: item.senderName,
	              message: item.message,
	              filePath: null
	            });
	          } else if (item.chatFilePath) {
	            this.messages.push({
	              type: "file",
	              senderId: item.senderId,
	              senderName: item.senderName,
	              message: null,
	              filePath: item.chatFilePath
	            });
	          }
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
	  }

    },
    mounted() {
      this.connect();
      this.loadChatHistory();
    }
  });

  app.mount("#app");
  </script>
</body>
</html>
