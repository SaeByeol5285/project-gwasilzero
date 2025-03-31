<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>과실 ZERO - 교통사고 전문 법률 플랫폼</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b58f49b3384edf05982d77a3259c7afb&libraries=services"></script>
	<script src="/js/page-change.js"></script>
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

		.right-align {
			text-align: right;
			margin-top: 10px;
		}

		.find-me-btn {
			background-color: #b6e388;
			margin-bottom: 20px;
			color: #222;
			border: none;
			padding: 10px 20px;
			border-radius: 8px;
			cursor: pointer;
			font-weight: bold;
			transition: background-color 0.2s ease;
		}

		.find-me-btn:hover {
			background-color: #a4d476;
			color: white;
		}

		.status-badge {
			font-size: 13px;
			padding: 4px 10px;
			border-radius: 12px;
			color: white;
			font-weight: bold;
		}

		.status-badge.now {
			background-color: #4caf50;
		}

		.status-badge.delayed {
			background-color: #ff9800;
		}

		.status-badge.disabled {
			background-color: #f44336;
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

	<!-- ✅ 검색창  -->
	<div class="select-row" v-if="currentTab !== 'area'" style="margin-top: 10px;">
		<input v-model="keyword" class="select-box" style="flex: 1; min-width: 200px;"  @keyup.enter="fnSearchByKeyword" placeholder="지역명을 입력하세요 (예: 강남역)">
		<button class="btn-search" @click="fnSearchByKeyword">지도 이동</button>
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

	<!-- ✅ 근처 법률 사무소 버튼 -->
	<div class="right-align">
		<button class="find-me-btn" @click="geoFindMe">📍 내 위치 보기</button>
	</div>


	<!-- ✅ 지도 -->
	<div id="map"></div>

	<!-- ✅ 거리순 리스트 -->
	<div class="lawyer-list">
		<h3>{{ listTitle }}</h3>
		<!-- ✅ 상담 상태 필터 select 박스 -->
		<div style="text-align: right; margin-bottom: 10px; display: flex; justify-content: flex-end; align-items: center; gap: 8px;">
			<span style="font-weight: bold; font-size: 14px;">현재 상담 가능 여부</span>
			<select v-model="filterStatus" class="select-box" style="width: 160px;">
				<option value="">:: 상담 상태 선택 ::</option>
				<option value="now">상담 가능</option>
				<option value="delayed">상담 지연</option>
				<option value="disabled">상담 불가능</option>
			</select>
		</div>

		<div class="lawyer-card" v-for="lawyer in sortedLawyers" :key="lawyer.lawyerId" @click="goToLawyerMarker(lawyer)">
			<div style="display: flex; justify-content: space-between; align-items: center;">
				<h4 style="margin: 0 0 6px;">{{ lawyer.lawyerName }}</h4>
				<span :class="['status-badge', lawyer.counsel]">
					{{ getStatusText(lawyer.counsel) }} 
				</span>
			</div>
			<p style="margin: 0 0 2px; font-size: 14px;">{{ lawyer.lawyerAddr }}</p>
			<p style="margin: 0; font-size: 13px; color: #888;" v-if="lawyer.distance != undefined">거리: {{ lawyer.distance.toFixed(2) }} km</p>
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
			infowindowAnchor: null,
			keyword : "",
			filterStatus: "",

		};
	},
	watch: {
		currentTab(newTab) {
			this.removeMarkers();
			this.lawyerList = [];

			this.keyword = "";
			this.showNearbyList = false;
			this. filterStatus = "";

			if (newTab === 'area') {
				this.fnSi();
				this.loadLawyers(null);
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
		listTitle() {
			return this.myLatitude && this.myLongitude
				? "📋 법률 사무소 목록 (거리순)"
				: "📋 법률 사무소 목록";
		},
		sortedLawyers() {
			let filtered = [...this.lawyerList];

			if (this.filterStatus) {
				filtered = filtered.filter(lawyer => lawyer.counsel  === this.filterStatus);
			}

			// 거리 정렬 or 이름 정렬
			if (this.myLatitude && this.myLongitude) {
				filtered.sort((a, b) => {
					if (a.distance != undefined && b.distance != undefined) {
						return a.distance - b.distance;
					}
					return 0;
				});
			} else {
				filtered.sort((a, b) => a.lawyerName.localeCompare(b.lawyerName));
			}

			return filtered;
		}

	},



	methods: {
		fnSi() {
			let self = this;
			$.post('/si.dox', {}, function(res) {
				self.siList = res.siList;
			});
		},
		fnGu() {
			let self = this;

			self.selectGu = '';
			self.selectDong = '';
			self.guList = [];
			self.dongList = [];

			$.post('/gu.dox', { si: self.selectSi }, function(res) {
				self.guList = res.guList;
			});
		},
		fnDong() {
			let self = this;
			self.selectDong = '';
			self.dongList = [];
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
					self.map.setLevel(3);
				} else {
					alert("해당 주소를 찾을 수 없습니다.");
				}
			});
		},

		geoFindMe() {
			const self = this;

			// ✅ 이미 위치를 가져온 적이 있으면 바로 처리
			if (self.myLatitude && self.myLongitude) {
				self.showMyLocation();  // 위치 마커만 다시 표시
				return;
			}

			// ✅ 브라우저 위치 지원 여부
			if (!navigator.geolocation) {
				alert("브라우저가 위치 정보를 지원하지 않아요.");
				return;
			}

			// ✅ localStorage에 동의 여부 저장
			const alreadyAgreed = localStorage.getItem("geoPermission");

			if (!alreadyAgreed) {
				const agree = confirm("지도에서 사용자의 위치에 접근하도록 허용하겠습니까?");
				if (!agree) return;
				localStorage.setItem("geoPermission", "yes");
			}

			navigator.geolocation.getCurrentPosition((position) => {
				self.myLatitude = position.coords.latitude;
				self.myLongitude = position.coords.longitude;

				self.showMyLocation();  // 마커 띄우기 + 거리 계산

			}, () => {
				alert("현재 위치를 가져오지 못했습니다.");
			});
		},

		showMyLocation() {
			const self = this;
			const currentPos = new kakao.maps.LatLng(self.myLatitude, self.myLongitude);
			self.map.setCenter(currentPos);
			self.map.setLevel(3);

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

			// 거리 다시 계산
			self.calculateDistances();
		},

		loadLawyers(status) {
			const self = this;
			self.lawyerList = [];

			const params = {};
			if (status != null && status !== '') {
				params.lawyerStatus = status;
			}
			

			$.post("/lawyer/list.dox", params, function(res) {
				const geocoder = new kakao.maps.services.Geocoder();

				const promises = res.lawyerList.map(lawyer => {
					return new Promise((resolve) => {
						// ✅ 주소 유효성 검사
						if (!lawyer.lawyerAddr || lawyer.lawyerAddr.trim() === "") {
							resolve(lawyer); // 주소 없으면 스킵
							return;
						}

						geocoder.addressSearch(lawyer.lawyerAddr, function(result, status) {
							if (status === kakao.maps.services.Status.OK) {
								// 정상 좌표 추출
								const lat = parseFloat(result[0].y);
								const lng = parseFloat(result[0].x);
								lawyer._lat = lat;
								lawyer._lng = lng;

								if (self.myLatitude && self.myLongitude) {
									const dist = self.getDistanceFromLatLonInKm(self.myLatitude, self.myLongitude, lat, lng);
									lawyer._dist = dist;
								}
							}
							resolve(lawyer); // 주소가 이상하거나 실패해도 무조건 resolve
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
							marker.lawyerId = lawyer.lawyerId;
							self.markers.push(marker);
							kakao.maps.event.addListener(marker, 'click', function () {
							
								if (self.infowindowAnchor == lawyer.lawyerId) {
									self.infowindow.close();
									self.infowindowAnchor = null;
									return;
								}

								// 먼저 기존 인포윈도우 닫기
								self.infowindow.close();

								// 새로운 마커에 대한 인포윈도우 열기
								const contentHtml = `
									<div style="
										width: 230px;
										padding: 12px;
										border-radius: 10px;
										box-shadow: 0 2px 8px rgba(0,0,0,0.15);
										background-color: white;
										font-family: 'Noto Sans KR', sans-serif;
									">
										<h4 style="margin: 0 0 8px 0; font-size: 16px; color: #333;">` + lawyer.lawyerName + `</h4>
										<p style="margin: 0 0 4px 0; font-size: 13px; color: #666;">📍 ` + lawyer.lawyerAddr + `</p>
										<p style="margin: 0 0 8px 0; font-size: 13px; color: #666;">📞 ` + lawyer.lawyerPhone + `</p>
									</div>
								`;


								self.infowindow.setContent(contentHtml);
								self.infowindow.open(self.map, marker);
								self.infowindowAnchor = lawyer.lawyerId;  // 현재 마커 저장
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
			let updateCount = 0;

			self.lawyerList.forEach((lawyer, index) => {

				if (!lawyer.lawyerAddr || lawyer.lawyerAddr.trim() === "") {
					updateCount++;
					if (updateCount === self.lawyerList.length) {
						self.lawyerList = [...self.lawyerList];
					}
					return;
				}

				geocoder.addressSearch(lawyer.lawyerAddr, function (result, status) {

					if (status === kakao.maps.services.Status.OK) {
						const lawyerLat = parseFloat(result[0].y);
						const lawyerLng = parseFloat(result[0].x);
						const distance = self.getDistanceFromLatLonInKm(
							self.myLatitude, self.myLongitude, lawyerLat, lawyerLng
						);
						self.lawyerList[index].distance = distance;
					}
					updateCount++;
					if (updateCount === self.lawyerList.length) {
						self.lawyerList = [...self.lawyerList];
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

		getStatusText(status) {
			switch(status) {
				case 'now': return '상담 가능';
				case 'delayed': return '상담 지연';
				case 'disabled': return '상담 불가능';
				default: return '';
			}
		},

		removeMarkers() {
			this.markers.forEach(marker => marker.setMap(null));
			this.markers = [];
			if (this.infowindow) this.infowindow.close();
			this.infowindowAnchor = null;
			if (this.myLocationMarker) this.myLocationMarker.setMap(null);
			if (this.myLocationInfoWindow) this.myLocationInfoWindow.close();
			
		},

		goToLawyerMarker(lawyer) {
			const self = this;
			if (!lawyer._lat || !lawyer._lng) return;

			const position = new kakao.maps.LatLng(lawyer._lat, lawyer._lng);
			self.map.panTo(position);  // 부드럽게 이동

			// 기존 인포윈도우 닫기
			if (self.infowindow) self.infowindow.close();

			// 새 인포윈도우 열기
			const contentHtml = `
									<div style="
										width: 230px;
										padding: 12px;
										border-radius: 10px;
										box-shadow: 0 2px 8px rgba(0,0,0,0.15);
										background-color: white;
										font-family: 'Noto Sans KR', sans-serif;
									">
										<h4 style="margin: 0 0 8px 0; font-size: 16px; color: #333;">` + lawyer.lawyerName + `</h4>
										<p style="margin: 0 0 4px 0; font-size: 13px; color: #666;">📍 ` + lawyer.lawyerAddr + `</p>
										<p style="margin: 0 0 8px 0; font-size: 13px; color: #666;">📞 ` + lawyer.lawyerPhone + `</p>
									</div>
								`;


			self.infowindow.setContent(contentHtml);
			self.infowindow.open(self.map, self.findMarkerByLawyer(lawyer));
			self.infowindowAnchor = self.findMarkerByLawyer(lawyer);
		},

		findMarkerByLawyer(lawyer) {
			return this.markers.find(marker => marker.lawyerId === lawyer.lawyerId);
		},

		fnSearchByKeyword() {
			const self = this;
			const keyword = self.keyword ? self.keyword.trim() : "";

			if (!keyword) {
				alert("검색어를 입력해주세요.");
				return;
			}

			const ps = new kakao.maps.services.Places();
			ps.keywordSearch(keyword, function(data, status) {
				if (status === kakao.maps.services.Status.OK) {
					const coords = new kakao.maps.LatLng(data[0].y, data[0].x);
					self.map.setCenter(coords);
					self.map.setLevel(3); // 지도 확대 정도
				} else {
					alert("검색한 장소를 찾을 수 없습니다.");
				}
			});
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

		this.loadLawyers(null);

	}
});
mapApp.mount('#mapApp');
</script>
</html>
