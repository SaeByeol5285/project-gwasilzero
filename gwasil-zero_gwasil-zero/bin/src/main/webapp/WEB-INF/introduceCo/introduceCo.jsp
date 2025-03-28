<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
      integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/introduceCo.css">
    <title>introduceCo</title>
  </head>

  <body>
    <jsp:include page="../common/header.jsp" />

    <div id="app">
      <section class="hero">
        <p class="hero-sub">억울한 과실비율, 변호사 상담이 필요하다면?</p>
        <h1 class="hero-main">
          비용도 결과도, 이제는 <span class="orange">숨김 없이</span> 확인하세요.
        </h1>
        <div class="hero-box">
          과실제로는 <span class="blackbox">블랙박스</span>에서 시작합니다.
        </div>
      </section>

      <section class="why-needed">
        <section class="why-needed">
          <h2 class="why-title">
            왜 <span class="inline-logo"><img src="../../img/logo1.png" alt="과실제로 로고"> 가 필요한가요?</span>
          </h2>
        </section>


        <div class="content">
          <img src="../../img/blackbox.webp" alt="블랙박스 아이콘" class="blackbox-img" />

          <div class="text">
            <p>교통사고가 나면 억울함보다 먼저 보험사의 <span class="orange">과실비율 통보</span>가 옵니다.</p>
            <p>블랙박스가 있어도, 혼자선 <span class="orange">법적 대응이 막막</span>합니다.</p>
            <p>전문가의 도움이 필요하지만, <span class="orange">비용</span>과 <span class="orange">접근성</span>은 장벽이 됩니다.</p>
            <p class="bold">그래서, 과실제로가 시작됐습니다.</p>
          </div>
        </div>
      </section>

      <section class="steps">
        <h2 class="steps-title">
          <span class="inline-title">
            <img src="../../img/logo1.png" alt="과실제로 로고" class="logo" />의 <strong>3단계로 끝나는 교통사고 법률 대응</strong>   
          </span>
        </h2>
        <div class="step-wrapper">
          <div class="step">
            <div class="step-number">1.</div>
            <div class="step-box">
              <strong><span class="orange">블랙박스 영상</span></strong>을 업로드하고 질문을 등록하세요.
            </div>
          </div>

          <div class="step">
            <div class="step-number">2.</div>
            <div class="step-box">
              여러 명의 변호사로부터 분석과 <span class="orange">답변</span>을 받아보세요.
            </div>
          </div>

          <div class="step">
            <div class="step-number">3.</div>
            <div class="step-box">
              마음에 드는 <span class="orange">변호사를 선택</span>하고, 1:1 상담 및 선임까지 진행하세요.
            </div>
          </div>
        </div>
      </section>

      <section class="features">
        <h2>주요 서비스</h2>
        <div class="feature-grid">
          <div class="feature-card">
            <img src="../../img/icon-video.png" alt="블랙박스 질문 등록" />
            <p>블랙박스 영상 기반 질문 등록</p>
          </div>
          <div class="feature-card">
            <img src="../../img/icon-price.png" alt="소송 비용 확인" />
            <p>사건 별 소송 비용 확인</p>
          </div>
          <div class="feature-card">
            <img src="../../img/icon-chat.png" alt="1:1 상담" />
            <p>1:1 채팅 및 상담</p>
          </div>
          <div class="feature-card">
            <img src="../../img/icon-lawyer.webp" alt="분석 답변" />
            <p>변호사들의 분석 답변</p>
          </div>
        </div>

        <div class="cta-box">
          <a href="/user/add.do" class="cta-button">회원가입 시 1회 무료 상담 가능</a>
        </div>
      </section>

      <section class="compare">
        <h2>과실제로는 무엇이 다를까요?</h2>
        <table class="compare-table">
          <thead>
            <tr>
              <th>항목</th>
              <th>기존 법률 플랫폼</th>
              <th class="highlight-logo">
                <img src="../../img/logo2.png" alt="과실제로 로고" />
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>상담 방식</td>
              <td>글</td>
              <td><span class="orange">블랙박스 영상</span></td>
            </tr>
            <tr>
              <td>변호사 선택</td>
              <td>랜덤 / 1명 선택</td>
              <td>여러 명의 답변<br><span class="orange">비교 후 선택</span></td>
            </tr>
            <tr>
              <td>질문 공개 여부</td>
              <td>일부 또는 비공개</td>
              <td>전체 질문/답변 <span class="orange">공개</span><br>(사례 참고 가능)</td>
            </tr>
            <tr>
              <td>답변 속도</td>
              <td>불규칙</td>
              <td>정해진 <span class="orange">시간 내</span><br>답변 보장 (유료)</td>
            </tr>
            <tr>
              <td>상담 흐름</td>
              <td>상담만 제공</td>
              <td>상담 → 채팅 → 선임까지 원스톱</td>
            </tr>
            <tr>
              <td>비용 공개</td>
              <td>X 또는 대략적인 금액</td>
              <td>완료된 사건<br><span class="orange">비용 공개</span></td>
            </tr>
          </tbody>
        </table>
      </section>
      <section class="target-users">
        <h2>이런 분께 추천드립니다!</h2>
        <ul class="user-list">
          <li>블랙박스 영상은 있지만, 법적 판단이 어려운 분</li>
          <li>보험사의 과실비율 통보에 이의가 있는 분</li>
          <li>교통사고 대응이 처음이라 막막한 분</li>
          <li>여러 변호사의 의견을 비교해보고 싶은 분</li>
          <li>법률 서비스를 쉽고 빠르게 이용하고 싶은 분</li>
        </ul>
      </section>

      <button @click="scrollToTop" class="top-button">▲ 맨 위로</button>

    </div>
    <jsp:include page="../common/footer.jsp" />

  </body>

  </html>
  <script>
    const app = Vue.createApp({
      data() {
        return {
        };
      },
      methods: {
        scrollToTop() {
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }

      },
      mounted() {
        var self = this;
      }
    });
    app.mount('#app');
  </script>
  ​