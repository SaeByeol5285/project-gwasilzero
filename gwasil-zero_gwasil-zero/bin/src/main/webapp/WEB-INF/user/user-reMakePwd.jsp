<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
      integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
			      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
    <style>
      .form-section {
        width: 100%;
        max-width: 400px;
        margin: 100px auto;
        padding: 30px;
        background: #ffffff;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      }

      input {
        width: 93%;
        padding: 12px;
        margin-bottom: 10px;
        border: 2px solid #e5e7eb;
        border-radius: 5px;
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
    </style>
  </head>

  <body>
    <jsp:include page="../common/header.jsp" />

    <div class="form-section">
      <h2>비밀번호 재설정</h2>
      <input id="newPwd" type="password" placeholder="새 비밀번호 입력" />
      <input id="confirmPwd" type="password" placeholder="비밀번호 확인" />
      <button onclick="submitNewPassword()">변경하기</button>
    </div>
    <jsp:include page="../common/footer.jsp" />
  </body>

  </html>

  <script>
    const userId = sessionStorage.getItem("recoverUserId");
  
    if (!userId) {
      Swal.fire({
        icon: "error",
        title: "접근 오류",
        text: "❌ 인증되지 않은 접근입니다.",
        confirmButtonText: "확인"
      }).then(() => {
        location.href = "/user/search.do";
      });
    }
  
    function submitNewPassword() {
      const pwd = document.getElementById("newPwd").value;
      const confirmPwd = document.getElementById("confirmPwd").value;
  
      if (!pwd || !confirmPwd) {
        return Swal.fire({
          icon: "warning",
          title: "입력 필요",
          text: "비밀번호를 입력해주세요.",
          confirmButtonText: "확인"
        });
      }
  
      if (pwd !== confirmPwd) {
        return Swal.fire({
          icon: "error",
          title: "불일치",
          text: "비밀번호가 일치하지 않습니다.",
          confirmButtonText: "확인"
        });
      }
  
      $.ajax({
        url: "/user/user-reMakePwd.dox",
        type: "POST",
        data: {
          id: userId,
          pwd: pwd
        },
        success: function (data) {
          if (data.result === "success") {
            Swal.fire({
              icon: "success",
              title: "변경 완료",
              text: "✅ 비밀번호가 성공적으로 변경되었습니다.",
              confirmButtonText: "확인"
            }).then(() => {
              sessionStorage.removeItem("recoverUserId");
              location.href = "/user/login.do";
            });
          } else {
            Swal.fire({
              icon: "error",
              title: "변경 실패",
              text: "변경 실패: " + (data.message || "서버 오류"),
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
  </script>