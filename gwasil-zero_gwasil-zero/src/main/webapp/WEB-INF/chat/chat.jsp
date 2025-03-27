<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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

	    h2 {
	        text-align: center;
	        margin: 20px 0 10px;
	        color: #333;
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
	        flex: 1;
	        border: 1px solid #ccc;
	        border-radius: 10px;
	        padding: 15px;
	        overflow-y: auto;
	        background-color: #ffffff;
	        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	        margin-bottom: 15px;
	    }

	    .input-area {
	        display: flex;
	        flex-wrap: wrap;
	        justify-content: center;
	        gap: 10px;
	        margin-bottom: 20px;
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
	        transition: background-color 0.2s ease-in-out;
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
	        position: relative;
	        font-size: 14px;
	        line-height: 1.5;
	        box-shadow: 0 2px 5px rgba(0,0,0,0.08);
	        word-wrap: break-word;
	    }

	    .bubble::after {
	        content: "";
	        position: absolute;
	        top: 10px;
	        left: -8px;
	        width: 0;
	        height: 0;
	        border: 8px solid transparent;
	        border-right-color: #FFAB91;
	    }

	    .bubble img,
	    .bubble video {
	        max-width: 100%;
	        max-height: 200px;
	        width: auto;
	        height: auto;
	        border-radius: 8px;
	        margin-top: 8px;
	        object-fit: contain;
	    }

	    .sender-name {
	        font-weight: bold;
	        margin-bottom: 6px;
	        display: block;
	    }
	</style>
</head>
<body>
	<h2 id="chatTitle">사용자1님과의 채팅</h2>
	<div class="chat-wrapper">
	    <div id="chatBox"></div>

	    <div class="input-area">
	        <input type="text" id="message" placeholder="메시지를 입력하세요..." />
	        <input type="file" id="chatFile" multiple />
	        <button onclick="handleSend()">전송</button>
	    </div>
	</div>
    <script>
        let stompClient = null;
		const chatNo = 1;
		const senderId = "user_1";
        // WebSocket 연결 함수
        function connect() {
            let socket = new SockJS('/ws-chat'); // WebSocket 엔드포인트
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
                console.log("WebSocket 연결 성공: " + frame);

                // 서버에서 메시지를 받을 구독 설정
                stompClient.subscribe('/topic/public', function (message) {
                    showMessage(JSON.parse(message.body));
                });
            }, function (error) {
                console.error("WebSocket 연결 실패: ", error);
            });
        }

		function handleSend() {
		    const message = document.getElementById("message").value.trim();
		    const fileInput = document.getElementById("chatFile");
		    const files = fileInput.files;

		    if (message) {
		        const chatTextMsg = {
		            type: "text",
		            payload: {
		                chatNo: chatNo,
		                senderId: senderId,
		                message: message
		            }
		        };
		        stompClient.send("/app/sendMessage", {}, JSON.stringify(chatTextMsg));
		        document.getElementById("message").value = "";
		    }

		    if (files.length > 0) {
		        const formData = new FormData();
		        for (let i = 0; i < files.length; i++) {
		            formData.append("files", files[i]);
		        }
		        formData.append("chatNo", chatNo);
		        formData.append("senderId", senderId);

		        $.ajax({
		            url: "/chat/uploadFiles",
		            type: "POST",
		            data: formData,
		            processData: false,
		            contentType: false,
		            success: function(filePaths) {
		                filePaths.forEach(path => {
		                    const chatFileMsg = {
		                        type: "file",
		                        payload: {
		                            chatNo: chatNo,
		                            senderId: senderId,
		                            chatFilePath: path
		                        }
		                    };
		                    stompClient.send("/app/sendMessage", {}, JSON.stringify(chatFileMsg));
		                });
		                fileInput.value = "";
		            }
		        });
		    }

		    if (!message && files.length === 0) {
		        alert("메시지를 입력하거나 파일을 첨부하세요.");
		    }
		}


        // 메시지 출력 함수
		function showMessage(message) {
		    const chatBox = document.getElementById("chatBox");
		    const msg = message.payload;

		    const container = document.createElement("div");
		    container.className = "bubble-container";

		    const bubble = document.createElement("div");
		    bubble.className = "bubble";

		    let content = "<span class='sender-name'>" + msg.senderName + "</span>";

		    if (message.type === "text") {
		        content += "<span>" + msg.message + "</span>";
		    } else if (message.type === "file") {
		        const ext = msg.chatFilePath.split('.').pop().toLowerCase();

		        if (["jpg", "jpeg", "png", "gif", "jfif"].includes(ext)) {
		            content += "<img src='" + msg.chatFilePath + "'>";
		        } else if (["mp4", "mov", "avi"].includes(ext)) {
		            content += `<video controls>
		                            <source src="${msg.chatFilePath}" type="video/mp4">
		                            브라우저가 video 태그를 지원하지 않습니다.
		                        </video>`;
		        } else {
		            content += "<span>[파일 링크] <a href='" + msg.chatFilePath + "' target='_blank'>" + msg.chatFilePath + "</a></span>";
		        }
		    }

		    bubble.innerHTML = content;
		    container.appendChild(bubble);
		    chatBox.appendChild(container);
		    chatBox.scrollTop = chatBox.scrollHeight;
		}





        // 엔터 키로 메시지 전송
        function handleKeyPress(event) {
            if (event.key === "Enter") {
                sendMessage();
            }
        }

        // 페이지 로드 시 WebSocket 연결
        window.onload = connect;
    </script>
</body>
</html>