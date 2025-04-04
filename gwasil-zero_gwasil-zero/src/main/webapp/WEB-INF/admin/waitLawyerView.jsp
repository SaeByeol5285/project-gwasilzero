<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>승인 대기 변호사 상세보기</title>
        <style>
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

            .no-data {
                color: #999;
                font-style: italic;
                font-size: 14px;
                padding: 6px 0;
            }

            .approve button {
                height: 36px;
                padding: 0 16px;
                background-color: #ff5c00;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: bold;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.2s ease;
                margin-left: 5px;
            }

            .approve button:hover {
            background-color: #e65100;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawyerDetailApp">
            <div class="layout">
                <jsp:include page="layout.jsp" />
                <div class="content">
                    <div class="header">
                        <div>관리자페이지</div>
                        <div>Admin님</div>
                    </div>
                    <div>
                        <h3>승인 대기 변호사 상세보기</h3>
                    </div>
                    <div class="profile-container">
                        <div class="profile-photo">
                            <div v-if="info.lawyerImg">
                                <img :src="info.lawyerImg" alt="프로필 사진">
                            </div>
                            <div v-else class="no-data">프로필 사진 없음</div>
                            <div class="lawyer-meta">
                                <div class="lawyer-name">{{ info.lawyerName }}</div>
                                <div class="lawyer-phone">Tel : {{ info.lawyerPhone }}</div>
                                <div class="lawyer-email">Email : {{ info.lawyerEmail }}</div>
                            </div>
                            <div class="approve">
                                <button @click="fnApprove">승인</button>
                                <button @click="fnBack">목록</button>
                            </div>
                        </div>
                        <div class="profile-detail">
                            <div class="section">
                                <h3>소개</h3>
                                <div v-if="info.lawyerInfo" v-html="info.lawyerInfo">{{ info.lawyerInfo }}</div>
                                <div v-else class="no-data">작성된 소개가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>경력</h3>
                                <div v-if="info.lawyerCareer" v-html="info.lawyerCareer">{{ info.lawyerCareer }}</div>
                                <div v-else class="no-data">작성된 경력이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>주요 업무사례</h3>
                                <div v-if="info.lawyerTask" v-html="info.lawyerTask">{{ info.lawyerTask }}</div>
                                <div v-else class="no-data">작성된 업무사례가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>학력</h3>
                                <div v-if="info.lawyerEdu" v-html="info.lawyerEdu">{{ info.lawyerEdu }}</div>
                                <div v-else class="no-data">작성된 학력이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>출생년도</h3>
                                <div v-if="info.birth">{{ info.birth }}</div>
                                <div v-else class="no-data">작성된 생년월일이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>소속 법무 법인</h3>
                                <div v-if="info.officproofName">{{ info.officproofName }}</div>
                                <div v-else class="no-data">작성된 법인 내용이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>변호사 등록번호</h3>
                                <div v-if="info.lawyerNumber">{{ info.lawyerNumber }}</div>
                                <div v-else class="no-data">작성된 변호사 등록번호가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>변호사 취득일시</h3>
                                <div v-if="info.passYears">{{ info.passYears }}</div>
                                <div v-else class="no-data">작성된 변호사 취득일시가 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>변호사 자격증명</h3>
                                <div v-if="info.lawyerLiscensName">{{ info.lawyerLiscensName }}</div>
                                <div v-else class="no-data">등록된 변호사 자격증명이 없습니다.</div>
                            </div>
                            <div class="section">
                                <h3>변호사 자격증 사본</h3>
                                <div v-if="info.lawyerLiscensPath">
                                    <img :src="info.lawyerLiscensPath" alt="자격증 사본">
                                </div>
                                <div v-else class="no-data">등록된 변호사 자격증 사본 없습니다.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const urlParams = new URLSearchParams(location.search);
        const lawyerId = urlParams.get("lawyerId");

        const lawyerDetailApp = Vue.createApp({
            data() {
                return {
                    info: {},
                    license: [],
                };
            },
            methods: {
                fnGetLawyerInfo() {
                    const self = this;
                    $.ajax({
                        url: "/profile/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: { lawyerId: lawyerId },
                        success: function (data) {
                            // console.log(data. info);
                            self.info = data.info;
                            self.license = data.license;
                        }
                    });
                },
                fnApprove() {
                    if (confirm("이 변호사를 승인하시겠습니까?")) {
                        $.post("/admin/lawApprove.dox", { lawyerId: lawyerId }, function () {
                            alert("승인 처리되었습니다.");
                            location.href = "lawyer.do";
                        });
                    }
                },
                fnBack() {
                    history.back();
                }
            },
            mounted() {
                this.fnGetLawyerInfo();
            }
        });
        lawyerDetailApp.mount('#lawyerDetailApp');
    </script>