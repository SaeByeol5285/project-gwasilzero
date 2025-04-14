<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/3.4.21/vue.global.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title>비밀번호 찾기</title>
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
        cursor: not-allowed;
      }
    </style>
  </head>

  <body>
    <jsp:include page="../common/header.jsp" />
    <div id="app">
      <div class="form-section">
        <h2>비밀번호 찾기</h2>
        <input v-model="user.userId" placeholder="아이디 입력" />
        <button @click="requestCert" style="margin-bottom: 10px;">인증 요청</button>
        <button @click="fnSearchPwd" :disabled="!isAuthenticated">비밀번호 찾기</button>
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
            userId: ""
          },
          isAuthenticated: false
        };
      },
      methods: {
        requestCert() {
          const self = this;
          IMP.certification({
            channelKey: "channel-key-5164809c-6049-4ea1-9145-89fdfd4b17f4",
            merchant_uid: "pwd_cert_" + new Date().getTime()
          }, function (rsp) {
            if (rsp.success) {
              self.isAuthenticated = true;
              console.log("✅ 인증 성공");
            } else {
              Swal.fire({
                icon: "error",
                title: "인증 실패",
                text: "❌ 본인 인증에 실패했습니다.",
                confirmButtonText: "확인"
              });
            }
          });
        },
        fnSearchPwd() {
          const self = this;
          $.ajax({
            url: "/user/userId-check.dox",
            type: "POST",
            data: {
              userId: self.user.userId
            },
            success: function (data) {
              if (data.count === 1) {
                sessionStorage.setItem("recoverUserId", self.user.userId);
                location.href = "/user/reMakePwd.do";
              } else {
                Swal.fire({
                  icon: "warning",
                  title: "아이디 없음",
                  text: "❌ 존재하지 않는 아이디입니다.",
                  confirmButtonText: "확인"
                });
              }
            },
            error: function () {
              Swal.fire({
                icon: "error",
                title: "서버 오류",
                text: "서버 통신 오류가 발생했습니다.",
                confirmButtonText: "확인"
              });
            }
          });
        }
      }
      ,
      mounted() {
        console.log("Vue instance mounted");
      }
    });

    app.mount('#app');
  </script>