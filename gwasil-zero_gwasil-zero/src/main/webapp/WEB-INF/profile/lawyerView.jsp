<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="/css/lawyerView.css">
        <link rel="icon" type="image/png" href="/img/common/logo3.png">
        <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawInfoApp">
            <div class="layout">
                <div>
                    <h2 class="section-subtitle">변호사 상세보기</h2>
                </div>
                <div class="content">
                    <!-- 상단 프로필 영역 -->
                    <div class="lawyer-header">
                        <!-- 프로필 사진 -->
                        <div class="profile-left">
                            <img :src="info.lawyerImg" alt="프로필">
                        </div>

                        <!-- 이름 + 전문 분야 -->
                        <div class="profile-center">
                            <h2 class="lawyer-name">
                                {{ info.lawyerName }}
                                <span class="lawyer-title">변호사</span>
                            </h2>
                            <div class="category-badges">
                                <span class="badge" v-if="info.mainCategoryName1">{{ info.mainCategoryName1 }}</span>
                                <span class="badge" v-if="info.mainCategoryName2">{{ info.mainCategoryName2 }}</span>
                            </div>
                        </div>

                        <!-- 소개글 -->
                        <div class="profile-right">
                            <h3 class="intro-title">소개글</h3>
                            <p v-if="hasInfo" v-html="info.lawyerInfo" class="intro-text"></p>
                            <p v-else class="no-data">작성된 소개가 없습니다.</p>
                        </div>
                    </div>

                    <hr class="divider" />

                    <!-- 탭 영역 -->
                    <div class="lawyer-tabs">
                        <button :class="{ active: currentTab === 'home' }" @click="currentTab = 'home'">변호사 홈</button>
                        <button :class="{ active: currentTab === 'review' }" @click="currentTab = 'review'">후기
                            목록</button>
                        <button @click="fnBack">변호사 목록보기</button>
                    </div>

                    <!-- 탭 내용 -->
                    <div v-if="currentTab === 'home'" class="tab-content">
                        <!-- 박스 1: 기본 정보 -->
                        <div class="info-box">
                            <h3>기본 정보</h3>
                            <p><strong>이름:</strong> {{ info.lawyerName }}</p>
                            <p><strong>이메일:</strong> {{ info.lawyerEmail }}</p>
                            <p><strong>전화번호:</strong> {{ info.lawyerPhone }}</p>
                            <div v-if="info.officproofName">
                                <p><strong>사무실:</strong> {{ info.officproofName }}</p>
                            </div>
                            <div v-if="info.officproofPath">
                                <p><strong>소속 인증:</strong></p>
                                <img :src="info.officproofPath" alt="소속 인증" class="proof-img">
                            </div>
                        </div>

                        <!-- 박스 2: 학력 사항 -->
                        <div class="info-box" v-if="hasEdu">
                            <h3>학력 사항</h3>
                            <div v-html="info.lawyerEdu" class="info-text"></div>
                        </div>

                        <!-- 박스 3: 법조 경력 -->
                        <div class="info-box" v-if="hasCareer">
                            <h3>법조 경력</h3>
                            <div v-html="info.lawyerCareer" class="info-text"></div>
                        </div>

                        <!-- 박스 4: 업무 사례 -->
                        <div class="info-box" v-if="hasTask">
                            <h3>업무 사례</h3>
                            <div v-html="info.lawyerTask" class="info-text"></div>
                        </div>

                        <!-- 박스 5: 기타 자격증 -->
                        <div class="info-box" v-if="license.length > 0">
                            <h3>기타 자격사항</h3>
                            <div class="license-list">
                                <div class="license-card" v-for="item in license" :key="item.licenseName">
                                    <img v-if="item.licenseFilePath" :src="item.licenseFilePath" alt="자격증 이미지"
                                        class="license-img" />
                                    <div v-else class="no-data license-img">이미지 없음</div>
                                    <div class="license-name">{{ item.licenseName }}</div>
                                </div>
                            </div>
                        </div>

                        <!-- 박스 6: 대표 사건 -->
                        <div class="info-box" v-if="validCaseList.length > 0">
                            <h3>대표 사건</h3>
                            <div class="case-list">
                                <div class="case-card" v-for="caseItem in validCaseList" :key="caseItem.boardNo"
                                    @click="goToBoard(caseItem.boardNo)">
                                    <img v-if="caseItem.filePath" :src="caseItem.filePath" class="preview-img" />
                                    <div v-else class="preview-img no-thumbnail">썸네일 없음</div>
                                    <div class="case-title">{{ caseItem.boardTitle }}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 감사의 말 탭 -->
                    <div v-if="currentTab === 'review'" class="tab-content review-column">
                        <!-- 후기 목록 -->
                        <div class="info-box">
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
                                            <span v-for="n in item.score" :key="n" class="star">⭐</span>
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

                        <!-- AI 후기 분석 -->
                        <div class="info-box">
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
                    currentTab: 'home',

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
                },
                hasInfo() {
                    return this.info.lawyerInfo && this.removeEmptyTag(this.info.lawyerInfo).trim() !== '';
                },
                hasCareer() {
                    return this.info.lawyerCareer && this.removeEmptyTag(this.info.lawyerCareer).trim() !== '';
                },
                hasEdu() {
                    return this.info.lawyerEdu && this.removeEmptyTag(this.info.lawyerEdu).trim() !== '';
                },
                hasTask() {
                    return this.info.lawyerTask && this.removeEmptyTag(this.info.lawyerTask).trim() !== '';
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
                            self.info = data.info;
                            self.lawyerId = data.info.lawyerId;
                            self.license = data.license;
                            self.mainCaseList = data.mainCaseList || [];
                            self.fnGetReviewList();
                        }
                    });
                },
                fnBack() {
                    location.href = document.referrer;
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
                            console.log(data);
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
                    self.loading = true;
                    $.ajax({
                        url: "http://192.168.30.6:5000/qa",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ question: question }),
                        success: function (res) {
                            self.answer = res.answer;
                            self.loading = false;
                        },
                        error: function () {
                            self.answer = "키워드 추출에 실패했습니다.";
                            self.loading = false;
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
                        url: "http://192.168.30.6:5000/qa",
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
                },
                goToBoard(boardNo) {
                    location.href = "/board/view.do?boardNo=" + boardNo;
                },
                removeEmptyTag(html) {
                    // <p><br></p> 같이 아무 의미 없는 태그 제거
                    return html.replace(/<p><br\s*\/?><\/p>/gi, '')
                        .replace(/&nbsp;/gi, '')
                        .replace(/\s+/g, '');
                }
            },
            mounted() {
                const self = this;
                const params = new URLSearchParams(window.location.search);
                const lawyerIdParam = params.get('lawyerId');
                if (lawyerIdParam) {
                    self.lawyerId = lawyerIdParam;
                }
                self.fnGetLawyerInfo();

                setTimeout(function () {
                    // info 값이 없으면 저장 안 함
                    if (!self.info || !self.info.lawyerName) return;

                    const item = {
                        type: 'lawyer',
                        id: self.lawyerId,
                        name: self.info.lawyerName
                    };

                    let list = JSON.parse(localStorage.getItem('recentViewed') || '[]');
                    list = list.filter(i => !(i.type === item.type && i.id === item.id));
                    list.unshift(item);
                    if (list.length > 5) list = list.slice(0, 5);
                    localStorage.setItem('recentViewed', JSON.stringify(list));
                }, 500);
            }
        });
        lawInfoApp.mount('#lawInfoApp');
    </script>