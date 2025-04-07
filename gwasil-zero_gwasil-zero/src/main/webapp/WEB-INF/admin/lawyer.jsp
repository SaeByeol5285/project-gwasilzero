<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>admin main</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="lawyerApp">
            <jsp:include page="layout.jsp" />
            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>{{sessionId}}님</div>
                </div>
                <h2>변호사 관리</h2>
                <div class="content-container">
                    <div>
                        <!-- 변호사 승인 처리 -->
                        <h3>변호사 승인 대기 목록 (총 : {{ lawWaitTotal }}명 대기중)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>소속 법무 법인</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>소속 유형</th>
                            </tr>
                            <tr v-for="lawWait in lawWaitList" :key="lawWait.lawyerId">
                                <td>
                                    <a :href="'waitLawyerView.do?lawyerId=' + lawWait.lawyerId + '&page=lawyer'">{{ lawWait.lawyerName }}</a>
                                </td>
                                <td>{{lawWait.lawyerId}}</td>
                                <td>{{lawWait.officproofName}}</td>
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
                        <div class="pagination">
                            <a v-if="waitPage != 1" href="javascript:;" @click="fnWaitPageMove('prev')"
                                class="page-btn">&lt;</a>
                            <a v-for="num in waitPageCount" :class="{active: waitPage === num}" href="javascript:;"
                                @click="fnWaitPage(num)" class="page-btn">{{ num }}</a>
                            <a v-if="waitPage != waitPageCount" href="javascript:;" @click="fnWaitPageMove('next')"
                                class="page-btn">&gt;</a>
                        </div>
                        <!-- 승인 완료 변호사 목록 -->
                        <h3>현재 변호사 목록 (총 : {{ lawPassedTotal }}명 등록중)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>소속 법무 법인</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>소속 유형</th>
                                <th>승인 취소</th>
                            </tr>
                            <tr v-for="lawPassed in lawPassedList" :key="lawPassed.lawyerId">
                                <td>{{lawPassed.lawyerName}}</td>
                                <td>{{lawPassed.lawyerId}}</td>
                                <td>{{lawPassed.officproofName}}</td>
                                <td>{{lawPassed.lawyerNumber}}</td>
                                <td>{{lawPassed.passYears}}</td>
                                <td>
                                    <span v-if="lawPassed.lawyerStatus === 'I'">소속 변호사</span>
                                    <span v-else-if="lawPassed.lawyerStatus === 'P'">개인 변호사</span>
                                    <span v-else>-</span>
                                </td>
                                <td>
                                    <button @click="fnCancel(lawPassed.lawyerId)">승인취소</button>
                                </td>
                            </tr>
                        </table>
                        <div class="pagination">
                            <a v-if="passedPage != 1" href="javascript:;" @click="fnPassedPageMove('prev')"
                                class="page-btn">&lt;</a>
                            <a v-for="num in passedPageCount" :class="{active: passedPage === num}" href="javascript:;"
                                @click="fnPassedPage(num)" class="page-btn">{{ num }}</a>
                            <a v-if="passedPage != passedPageCount" href="javascript:;"
                                @click="fnPassedPageMove('next')" class="page-btn">&gt;</a>
                        </div>
                        <!-- 탈퇴 변호사 목록 -->
                        <h3>탈퇴 변호사 목록 (총 : {{ lawOutTotal }}명 탈퇴)</h3>
                        <table>
                            <tr>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>소속 법무 법인</th>
                                <th>변호사 등록번호</th>
                                <th>변호사 취득일시</th>
                                <th>재가입 승인</th>
                            </tr>
                            <tr v-for="lawOut in lawOutList" :key="lawOut.lawyerId">
                                <td>{{lawOut.lawyerName}}</td>
                                <td>{{lawOut.lawyerId}}</td>
                                <td>{{lawOut.officproofName}}</td>
                                <td>{{lawOut.lawyerNumber}}</td>
                                <td>{{lawOut.passYears}}</td>
                                <td>
                                    <button @click="fnComeBack(lawOut.lawyerId)">재가입</button>
                                </td>
                            </tr>
                        </table>
                        <div class="pagination">
                            <a v-if="outPage != 1" href="javascript:;" @click="fnOutPageMove('prev')"
                                class="page-btn">&lt;</a>
                            <a v-for="num in outPageCount" :class="{active: outPage === num}" href="javascript:;"
                                @click="fnOutPage(num)" class="page-btn">{{ num }}</a>
                            <a v-if="outPage != outPageCount" href="javascript:;" @click="fnOutPageMove('next')"
                                class="page-btn">&gt;</a>
                        </div>
                    </div>
                </div>
            </div>
            </div> <!-- 여기서 layout 닫기  -->
        </div>
        <jsp:include page="../common/footer.jsp" />
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
                                self.fnLawWaitList(); // 다시 불러오기
                            }
                        }
                    });
                },
                fnWaitPage(num) {
                    var self = this;
                    self.waitPage = num;
                    self.fnLawWaitList();
                },
                fnWaitPageMove(dir) {
                    var self = this;
                    if (dir === 'prev' && self.waitPage > 1) self.waitPage--;
                    else if (dir === 'next' && self.waitPage < self.waitPageCount) self.waitPage++;
                    self.fnLawWaitList();
                },
                fnApprove(lawyerId) {
                    var self = this;
                    if (confirm("승인하시겠습니까?")) {
                        $.ajax({
                            url: "/admin/lawApprove.dox",
                            type: "POST",
                            data: { lawyerId: lawyerId },
                            success: function (data) {
                                alert("승인되었습니다.");
                                self.fnLawWaitList(); // 목록 새로고침
                                self.fnLawPassedList();
                            }
                        });
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
                                self.fnLawPassedList(); // 다시 불러오기
                            }
                        }
                    });
                },
                fnPassedPage(num) {
                    var self = this;
                    self.passedPage = num;
                    self.fnLawPassedList();
                },
                fnPassedPageMove(dir) {
                    var self = this;
                    if (dir === 'prev' && self.passedPage > 1) self.passedPage--;
                    else if (dir === 'next' && self.passedPage < self.passedPageCount) self.passedPage++;
                    self.fnLawPassedList();
                },
                fnCancel(lawyerId) {
                    var self = this;
                    if (confirm("승인취소 하시겠습니까?")) {
                        $.ajax({
                            url: "/admin/lawCencel.dox",
                            type: "POST",
                            data: { lawyerId: lawyerId },
                            success: function (data) {
                                alert("승인취소 되었습니다.");
                                self.fnLawWaitList();
                                self.fnLawPassedList();
                            }
                        });
                    }
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
                                self.fnLawOutList(); // 다시 불러오기
                            }
                        }
                    });
                },
                fnOutPage(num) {
                    var self = this;
                    self.outPage = num;
                    self.fnLawOutList();
                },
                fnOutPageMove(dir) {
                    var self = this;
                    if (dir === 'prev' && self.outPage > 1) self.outPage--;
                    else if (dir === 'next' && self.outPage < self.outPageCount) self.outPage++;
                    self.fnLawOutList();
                },
                fnComeBack(lawyerId) {
                    var self = this;
                    if (confirm("재가입 승인 하시겠습니까?")) {
                        $.ajax({
                            url: "/admin/lawComeBack.dox",
                            type: "POST",
                            data: { lawyerId: lawyerId },
                            success: function (data) {
                                alert("재가입 되었습니다.");
                                self.fnLawOutList();
                                self.fnLawWaitList();
                                self.fnLawPassedList();
                            }
                        });
                    }
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