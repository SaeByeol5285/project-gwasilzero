<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>변호사 지도 보기</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b58f49b3384edf05982d77a3259c7afb&libraries=services"></script>
	<style>
		.container { max-width: 900px; margin: 40px auto; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); background: #fff; }
		.tabs { display: flex; justify-content: center; gap: 10px; margin-bottom: 20px; }
		.tab-btn {
			padding: 10px 20px;
            border: none;
            background-color: #eee;
            color: #444;
            border-radius: 8px 8px 0 0;
            font-weight: 500;
            cursor: pointer;
            margin-right: 5px;
            transition: background-color 0.3s ease;
		}
		.tab-btn.active {
            background-color: #b6e388; 
            color: white;          
            font-weight: bold;
		}
		.select-row {
			display: flex;
			justify-content: center;
			gap: 10px;
			margin-bottom: 10px;
		}
		.select-box {
			padding: 6px 10px;
			border-radius: 6px;
			border: 1px solid #ccc;
		}
		.btn-search {
			padding: 8px 16px;
            background-color: #b6e388; 
            color: #333;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
		}
        .btn-search:hover {
            background-color: #a4d476; 
            color: white;
        }
        .section-subtitle {
			font-size: 28px;
			font-weight: bold;
			margin-bottom: 30px;
			text-align: center;
			color: #222;
			position: relative;
			display: inline-block;
			padding-bottom: 10px;

			display: block;
			text-align: center;
			margin-left: auto;
			margin-right: auto;
		}
	
		.section-subtitle::after {
			content: "";
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
			bottom: 0;
			width: 60px;
			height: 3px;
			background-color: #FF5722;
			border-radius: 2px;
		}
		#map { width: 100%; height: 500px; border-radius: 10px; }
	</style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <h2 class="section-subtitle">법률사무소 찾기</h2>
    <div id="mapApp" class="container">
        
        <!-- ✅ 탭 -->
        <div class="tabs">
            <button class="tab-btn" :class="{active: currentTab==='area'}" @click="currentTab='area'">지역별</button>
            <button class="tab-btn" :class="{active: currentTab==='inner'}" @click="currentTab='inner'">소속 변호사</button>
            <button class="tab-btn" :class="{active: currentTab==='personal'}" @click="currentTab='personal'">개인 변호사</button>
        </div>

        <!-- ✅ 지역 선택 (지역별 탭일 때만 표시) -->
        <div v-if="currentTab==='area'" class="select-row">
            <select v-model="selectSi" @change="fnGu" class="select-box">
                <option value="">:: 시 선택 ::</option>
                <option v-for="item in siList" :value="item.si">{{ item.si }}</option>
            </select>
            <select v-model="selectGu" @change="fnDong" class="select-box">
                <option value="">:: 구 선택 ::</option>
                <option v-for="item in guList" :value="item.gu">{{ item.gu }}</option>
            </select>
            <select v-model="selectDong" class="select-box">
                <option value="">:: 동 선택 ::</option>
                <option v-for="item in dongList" :value="item.dong">{{ item.dong }}</option>
            </select>
            <button class="btn-search" @click="fnSearchArea">검색</button>
        </div>

        <!-- ✅ 지도 -->
        <div id="map"></div>
    </div>
    <jsp:include page="../common/footer.jsp" />
</body>

<script>
	const mapApp = Vue.createApp({
		data() {
			return {
				currentTab: 'area',
				map: null,
				infowindow: null,
				markers: [],
				siList: [],
				guList: [],
				dongList: [],
				selectSi: '',
				selectGu: '',
				selectDong: ''
			};
		},
		watch: {
			currentTab(newTab) {
				this.removeMarkers();
				if (newTab === 'area') {
					this.fnSi();
				} else if (newTab === 'inner') {
					this.loadLawyers('I');
				} else {
					this.loadLawyers('P');
				}
			}
		},
		methods: {
			fnSi() {
				let self = this;
				$.post('/si.dox', {}, function(res) {
					self.siList = res.siList;
					self.guList = [];
					self.dongList = [];
					self.selectGu = '';
					self.selectDong = '';
				});
			},
			fnGu() {
				let self = this;
				$.post('/gu.dox', { si: self.selectSi }, function(res) {
					self.guList = res.guList;
					self.dongList = [];
					self.selectDong = '';
				});
			},
			fnDong() {
				let self = this;
				$.post('/dong.dox', { si: self.selectSi, gu: self.selectGu }, function(res) {
					self.dongList = res.dongList;
				});
			},
			fnSearchArea() {
				let self = this;
				if (!self.selectSi || !self.selectGu || !self.selectDong) {
					alert("시/구/동을 모두 선택해주세요.");
					return;
				}
				let fullAddr = self.selectSi + " " + self.selectGu + " " + self.selectDong;
				let geocoder = new kakao.maps.services.Geocoder();
				geocoder.addressSearch(fullAddr, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
						self.map.setCenter(coords);
					} else {
						alert("해당 주소를 찾을 수 없습니다.");
					}
				});
			},
			loadLawyers(lawyerStatus) {
				let self = this;
				$.post('/lawyer/list.dox', { lawyerStatus: lawyerStatus }, function(res) {
					let geocoder = new kakao.maps.services.Geocoder();
					res.lawyerList.forEach((lawyer) => {
						geocoder.addressSearch(lawyer.lawyerAddr, function(result, status) {
							if (status === kakao.maps.services.Status.OK) {
								let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
								let marker = new kakao.maps.Marker({ map: self.map, position: coords });
								self.markers.push(marker);
								kakao.maps.event.addListener(marker, 'click', function () {
                                    console.log(lawyer);
									self.infowindow.setContent(`<div style="padding:5px;"> ` + lawyer.lawyerName + ` <br> ` + lawyer.lawyerAddr + `</div>`);
									self.infowindow.open(self.map, marker);
								});
							}
						});
					});
				});
			},

			removeMarkers() {
                this.markers.forEach(marker => marker.setMap(null));
                this.markers = [];

                if (this.infowindow) {
                    this.infowindow.close();
                }
            }

		},
		mounted() {

            this.fnSi();

			let container = document.getElementById('map');
			let options = {
				center: new kakao.maps.LatLng(37.566826, 126.9786567),
				level: 5
			};
			this.map = new kakao.maps.Map(container, options);
			this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
            

			
		}
	});
	mapApp.mount('#mapApp');
</script>
</html>
