<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<title>sample.jsp</title>
    <style>
        .recent-box {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 250px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 999;
            padding: 15px;
        }
        
        .recent-title {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 10px;
            color: var(--main-color);
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        
        .recent-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }
        
        .recent-item {
            display: flex;
            align-items: center;
            padding: 8px 0;
            cursor: pointer;
            border-bottom: 1px solid #f1f1f1;
        }
        
        .recent-item:last-child {
            border-bottom: none;
        }
        
        .thumb {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 6px;
            margin-right: 10px;
            border: 1px solid #ddd;
        }
        
        .item-text {
            flex-grow: 1;
            font-size: 14px;
            color: #333;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
	<div id="recentBox" class="recent-box card">
        <div class="recent-title">최근 본 항목</div>
        <ul class="recent-list">
            <li v-for="item in list" :key="item.id" @click="fnGo(item)" class="recent-item">                
                <div class="item-text">
                    <span v-if="item.type === 'lawyer'">👨‍⚖️ {{ item.name }}</span>
                    <span v-if="item.type === 'board'">📝 {{ item.title }}</span>
                </div>
            </li>
        </ul>
    </div>
</body>
</html>
<script>
    const recentApp = Vue.createApp({
		data() {
			return {
				list: []
			};
		},
		methods: {
			fnGo(item) {
                if (item.type === 'lawyer') {
                    location.href = "/profile/view.do?lawyerId=" + item.id;
                } else if (item.type === 'board') {
                    location.href = "/board/boardView.jsp?boardNo=" + item.id;
                }
            }
		},
		mounted() {
			const stored = localStorage.getItem("recentViewed");
            const allItems = stored ? JSON.parse(stored) : [];

            this.list = allItems;
        }
    });
	recentApp.mount('#recentBox');
</script>​