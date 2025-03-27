<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="/css/footer.css">
        <link rel="stylesheet" href="/css/common.css"> 
        <title>footer.jsp</title>
        <style>
        </style>
    </head>

    <body>
        <div id="footer">
            <footer class="footer-container">
                <div class="footer-inner">
                    <!-- 로고 및 하단 링크 -->
                    <div class="footer-top">
                        <img src="/img/logo1.png" alt="법무법인 과실제로 로고" class="footer-logo" />
                        <div class="footer-links">
                            <a href="#">면책공고</a>
                            <a href="#">유한책임</a>
                            <a href="#">개인정보처리방침</a>
                            <a href="#">이메일무단수집거부</a>
                            <a href="#" class="highlight">고객만족센터</a>
                        </div>
                    </div>

                    <!-- 주소 및 정보 -->
                    <div class="footer-info">
                        <p>주소: 서울특별시 OO구 OO로 123, OOO빌딩 10층</p>
                        <p>사업자등록번호 123-45-67890 | 법률상담접수 1800-1234 | 광고책임변호사 홍길동</p>
                        <p>&copy; 2025 법무법인 과실제로 All rights reserved.</p>
                    </div>
                </div>
            </footer>
        </div>
    </body>

    </html>
    <script>
        const footer = Vue.createApp({
            data() {
                return {
                                    
                }
            },
            mounted() {
            }
        });
        footer.mount('#footer');
    </script>

    ​