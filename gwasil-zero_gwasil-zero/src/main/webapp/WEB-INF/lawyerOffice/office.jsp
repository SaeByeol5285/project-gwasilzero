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
			flex-wrap: wrap;
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
			display: block;
			text-align: center;
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
		.find-me-btn {
			margin: 20px auto;
			display: block;
			background-color: #ff5c00;
			color: white;
			border: none;
			padding: 10px 20px;
			border-radius: 8px;
			cursor: pointer;
			font-weight: bold;
		}
		.lawyer-list {
			margin-top: 30px;
			background-color: #f8f8f8;
			padding: 20px;
			border-radius: 10px;
		}
		.lawyer-list h3 {
			margin-bottom: 15px;
			color: #333;
		}
		.lawyer-list ul {
			list-style: none;
			padding: 0;
		}
		.lawyer-list li {
			padding: 10px;
			border-bottom: 1px solid #ddd;
		}

		.lawyer-card {
			border: 1px solid #ddd;
			border-radius: 8px;
			padding: 15px;
			margin-bottom: 12px;
			box-shadow: 0 1px 3px rgba(0,0,0,0.05);
			transition: all 0.2s ease;
		}

		.lawyer-card:hover {
			background-color: #fdf4ec;
		}

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

	<!-- ✅ 지역 선택 -->
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

	<!-- ✅ 내 위치 보기 버튼 -->
	<button class="find-me-btn" @click="geoFindMe">📍 내 위치 보기</button>

	<!-- ✅ 지도 -->
	<div id="map"></div>
	<!-- ✅ 거리순 리스트 -->
	<div v-if="lawyerList.length > 0" class="lawyer-list">
		<h3>📍 거리순 변호사 리스트</h3>
		<div class="lawyer-card" v-for="lawyer in lawyerList" :key="lawyer.lawyerNo">
			<p><strong>{{ lawyer.lawyerName }}</strong></p>
			<p>{{ lawyer.lawyerAddr }}</p>
			<p v-if="lawyer._dist !== null">거리: {{ lawyer._dist.toFixed(2) }} km</p>
		</div>
	</div>

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
			selectDong: '',
			locationStatus: '',
			mapLink: '',
			mapLinkText: '',
			myLocationMarker: null,
			myLocationInfoWindow: null,
			myLatitude: null,
			myLongitude: null,
			lawyerList: [],


		};
	},
	watch: {
		currentTab(newTab) {
			this.removeMarkers();
			this.lawyerList = [];

			if (newTab === 'area') {
				this.fnSi();

				// ✅ 기본 검색 실행하도록 추가
				if (this.selectSi && this.selectGu && this.selectDong) {
					this.fnSearchArea();
				}

			} else if (newTab === 'inner') {
				this.loadLawyers('I');
			} else {
				this.loadLawyers('P');
			}
		}
	},

	computed: {
		sortedLawyers() {
			return this.lawyerList
				.filter(lawyer => lawyer.distance !== undefined)
				.sort((a, b) => a.distance - b.distance);
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

		geoFindMe() {
			const self = this;
			if (!navigator.geolocation) {
				alert("브라우저가 위치 정보를 지원하지 않아요.");
				return;
			}
			navigator.geolocation.getCurrentPosition((position) => {
				const latitude = position.coords.latitude;
				const longitude = position.coords.longitude;

				self.myLatitude = latitude;
				self.myLongitude = longitude;

				const currentPos = new kakao.maps.LatLng(latitude, longitude);
				self.map.setCenter(currentPos);

				// 기존 마커 제거
				if (self.myLocationMarker) self.myLocationMarker.setMap(null);
				if (self.myLocationInfoWindow) self.myLocationInfoWindow.close();

				// 내 위치 마커 표시
				self.myLocationMarker = new kakao.maps.Marker({
					map: self.map,
					position: currentPos,
					title: "내 위치"
				});
				self.myLocationInfoWindow = new kakao.maps.InfoWindow({
					content: "<div style='padding:5px;'>📍 내 위치</div>"
				});
				self.myLocationInfoWindow.open(self.map, self.myLocationMarker);

				// ✅ 거리 계산 다시 적용
				self.calculateDistances();
			}, () => {
				alert("현재 위치를 가져오지 못했습니다.");
			});
		},

		loadLawyers(status) {
			const self = this;
			self.lawyerList = [];

			$.post("/lawyer/list.dox", { lawyerStatus: status }, function(res) {
				const geocoder = new kakao.maps.services.Geocoder();

				const promises = res.lawyerList.map(lawyer => {
					return new Promise((resolve) => {
						geocoder.addressSearch(lawyer.lawyerAddr, function(result, status) {
							if (status === kakao.maps.services.Status.OK) {
								const lat = parseFloat(result[0].y);
								const lng = parseFloat(result[0].x);
								lawyer._lat = lat;
								lawyer._lng = lng;

								// 거리 계산 (내 위치 기준)
								if (self.myLatitude && self.myLongitude) {
									const dist = self.getDistance(self.myLatitude, self.myLongitude, lat, lng);
									lawyer._dist = dist;
								} else {
									lawyer._dist = null;
								}
							}
							resolve(lawyer);
						});
					});
				});

				Promise.all(promises).then((lawyers) => {
					// 거리순 정렬
					if (self.myLatitude && self.myLongitude) {
						lawyers.sort((a, b) => a._dist - b._dist);
					}
					self.lawyerList = lawyers;
					self.calculateDistances();
					self.removeMarkers();

					// 마커 표시
					lawyers.forEach(lawyer => {
						if (lawyer._lat && lawyer._lng) {
							const pos = new kakao.maps.LatLng(lawyer._lat, lawyer._lng);
							const marker = new kakao.maps.Marker({
								map: self.map,
								position: pos
							});
							self.markers.push(marker);
							kakao.maps.event.addListener(marker, 'click', function () {
								self.infowindow.setContent(`<div style="padding:5px;">` + lawyer.lawyerName + `<br>` + lawyer.lawyerAddr + `</div>`);
								self.infowindow.open(self.map, marker);
							});
						}
					});
				});
			});
		},

		// ✅ 거리 계산 함수 (단위: km)
		calculateDistances() {
			const self = this;
			if (!self.myLatitude || !self.myLongitude) return;

			let geocoder = new kakao.maps.services.Geocoder();

			self.lawyerList.forEach((lawyer) => {
				geocoder.addressSearch(lawyer.lawyerAddr, function (result, status) {
					if (status === kakao.maps.services.Status.OK) {
						const lawyerLat = parseFloat(result[0].y);
						const lawyerLng = parseFloat(result[0].x);
						const distance = self.getDistanceFromLatLonInKm(self.myLatitude, self.myLongitude, lawyerLat, lawyerLng);
						lawyer.distance = distance;
					}
				});
			});
		},

		// 거리 계산 공식 (Haversine)
		getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
			const R = 6371; // 지구 반지름 (km)
			const dLat = this.deg2rad(lat2 - lat1);
			const dLon = this.deg2rad(lon2 - lon1);
			const a =
				Math.sin(dLat / 2) * Math.sin(dLat / 2) +
				Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) *
				Math.sin(dLon / 2) * Math.sin(dLon / 2);
			const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
			const d = R * c;
			return d;
		},
		deg2rad(deg) {
			return deg * (Math.PI / 180);
		},


		removeMarkers() {
			this.markers.forEach(marker => marker.setMap(null));
			this.markers = [];
			if (this.infowindow) this.infowindow.close();
			if (this.myLocationMarker) this.myLocationMarker.setMap(null);
			if (this.myLocationInfoWindow) this.myLocationInfoWindow.close();
		},

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
