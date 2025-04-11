<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <title>관리자 변호사 관리</title>
        <style>
            .content-container a {
                color: #ff6b00;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.2s ease;
            }
            
            .content-container a:hover {
                color: #d64d00;
                text-decoration: underline;
            }

            .button {
				padding: 10px 18px;
				font-size: 13px;
				border: none;
				border-radius: 8px;
				background-color: #ff5c00;
				color: white;
				font-weight: 500;
				cursor: pointer;
				transition: all 0.2s ease;
			}

			.button:hover {
				background-color: #ffe6db;
				color: #ff5c00;
			}

			.button.active {
				background-color: #ff5c00;
				color: white;
				font-weight: bold;
				box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
			}

			.button:disabled {
				opacity: 0.4;
				cursor: default;
			}

			.button.active {
				background-color: #ff5c00;
				color: white;
				font-weight: bold;
				box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
			}
        </style>  
    </head>

    <body>
        <div id="lawyerApp">
            <jsp:include page="layout.jsp" />
            <div class="content">
                <h2>변호사 관리</h2>
                <div class="content-container">
                    <div>
                        <!-- 변호사 승인 처리 -->
                        <h3>변호사 승인 대기 목록 (총 : {{ lawWaitTotal }}명 대기중)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>전화번호</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>소속 유형</th>
                            </tr>
                            <tr v-for="lawWait in lawWaitList" :key="lawWait.lawyerId">
                                <td>
                                    <a :href="'waitLawyerView.do?lawyerId=' + lawWait.lawyerId + '&page=lawyer'">{{ lawWait.lawyerName }}</a>
                                </td>
                                <td>{{lawWait.lawyerId}}</td>
                                <td>{{lawWait.lawyerPhone}}</td>
                                <td>{{lawWait.lawyerNumber}}</td>
                                <td>{{lawWait.passYears}}</td>
                                <td>
                                    <span v-if="lawWait.lawyerStatus === 'I'">소속 변호사</span>
                                    <span v-else-if="lawWait.lawyerStatus === 'P'">개인 변호사</span>
                                    <span v-else>-</span>
                                </td>
                            </tr>
                        </table>
                        <!-- 승인 대기 목록 페이징 -->                     
                        <div class="pagination-container">
                            <button class="btn" @click="fnWaitPrevPage" :disabled="waitPage === 1">〈 이전</button>
                            <button 
                            v-for="n in waitPageCount" 
                            :key="n" 
                            @click="fnWaitPage(n)" 
                            :class="['btn', waitPage === n ? 'active' : '']">
                            {{ n }}
                            </button>
                            <button class="btn" @click="fnWaitNextPage" :disabled="waitPage === waitPageCount">다음 〉</button>
                        </div>

                        <!-- 승인 완료 변호사 목록 -->
                        <h3>현재 변호사 목록 (총 : {{ lawPassedTotal }}명 등록중)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>전화번호</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>소속 유형</th>
                                <th>승인 취소</th>
                            </tr>
                            <tr v-for="lawPassed in lawPassedList" :key="lawPassed.lawyerId">
                                <td>{{lawPassed.lawyerName}}</td>
                                <td>{{lawPassed.lawyerId}}</td>
                                <td>{{lawPassed.lawyerPhone}}</td>
                                <td>{{lawPassed.lawyerNumber}}</td>
                                <td>{{lawPassed.passYears}}</td>
                                <td>
                                    <span v-if="lawPassed.lawyerStatus === 'I'">소속 변호사</span>
                                    <span v-else-if="lawPassed.lawyerStatus === 'P'">개인 변호사</span>
                                    <span v-else>-</span>
                                </td>
                                <td>
                                    <button @click="fnCancel(lawPassed.lawyerId)" class="button">승인취소</button>
                                </td>
                            </tr>
                        </table>
                        <!-- 승인 완료 변호사 목록 페이징 -->
                        <div class="pagination-container">
                            <button class="btn" @click="fnPassedPrevPage" :disabled="passedPage === 1">〈 이전</button>
                            <button 
                            v-for="n in passedPageCount" 
                            :key="n" 
                            @click="fnPassedPage(n)" 
                            :class="['btn', passedPage === n ? 'active' : '']">
                            {{ n }}
                            </button>
                            <button class="btn" @click="fnPassedNextPage" :disabled="passedPage === passedPageCount">다음 〉</button>
                        </div>

                        <!-- 탈퇴 변호사 목록 -->
                        <h3>탈퇴 변호사 목록 (총 : {{ lawOutTotal }}명 탈퇴)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>전화번호</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>재가입 승인</th>
                            </tr>
                            <tr v-for="lawOut in lawOutList" :key="lawOut.lawyerId">
                                <td>{{lawOut.lawyerName}}</td>
                                <td>{{lawOut.lawyerId}}</td>
                                <td>{{lawOut.lawyerPhone}}</td>
                                <td>{{lawOut.lawyerNumber}}</td>
                                <td>{{lawOut.passYears}}</td>
                                <td>
                                    <button @click="fnComeBack(lawOut.lawyerId)" class="button">재가입</button>
                                </td>
                            </tr>
                        </table>

                        <!-- 탈퇴 변호사 목록 페이징 -->
                        <div class="pagination-container">
                            <button class="btn" @click="fnOutPrevPage" :disabled="outPage === 1">〈 이전</button>
                            <button 
                            v-for="n in outPageCount"
                            :key="n" 
                            @click="fnOutPage(n)" 
                            :class="['btn', outPage === n ? 'active' : '']">
                            {{ n }}
                            </button>
                            <button class="btn" @click="fnOutNextPage" :disabled="outPage === outPageCount">다음 〉</button>
                        </div>
                    </div>
                </div>
            </div>
            </div> <!-- 여기서 layout 닫기  -->
        </div>
    </body>

    </html>
    <script>
        const lawyerApp = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    lawWaitList: [],
                    lawWaitTotal: 0,
                    waitPage: 1,
                    waitPageSize: 5,
                    waitPageCount: 0,

                    lawPassedList: [],
                    lawPassedTotal: 0,
                    passedPage: 1,
                    passedPageSize: 5,
                    passedPageCount: 0,

                    lawOutList: [],
                    lawOutTotal: 0,
                    outPage: 1,
                    outPageSize: 5,
                    outPageCount: 0
                };
            },
            methods: {
                // 대기 변호사 목록, 페이징, 승인처리
                fnLawWaitList() {
                    var self = this;
                    var nparmap = {
                        waitPage: (self.waitPage - 1) * self.waitPageSize,
                        waitPageSize: self.waitPageSize
                    };
                    $.ajax({
                        url: "/admin/lawWaitList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.lawWaitList = data.lawWaitList;
                            self.lawWaitTotal = data.count;
                            self.waitPageCount = Math.ceil(data.count / self.waitPageSize);

                            // 현재 페이지에 데이터가 하나만 있고 삭제된 경우 페이지 이동
                            if (self.lawWaitList.length === 0 && self.waitPage > 1) {
                                self.waitPage--;
                                self.fnLawWaitList(); 
                            }
                        }
                    });
                },
                fnWaitPage(n) {
                    this.waitPage = n;
                    this.fnLawWaitList();
                },
                fnWaitPrevPage() {
                    if (this.waitPage > 1) {
                    this.waitPage--;
                    this.fnLawWaitList();
                    }
                },
                fnWaitNextPage() {
                    if (this.waitPage < this.waitPageCount) {
                        this.waitPage++;
                        this.fnLawWaitList();
                    }
                },                
                // 현재 변호사 목록, 페이징, 승인취소 처리
                fnLawPassedList() {
                    var self = this;
                    var nparmap = {
                        passedPage: (self.passedPage - 1) * self.passedPageSize,
                        passedPageSize: self.passedPageSize
                    };
                    $.ajax({
                        url: "/admin/lawPassedList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.lawPassedList = data.lawPassedList;
                            self.lawPassedTotal = data.count;
                            self.passedPageCount = Math.ceil(data.count / self.passedPageSize);

                            if (self.lawPassedList.length === 0 && self.passedPage > 1) {
                                self.passedPage--;
                                self.fnLawPassedList(); 
                            }
                        }
                    });
                },
                fnPassedPage(n) {
                    this.passedPage = n;
                    this.fnLawPassedList();
                },
                fnPassedPrevPage() {
                    if (this.passedPage > 1) {
                    this.passedPage--;
                    this.fnLawPassedList();
                    }
                },
                fnPassedNextPage() {
                    if (this.passedPage < this.passedPageCount) {
                        this.passedPage++;
                        this.fnLawPassedList();
                    }
                },
                fnCancel(lawyerId) {
                    var self = this;
                    Swal.fire({
                        title: "승인취소 하시겠습니까?",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: "예",
                        cancelButtonText: "아니오"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: "/admin/lawCencel.dox",
                                type: "POST",
                                data: { lawyerId: lawyerId },
                                success: function (data) {
                                    Swal.fire("처리 완료", "승인취소 되었습니다.", "success");
                                    self.fnLawWaitList();
                                    self.fnLawPassedList();
                                }
                            });
                        }
                    });
                },
                // 탈퇴 변호사 목록, 페이징
                fnLawOutList() {
                    var self = this;
                    var nparmap = {
                        outPage: (self.outPage - 1) * self.outPageSize,
                        outPageSize: self.outPageSize
                    };
                    $.ajax({
                        url: "/admin/lawOutList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.lawOutList = data.lawOutList;
                            self.lawOutTotal = data.count;
                            self.outPageCount = Math.ceil(data.count / self.outPageSize);

                            if (self.lawOutList.length === 0 && self.outPage > 1) {
                                self.outPage--;
                                self.fnLawOutList(); 
                            }
                        }
                    });
                },
                fnOutPage(n) {
                    this.outPage = n;
                    this.fnLawOutList();
                },
                fnOutPrevPage() {
                    if (this.outPage > 1) {
                    this.outPage--;
                    this.fnLawOutList();
                    }
                },
                fnOutNextPage() {
                    if (this.outPage < this.outPageCount) {
                        this.outPage++;
                        this.fnLawOutList();
                    }
                },
                fnComeBack(lawyerId) {
                    var self = this;
                    Swal.fire({
                        title: "재가입 승인 하시겠습니까?",
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonText: "예",
                        cancelButtonText: "아니오"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: "/admin/lawComeBack.dox",
                                type: "POST",
                                data: { lawyerId: lawyerId },
                                success: function (data) {
                                    Swal.fire("처리 완료", "재가입 되었습니다.", "success");
                                    self.fnLawOutList();
                                    self.fnLawWaitList();
                                    self.fnLawPassedList();
                                }
                            });
                        }
                    });
                },
            },
            mounted() {
                var self = this;
                self.fnLawWaitList();
                self.fnLawPassedList();
                self.fnLawOutList();
            }
        });
        lawyerApp.mount('#lawyerApp');
    </script>