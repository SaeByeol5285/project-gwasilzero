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
                    mainCaseList: []
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
                            console.log(data. info);
                            self.info = data.info;
                            self.license = data.license;
                            self.mainCaseList = data.mainCaseList || [];
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