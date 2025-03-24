<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/common.css">
	<title>introduceCo.jsp</title>
</head>
<style>
</style>
<body>
	<div id="app">
        <section class="container mt-40 mb-40">
            <div class="section-title">회사 소개</div>
          
            <!-- 브랜드 소개 -->
            <div class="card mb-40">
              <h2 class="section-title">우리는 ‘과실제로’입니다</h2>
              <p>
                과실제로는 교통사고 사건의 핵심 증거인
                <strong>“블랙박스 영상”을 기반으로 변호사의 분석과 조언을 제공</strong>하는
                국내 최초 수준의 교통사고 법률 매칭 플랫폼입니다.
              </p>
              <p>
                <strong>회원가입 시, 최초 1회 무료로 상담글을 등록할 수 있습니다.</strong>
              </p>
              <p>
                단순한 법률 검색을 넘어, <strong>현실적인 상황 분석과 직접적인 법률적 대응 방향</strong>을
                다양한 변호사의 시각으로 비교할 수 있도록 설계되었습니다.
              </p>
            </div>
          
            <!-- 과실제로가 필요한 이유 -->
            <div class="card mb-40">
              <h2 class="section-title">왜 과실제로인가요?</h2>
              <ul>
                <li>✅ <strong>블랙박스 영상을 기반으로 한 변호사의 실시간 분석 제공</strong></li>
                <li>✅ 다양한 변호사의 의견을 비교하고, 소비자가 직접 선택</li>
                <li>✅ 상담 → 선임까지 원스톱 진행 가능</li>
                <li>✅ 소송 전 실질적인 대응 전략을 빠르게 확인 가능</li>
              </ul>
            </div>
          
            <!-- 주요 기능 -->
            <div class="card mb-40">
              <h2 class="section-title">주요 기능</h2>
              <ul>
                <li>🎥 블랙박스 영상 업로드 → 질문 등록</li>
                <li>🆓 <strong>회원가입 시 최초 1회 무료 상담글 등록 가능</strong></li>
                <li>⚖️ 변호사의 분석 댓글 답변</li>
                <li>💬 1:1 채팅 및 상담 기능</li>
                <li>💰 예상 소송비용 확인 가능</li>
              </ul>
            </div>
          
            <!-- 차별화 포인트 -->
            <div class="card mb-40">
              <h2 class="section-title">과실제로 사이트의 차별점</h2>
              <ul>
                <li><strong>타 플랫폼과 다른 점</strong>：베이스가 되는 “블랙박스 영상”을 기본으로 사용</li>
                <li>질문/답변은 공개되어 다른 사람의 사례로도 참고가능</li>
                <li>정해지진 시간 내 답변을 보장하는 유료 패키지</li>
              </ul>
            </div>
          
            <!-- 이용 대상 -->
            <div class="card">
              <h2 class="section-title">이용 대상</h2>
              <ul>
                <li>블랙박스 영상을 보유한 교통사고 당사자</li>
                <li>보험사 과실비율에 이의가 있는 소비자</li>
                <li>교통사고 소송을 고민 중인 피해자 및 가해자</li>
              </ul>
            </div>
          </section>          
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				list : []
				
            };
        },
        methods: {
           
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>
​