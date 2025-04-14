<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
			      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
    
    <!-- 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/common.css">
	
    <!-- 상품 관리 선택 유지 -->
    <%
    request.setAttribute("currentPage", "product");
    %>


    <style>
        .form-wrapper {
            width: 1000px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .form-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
            text-align: center;
            color: #333;
        }

        .form-table {
            width: 100%;
        }

        .form-table th {
            text-align: left;
            padding: 10px 0 10px 16px; /* 왼쪽 여백 추가 */
            color: #555;
            width: 130px;
            vertical-align: top; /* 설명 textarea 길 때 정렬 맞춤 */
        }

        .form-table td {
            padding: 10px 16px; /* 좌우 패딩 추가 */
        }

        .input-box {
            width: 100%;
            box-sizing: border-box; /* ✅ padding 포함 너비 계산 */
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        .textarea-box {
            resize: vertical;
            min-height: 100px;
            line-height: 1.5;
        }

        .btn-area {
            text-align: center;
            margin-top: 30px;
        }

        .btn {
            font-family: 'Noto Sans KR', sans-serif !important;
            padding: 10px 24px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin: 0 8px;
        }

        .btn-save {
            background-color: #ff5c00; /* 눈에 확 띄는 주황색 */
            color: #fff;
        }

        .btn-save:hover {
            background-color: #e55300;
        }

        .btn-cancel {
            background-color: #ccc;
            color: #333;
        }

        .btn-cancel:hover {
            background-color: #bbb;
        }
    </style>
</head>
<body>
    <div id="editApp">
        <jsp:include page="../admin/layout.jsp" />
        <div class="layout">
            <div class="content">
                <div class="form-wrapper">
                    <div class="form-title">패키지 수정</div>
                    <table class="form-table">
                        <tr>
                            <th>패키지명</th>
                            <td><input type="text" v-model="info.packageName" class="input-box" readonly></td>
                        </tr>
                        <tr>
                            <th>패키지 설명</th>
                            <td>
                                <textarea v-model="info.packageInfo" class="input-box textarea-box" rows="4"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th>패키지 가격</th>
                            <td><input type="number" v-model="info.packagePrice" class="input-box"></td>
                        </tr>
                        <tr>
                            <th>사용자</th>
                            <td>
                                <select v-model="info.packageStatus" class="input-box">
                                    <option value="U">일반 사용자</option>
                                    <option value="L">변호사</option>
                                </select>
                            </td>
                        </tr>
                    </table>

                    <div class="btn-area">
                        <button class="btn btn-save" @click="fnSave">저장</button>
                        <button class="btn btn-cancel" @click="fnBack">뒤로가기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
const editApp = Vue.createApp({
    data() {
        return {
            packageName: "${map.packageName}",
            info: {}
        };
    },
    methods: {
        fnLoad() {
            const self = this;
            let nparmap = {
                packageName: self.packageName
            };

            $.ajax({
                url: "/admin/product/edit.dox",
                type: "POST",
                dataType: "json",
                data: nparmap,
                success(data) {
                    if (data.result === 'success') {
                        self.info = data.info;
                    } else {
                        Swal.fire("오류", "패키지 정보를 불러오지 못했습니다.", "error");
                    }
                }
            });
        },
        fnSave() {
            const self = this;
            Swal.fire({
                title: '저장하시겠습니까?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: '저장',
                cancelButtonText: '취소'
            }).then(result => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: "/admin/product/editSave.dox",
                        type: "POST",
                        dataType: "json",
                        data: self.info,
                        success(data) {
                            if (data.result === "success") {
                                Swal.fire("저장 완료", "패키지 정보가 수정되었습니다.", "success")
                                    .then(() => {
                                        location.href = "/admin/product.do";
                                    });
                            } else {
                                Swal.fire("오류", "저장에 실패했습니다.", "error");
                            }
                        }
                    });
                }
            });
        },
        fnBack() {
            location.href = "/admin/product.do?page=product";
        }

    },
    mounted() {
        this.fnLoad();
    }
});
editApp.mount('#editApp');
</script>
</html>
