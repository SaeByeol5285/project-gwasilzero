<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
      integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/3.4.21/vue.global.min.js"
      integrity="sha512-Qq+0zrmldI9Zlo8bNzImlYAj6GdvYp7ZXU8pHnW9RZOh2ISmD74yW3Q6bTFSvVPttTeu4lUbZ8F9E3A7bU4TgQ=="
      crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title>아이디 찾기</title>

    <style>
      #app {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 70vh;
        padding: 20px;
      }

      .form-section {
        width: 100%;
        max-width: 400px;
        background: #ffffff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      }

      h2 {
        text-align: center;
        color: #FF5722;
        margin-bottom: 20px;
      }

      input {
        width: 100%;
        padding: 12px;
        margin-bottom: 10px;
        border: 2px solid #e5e7eb;
        border-radius: 5px;
        box-sizing: border-box;
      }

      button {
        width: 100%;
        padding: 12px;
        background-color: #FF5722;
        color: #ffffff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }

      button[disabled] {
        background-color: #ccc;
        color: #fff;
        cursor: not-allowed;
      }

      .modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 999;
      }

      .modal-content {
        background: white;
        padding: 30px;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
      }

      .modal-content h3 {
        color: #FF5722;
        margin-bottom: 15px;
      }

      .modal-content button {
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #FF5722;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }
    </style>
  </head>

  <body>
    <jsp:include page="../common/header.jsp" />

    <div id="app">
      <div class="form-section">
        <h2>아이디 찾기</h2>
        <input v-model="user.userName" placeholder="이름 입력" />
        <input v-model="user.userPhone" placeholder="핸드폰 번호 입력" />
        <button @click="requestCert" style="margin-bottom: 10px;">인증하기</button>
        <button @click="fnSearchId" :disabled="!isAuthenticated">아이디 찾기</button>
      </div>

      <!-- 모달 -->
      <div v-if="foundUserId" class="modal">
        <div class="modal-content">
          <h3>아이디 찾기 결과</h3>
          <p>{{ user.userName }}님의 아이디는 <strong>{{ foundUserId }}</strong>입니다.</p>
          <button @click="foundUserId = ''">닫기</button>
        </div>
      </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
  </body>

  </html>
  <script>
    IMP.init("imp29272276");

    const app = Vue.createApp({
      data() {
        return {
          user: {
            userName: "",
            userPhone: "",
            userId: ""
          },
          foundUserId: "",
          isAuthenticated: false
        };
      },
      methods: {
        requestCert() {
          const self = this;
          IMP.certification({
            channelKey: "channel-key-5164809c-6049-4ea1-9145-89fdfd4b17f4",
            merchant_uid: "test_m83tgrb2",
            min_age: 15,
            name: this.user.userName,
            phone: this.user.userPhone
          }, function (rsp) {
            if (rsp.success) {
              console.log("✅ 본인 인증 성공");
              self.isAuthenticated = true;
            } else {
              Swal.fire({
                icon: "error",
                title: "본인 인증 실패",
                text: "❌ 본인 인증에 실패했습니다.",
                confirmButtonText: "확인"
              });
            }
          });
        },
        fnSearchId() {
          var self = this;
          var nparmap = {
            userName: self.user.userName,
            userPhone: self.user.userPhone
          };
          $.ajax({
            url: "/user/userId-search.dox",
            type: "POST",
            data: nparmap,
            success: function (data) {
              if (data.result === "success") {
                self.foundUserId = data.userId;
              } else {
                Swal.fire({
                  icon: "warning",
                  title: "아이디 없음",
                  text: "아이디를 찾을 수 없습니다.",
                  confirmButtonText: "확인"
                });
              }
            },
            error: function () {
              Swal.fire({
                icon: "error",
                title: "오류 발생",
                text: "서버 통신 중 오류가 발생했습니다.",
                confirmButtonText: "확인"
              });
            }
          });
        }
      },
      mounted() {
        console.log("Vue instance mounted");
      }
    });

    app.mount("#app");
  </script>