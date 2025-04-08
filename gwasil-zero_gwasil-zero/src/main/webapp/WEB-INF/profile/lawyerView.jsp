<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>변호사 상세보기</title>
        <style>
            body {
                font-family: '맑은 고딕', sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }

            .layout {
                padding: 40px 20px;
            }

            .content {
                max-width: 1200px;
                margin: 0 auto;
            }

            .profile-container {
                display: flex;
                background-color: #fff;
                padding: 30px;
                border-radius: 12px;
                margin-top: 30px;
                gap: 30px;
                background-color: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            /* 프로필 이미지 + 이름 */
            .profile-photo {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 10px;
                width: 200px;
                flex-shrink: 0;
            }

            .profile-photo img {
                width: 160px;
                height: 160px;
                object-fit: cover;
                border-radius: 12px;
                border: 2px solid #ff5c00;
            }

            .lawyer-name {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                text-align: center;
            }

            /* 정보 상세 영역 */
            .profile-detail {
                flex: 1;
            }

            .profile-info {
                flex: 1;
            }

            .section {
                margin-bottom: 30px;
            }

            .section h3 {
                font-size: 17px;
                color: #ff5c00;
                margin-bottom: 8px;
                padding-bottom: 4px;
                border-bottom: 1px solid #ddd;
            }

            .section ul {
                padding-left: 20px;
                margin: 0;
            }

            .section span {
                font-size: 14px;
                color: #444;
                line-height: 1.6;
            }

            /* 라이센스 스타일 */
            .license-list {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 10px;
            }

            .license-card {
                background-color: #fff7f7;
                border: 1px solid #fbb;
                border-radius: 8px;
                padding: 12px;
                width: 200px;
                text-align: center;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            }

            .license-name {
                font-weight: bold;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .license-card img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

            /* === 대표 사건 카드 스타일 === */
            .case-list {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 15px;
                justify-content: flex-start;
            }

            .case-card {
                flex: 1;
                min-width: 180px;
                max-width: 220px;
                background-color: #fff7f7;
                border: 1px solid #fbb;
                border-radius: 8px;
                padding: 12px;
                text-align: center;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .case-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
            }

            .preview-img {
                border: 1px solid #ccc;
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 4px;
                display: block;
                margin: 0 auto 8px;
                background-color: #f5f5f5;
            }

            .preview-img.no-thumbnail {
                display: flex;
                align-items: center;
                justify-content: center;
                color: #888;
                font-size: 13px;
                border: 1px dashed #ccc;
                background-color: #fafafa;
            }

            /* 제목, 내용 스타일 */
            .case-title {
                font-weight: bold;
                margin-top: 10px;
            }

            .case-desc {
                background-color: white;
                padding: 10px;
                border-radius: 6px;
                font-size: 14px;
                min-height: 50px;
            }

            .lawyer-meta {
                margin-top: 12px;
                text-align: center;
            }

            .lawyer-name {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                margin-bottom: 6px;
            }

            .lawyer-phone,
            .lawyer-email {
                font-size: 14px;
                color: #666;
                line-height: 1.4;
                word-break: break-word;
            }

            .title-area {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #ff5c00;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }

            .title-area h2 {
                margin: 0;
            }

            .no-data {
                color: #999;
                font-style: italic;
                font-size: 14px;
                padding: 6px 0;
            }


            /* 리뷰 */
            .mypage-review {
                padding: 20px;
                font-family: '맑은 고딕', sans-serif;
            }

            .review-card {
                border: 1px solid #eee;
                background: #fff;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 15px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            }

            .review-header {
                display: flex;
                justify-content: space-between;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .review-date {
                color: #888;
                font-size: 13px;
            }

            .review-score {
                margin: 8px 0;
                font-size: 16px;
                color: #ffcc00;
            }

            .star {
                color: #ddd;
            }

            .star.filled {
                color: #ff9900;
            }

            .review-content {
                font-size: 15px;
                color: #333;
            }

            .no-data {
                padding: 20px;
                color: #888;
                text-align: center;
            }

            /* ai */
            /* AI 분석 결과 박스 */
            .llm-result {
                background: linear-gradient(to right, #f4f2ff, #eceeff);
                border-left: 5px solid #6a11cb;
                border-radius: 10px;
                padding: 18px 22px;
                margin-top: 18px;
                color: #333;
                font-family: 'Noto Sans', '맑은 고딕', sans-serif;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
                transition: box-shadow 0.3s ease;
            }

            .llm-result:hover {
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            }

            .llm-result strong {
                color: #6a11cb;
                font-weight: 600;
                font-size: 14px;
                display: block;
                margin-bottom: 10px;
            }

            /* AI 질문 input */
            #questionInput {
                padding: 8px 12px;
                width: 400px;
                border: 1px solid #d2c6f9;
                border-radius: 6px;
                font-size: 14px;
                outline: none;
                transition: border 0.3s ease;
            }

            #questionInput:focus {
                border-color: #6a11cb;
                box-shadow: 0 0 0 3px rgba(106, 17, 203, 0.15);
            }

            /* 버튼 */
            .ai-button {
                background: transparent;
                border: 2px solid #6a11cb;
                color: #6a11cb;
                padding: 6px 14px;
                border-radius: 6px;
                font-weight: 500;
                font-size: 14px;
                margin-right: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .ai-button:hover {
                background: #6a11cb;
                color: white;
                box-shadow: 0 0 10px rgba(106, 17, 203, 0.4);
            }

            /* 로딩 텍스트 */
            .loading-text {
                font-style: italic;
                color: #666;
                animation: blink 1.5s infinite;
            }

            @keyframes blink {

                0%,
                100% {
                    opacity: 1;
                }

                50% {
                    opacity: 0.4;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawInfoApp">
            <div class="layout">
                <div class="content">
                    <div class="title-area">
                        <h2>변호사 상세보기</h2>
                    </div>
                    <div class="profile-container">
                        <div class="profile-photo">
                            <template v-if="info.lawyerImg">
                                <img :src="info.lawyerImg" alt="프로필 사진">
                            </template>
                            <template v-else class="no-data">등록된 프로필 사진이 없습니다.</template>
                            <div class="lawyer-meta">
                                <div class="lawyer-name">{{ info.lawyerName }}</div>
                                <div class="lawyer-phone">Tel : {{ info.lawyerPhone }}</div>
                                <div class="lawyer-email">Email : {{ info.lawyerEmail }}</div>
                            </div>
                        </div>
                        <div class="profile-detail">
                            <div class="section">
                                <h3>소개</h3>
                                <div v-if="info.lawyerInfo" v-html="info.lawyerInfo"></div>
                                <div v-else class="no-data">작성된 소개가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3 style="color: #6a11cb;">AI 후기 분석</h3>
                                <!-- 자연어 질문 -->
                                <div class="llm-section">
                                    <label for="questionInput"><strong>🤖 AI에게 자유롭게 질문하기</strong></label>
                                    <input type="text" id="questionInput" v-model="question"
                                        placeholder="예: 해당 변호사의 후기 중 가장 인상 깊은 내용을 알려줘" style="width: 400px;">
                                    <button class="ai-button" @click="sendCustomLLMRequest">질문하기</button>
                                </div>

                                <!-- 또는 버튼 사용 -->
                                <div class="ai-buttons" style="margin-top: 16px;">
                                    <strong>또는 아래 버튼 중 하나를 눌러보세요:</strong><br>
                                    <button class="ai-button" @click="getReviewAverage">평균 별점 보기</button>
                                    <button class="ai-button" @click="getKeywordFromReviews">키워드 보기</button>
                                    <button class="ai-button" @click="getRepresentativeReview">대표 후기 보기</button>
                                </div>

                                <!-- 결과 -->
                                <div class="llm-result" v-if="answer">
                                    <strong>🤖 AI 분석 결과</strong>
                                    <p v-if="loading" class="loading-text">AI가 분석 중입니다...</p>
                                    <p v-else>{{ answer }}</p>
                                </div>


                            </div>
                            <div class="section">
                                <h3>경력</h3>
                                <div v-if="info.lawyerCareer" v-html="info.lawyerCareer"></div>
                                <div v-else class="no-data">작성된 경력이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>주요 업무사례</h3>
                                <div v-if="info.lawyerTask" v-html="info.lawyerTask"></div>
                                <div v-else class="no-data">작성된 업무사례가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>학력</h3>
                                <div v-if="info.lawyerEdu" v-html="info.lawyerEdu"></div>
                                <div v-else class="no-data">작성된 학력이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>자격 취득</h3>
                                <div v-if="license.length > 0" class="license-list">
                                    <div class="license-card" v-for="item in license" :key="item.licenseName">
                                        <div class="license-name">{{ item.licenseName }}</div>
                                        <img v-if="item.licenseFilePath" :src="item.licenseFilePath" alt="자격증 이미지" />
                                        <div v-else class="no-data">이미지 없음</div>
                                    </div>
                                </div>
                                <div v-else class="no-data">등록된 자격증이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>전문 분야</h3>
                                <ul v-if="info.mainCategoryName1 || info.mainCategoryName2" class="category-list">
                                    <li v-if="info.mainCategoryName1">{{ info.mainCategoryName1 }}</li>
                                    <li v-if="info.mainCategoryName2">{{ info.mainCategoryName2 }}</li>
                                </ul>
                                <div v-else class="no-data">선택된 전문분야가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>대표 사건 목록</h3>
                                <div v-if="validCaseList.length > 0" class="case-list">
                                    <div class="case-card" v-for="caseItem in validCaseList" :key="caseItem.BOARD_NO">
                                        <img v-if="caseItem.thumbnailPath" :src="caseItem.thumbnailPath"
                                            class="preview-img" />
                                        <div v-else class="preview-img no-thumbnail">썸네일 없음</div>
                                        <div class="case-title">{{ caseItem.BOARD_TITLE }}</div>
                                        <div class="case-desc">{{ caseItem.CONTENTS }}</div>
                                    </div>
                                </div>
                                <div v-else class="no-data">대표 사건 사례가 등록되지 않았습니다.</div>
                            </div>

                            <div class="section">
                                <h3>후기 목록</h3>
                                <div id="lawyerReviewApp" class="mypage-review">
                                    <div v-if="reviewList.length > 0" class="review-summary">
                                        총 {{reviewCnt}} 건의 리뷰
                                    </div>
                                    <div v-if="reviewList.length > 0">
                                        <div class="review-card" v-for="item in reviewList" :key="item.reviewNo">
                                            <div class="review-header">
                                                <strong>작성자:</strong> {{ item.userId.slice(0, 3) + '***' }}
                                                <span class="review-date">{{ item.cdate }}</span>
                                            </div>
                                            <div class="review-score">
                                                <span v-for="n in 5" :key="n" class="star"
                                                    :class="{ filled: n <= item.score }">⭐</span>
                                                <span class="score-text">({{ item.score }}점)</span>
                                            </div>
                                            <div class="review-content">
                                                {{ item.contents }}
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 페이징 -->
                                    <div class="pagination" style="margin-top: 20px; display: flex; gap: 10px;"
                                        v-if="reviewList.length > 0">
                                        <button :disabled="page === 1" @click="pageChange(page - 1)">이전</button>
                                        <span>페이지 {{ page }} / {{ index }}</span>
                                        <button :disabled="page === index" @click="pageChange(page + 1)">다음</button>
                                    </div>
                                    <div v-else class="no-data">아직 후기가 존재하지 않습니다.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/profile/recentViewBox.jsp" />
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const lawInfoApp = Vue.createApp({
            data() {
                return {
                    lawyerId: "${map.lawyerId}",
                    info: {},
                    sessionId: "${sessionId}",
                    license: [],
                    mainCaseList: [],

                    //리뷰
                    reviewList: [],
                    question: "",
                    answer: "",
                    page: 1,
                    pageSize: 3,
                    index: 0,
                    reviewCnt: 0,
                    loading: false
                };
            },
            computed: {
                validCaseList() {
                    return this.mainCaseList.filter(item => item != null);
                }
            },
            methods: {
                fnGetLawyerInfo() {
                    const self = this;
                    $.ajax({
                        url: "/profile/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: { lawyerId: self.lawyerId },
                        success: function (data) {
                            console.log(data.info);
                            self.info = data.info;
                            self.lawyerId = data.info.lawyerId;
                            self.license = data.license;
                            self.mainCaseList = data.mainCaseList || [];
                            self.fnGetReviewList();
                            console.log("✅ 변호사 정보 로딩 완료:", data.info.lawyerId);

                        }
                    });
                },
                fnGetReviewList() {
                    const self = this;
                    var nparmap = {
                        lawyerId: self.lawyerId,
                        page: (self.page - 1),
                        pageSize: self.pageSize
                    };

                    $.ajax({
                        url: "/profile/reviewList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data.list);
                            self.reviewList = data.list;
                            self.index = Math.ceil(data.count / self.pageSize);
                            self.reviewCnt = data.count;

                        }
                    });
                },
                pageChange(page) {
                    this.page = page;
                    this.fnGetReviewList();
                },
                // LLM에게 질문을 보내는 함수
                getKeywordFromReviews() {
                    const self = this;
                    //리뷰 내용 이어붙이기
                    let allContents = "";
                    for (let i = 0; i < self.reviewList.length; i++) {
                        allContents += "리뷰 " + (i + 1) + ": " + self.reviewList[i].contents + "\n";
                    }
                    // LLM에게 보낼 질문 만들기
                    const question =
                        "다음은 변호사에 대한 리뷰 목록입니다. " +
                        "이 텍스트들을 기반으로 자주 등장하는 단어 3개를 뽑아주세요. " +
                        "단어만 콤마(,)로 구분해서 간단히 적어주세요.\n" +
                        allContents;
                    self.loading = true;  // 🔵 로딩 시작
                    // 서버로 전송
                    $.ajax({
                        url: "http://localhost:5000/qa",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ question: question }),
                        success: function (res) {
                            self.answer = res.answer;
                            self.loading = false; // ✅ 로딩 끝
                        },
                        error: function () {
                            self.answer = "키워드 추출에 실패했습니다.";
                            self.loading = false; // ✅ 로딩 끝
                        }
                    });
                },
                sendCustomLLMRequest() {
                    const self = this;
                    if (!self.question || self.question.trim() === '') {
                        self.answer = "질문을 입력해주세요.";
                        return;
                    }
                    self.sendLLMRequest(self.question);
                },
                getReviewAverage() {
                    this.sendLLMRequest("해당 변호사의 후기들에 대한 평균 별점을 알려줘. 예시는 '해당 변호사의 평균 별점은 4.7점입니다.' 형태로.");
                },
                getRepresentativeReview() {
                    this.sendLLMRequest("해당 변호사의 후기 중 가장 긍정적인 대표 후기를 하나만 알려줘.");
                },
                sendLLMRequest(fullQuestion) {
                    const self = this;
                    const lawyerId = self.lawyerId;

                    if (!lawyerId || lawyerId === "null") {
                        self.answer = "변호사 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.";
                        return;
                    }

                    const questionToSend = "REVIEW 테이블에서 LAWYER_ID가 '" + lawyerId + "'인 " + fullQuestion;

                    self.loading = true;
                    $.ajax({
                        url: "http://localhost:5000/qa",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ question: questionToSend }),
                        success: function (res) {
                            self.answer = res.answer;
                            self.loading = false;
                        },
                        error: function () {
                            self.answer = "답변을 가져오는 데 실패했습니다.";
                            self.loading = false;
                        }
                    });
                }

            },
            mounted() {
                this.fnGetLawyerInfo();
                const self = this;

                setTimeout(function () {
                    // info 값이 없으면 저장 안 함
                    if (!self.info || !self.info.lawyerName) return;

                    var item = {
                        type: 'lawyer',
                        id: self.lawyerId,
                        name: self.info.lawyerName,
                        image: self.info.thumbnailPath || null
                    };

                    var list = JSON.parse(localStorage.getItem('recentViewed') || '[]');
                    list = list.filter(i => !(i.type === item.type && i.id === item.id)); // 중복 제거
                    list.unshift(item);
                    if (list.length > 5) list = list.slice(0, 5);
                    localStorage.setItem('recentViewed', JSON.stringify(list));
                }, 500);
            }
        });
        lawInfoApp.mount('#lawInfoApp');
    </script>