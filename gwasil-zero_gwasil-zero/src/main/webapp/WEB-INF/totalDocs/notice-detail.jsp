<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<title>공지사항 상세</title>
	</head>
	<style>
		.view-container {
			width: 66%;
			margin: 40px auto;
			padding: 20px;
			border: 1px solid #ddd;
			border-radius: 10px;
			background: white;
		}

		.view-container h2 {
			margin-bottom: 10px;
		}

		.view-meta {
			font-size: 14px;
			color: gray;
			margin-bottom: 20px;
		}

		.view-content {
			white-space: pre-wrap;
			line-height: 1.6;
		}
	</style>

	<body>
		<jsp:include page="../common/header.jsp" />

		<div id="app">
			<div class="view-container" v-if="info">
				<h2>{{ info.totalTitle }}</h2>
				<div class="view-meta">
					작성자: {{ info.userId }} | 작성일: {{ info.cdate }} | 조회수: {{ info.cnt }}
				</div>
				<div class="view-content">
					{{ info.totalContents }}
				</div>
				<div v-if="sessionStatus == 'A'">
					<button @click="fnEdit(info.boardNo)">수정</button>
					<button @click="fnRemove(info.boardNo)">삭제</button>
				</div>
			</div>
			<div style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px;">
				<div v-if="prev" style="margin-bottom: 10px;">
					⬅️ 이전글: <a href="javascript:void(0)" @click="moveTo(prev.totalNo)">{{ prev.totalTitle }}</a>
				</div>
				<div v-if="next">
					➡️ 다음글: <a href="javascript:void(0)" @click="moveTo(next.totalNo)">{{ next.totalTitle }}</a>
				</div>
			</div>
		</div>

		<jsp:include page="../common/footer.jsp" />
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					totalNo: "${map.noticeNo}",
					info: "",
					sessionId: "",
					sessionStatus: "A",
					notice: null, //현재글
					prev: null, //이전글
					next: null //다음글

				};
			},
			methods: {
				fnNoticeView() {
					var self = this;
					var nparmap = {
						totalNo: self.totalNo,
						option: "SELECT" //조회수 증가
					};
					$.ajax({
						url: "/notice/view.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result == "success") {
								console.log(data);
								self.info = data.info;
								self.fnAdjacent(self.totalNo);
							} else {
								alert("오류발생");
							}
						}
					});
				},
				fnAdjacent(no) {
					const self = this;
					$.ajax({
						url: "/notice/adjacent.dox",
						type: "POST",
						dataType: "json",
						data: { totalNo: no },
						success(data) {
							self.prev = data.prev;
							self.next = data.next;
						}
					});
				},
				moveTo(no) {
					pageChange("/notice/detail.do", { totalNo: no });
				}
			},
			mounted() {
				this.fnNoticeView();
			}
		});
		app.mount("#app");
	</script>