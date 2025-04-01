<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <title>비밀번호 재설정</title>
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
      width: 100%;
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
  <div class="form-section">
    <h2>비밀번호 재설정</h2>
    <input id="newPwd" type="password" placeholder="새 비밀번호 입력" />
    <input id="confirmPwd" type="password" placeholder="비밀번호 확인" />
    <button onclick="submitNewPassword()">변경하기</button>
  </div>
</body>

</html>
  <script>
    const userId = sessionStorage.getItem("recoverUserId");

    if (!userId) {
      alert("❌ 인증되지 않은 접근입니다.");
      location.href = "/user/search.do";
    }

    function submitNewPassword() {
      const pwd = document.getElementById("newPwd").value;
      const confirmPwd = document.getElementById("confirmPwd").value;

      if (!pwd || !confirmPwd) {
        alert("비밀번호를 입력해주세요.");
        return;
      }

      if (pwd !== confirmPwd) {
        alert("비밀번호가 일치하지 않습니다.");
        return;
      }

      $.ajax({
        url: "/user/user-reMakePwd.dox",
        type: "POST",
        data: {
          userId: userId,
          pwd: pwd
        },
        success: function (data) {
          if (data.result === "success") {
            alert("✅ 비밀번호가 성공적으로 변경되었습니다.");
            sessionStorage.removeItem("recoverUserId");
            location.href = "/user/login.do";
          } else {
            alert("변경 실패: " + (data.message || "서버 오류"));
          }
        },
        error: function () {
          alert("서버 통신 오류가 발생했습니다.");
        }
      });
    }
  </script>

