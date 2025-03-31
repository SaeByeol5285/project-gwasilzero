    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        
            <meta charset="UTF-8">
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
            <link rel="stylesheet" href="/css/header.css">
            <link rel="stylesheet" href="/css/common.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
            <title>header.jsp</title>
        
            <div id="header">
                <header>
                    <!-- 상단 로그인 / 고객센터 라인 -->
                    <div class="header-line">
                        <a href="#">고객만족센터</a>
                        <a v-if="!id" href="/user/login.do">로그인 / 회원가입</a>
                        <a v-else @click="fnLogout">로그아웃</a>
                        <a v-if="id && id !== ''" :href="fnMyPage()">마이페이지</a>
                    </div>

                    <!-- 네비게이션 바 -->
                    <nav class="main-nav-wrapper">
                        <div class="main-nav">
                            <!-- 로고 -->
                            <a href="/common/main.do" class="logo">
                                <img src="/img/logo1.png" alt="로고 이미지">
                            </a>

                            <!-- 메뉴 -->
                            <ul class="main-menu">
                                <li class="menu-item" v-for="(item, index) in menuItems" :key="index">
                                    <a :href="item.url" class="menu-font">{{ item.name }}</a>
                                    <div class="dropdown" v-if="sections[index] && sections[index].length">
                                        <ul>
                                            <li v-for="(sub, i) in sections[index]" :key="i">
                                                <a href="#">{{ sub }}</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="menu-item" v-if="sessionStatus == 'A'">
                                    <a href="/admin/main.do" class="menu-font">관리자 페이지</a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </header>
            </div>

        <script>
            const header = Vue.createApp({
                data() {
                    return {
                        id: "${sessionId}",
                        location: "${location}",
                        sessionStatus: "${sessionStatus}",
                        menuItems: [
                            { name: '회사 소개', url: '/common/introduce.do' },
                            { name: '패키지 소개', url: '/package/package.do' },
                            { name: '구성원', url: '/profile/innerLawyer.do' },
                            { name: '게시판', url: '/board/list.do' },
                            { name: '통합 자료실', url: '/totalDocs/list.do' }
                        ],
                        sections: [
                            [],
                            [],
                            ['소속 변호사', '개인 변호사', '사무소 위치'],
                            [],
                            ['공지사항', 'Q & A', '사건 종류 가이드']
                        ]
                    }
                },
                methods : {
                    fnLogout() {
                        var self = this;
                        var nparmap = {
                        };
                        $.ajax({
                            url: "/user/logout.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("sessionId =====> " + self.id);
                                    alert("로그아웃 되었습니다.");
                                    location.href = "/common/main.do"; // 로그아웃 후 이동할 페이지
                                } else {
                                    alert("로그아웃 실패");
                                }
                            }
                        });
                    },

                    fnMyPage() {
                        if (this.sessionStatus === 'NORMAL') {
                            return '/mypage/mypage-home.do';
                        } else if (this.sessionStatus === 'I' || this.sessionStatus === 'P') {
                            return '/mypage/lawyerMyPage.do';
                        } else {
                            return '#';
                        }
                    }
                },

                mounted() { 
                    console.log("id =====> " + this.id);
                    console.log("sessionStatus =====> " + this.sessionStatus);
                }
            });
            header.mount('#header');
        </script>