<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="icon" type="image/png" href="/img/common/logo3.png">
	      <title>과실ZERO - 교통사고 전문 법률 플랫폼</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b58f49b3384edf05982d77a3259c7afb&libraries=services"></script>
	<script src="/js/page-change.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
	<style>
		.tabs { display: flex; justify-content: center; gap: 10px; margin-bottom: 40px; }
		*,
		*::before,
		*::after {
			font-family: 'Noto Sans KR', sans-serif;
			box-sizing: border-box;
		}

		.tab-btn {
			padding: 12px 24px;
			border: none;
			border-radius: 999px;
			background-color: #f6f6f6;
			font-size: 16px;
			font-weight: 500;
			color: #444;
			cursor: pointer;
			transition: all 0.2s ease;
			box-shadow: inset 0 0 0 1px #ddd;
		}

		.tab-btn:hover {
			background-color: #ffece1;
			color: #ff5c00;
		}

		.tab-btn.active {
			background-color: #ff5c00;
			color: #fff;
			font-weight: 600;
			box-shadow: none;
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
			background-color: #ff5c00; 
			color: white;
			border: none;
			border-radius: 6px;
			font-weight: bold;
			cursor: pointer;
			transition: background-color 0.2s;
			margin-right: 40px;
		}
		.btn-search:hover {
			background-color: #ffe6db; 
			color: #ff5c00;
		}
		.section-subtitle {
			font-size: 28px;
			font-weight: bold;
			margin-bottom: 1px;
			text-align: center;
			color: #222;
			position: relative;
			display: inline-block;
			padding-top: 40px;
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
			background-color: var(--main-color);
			border-radius: 2px;
		}
		#map { width: 100%; height: 500px; border-radius: 10px; }
		
		.lawyer-list {
			margin-top: 30px;
			background-color: white;
	        border-radius: 10px;
	        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
			padding: 20px;
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
			background-color: #ff5c00;
			margin-bottom: 20px;
			color: white;
			border: none;
			padding: 10px 20px;
			border-radius: 8px;
			cursor: pointer;
			font-weight: bold;
			transition: background-color 0.2s ease;
		}

		.find-me-btn:hover {
			background-color: #ffe6db;
			color: #ff5c00;
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

		.btn-search.active {
		background-color: #ff5c00;
		color: white;
		}

		.pagination-container {
			display: flex;
			justify-content: center;
			align-items: center;
			margin-top: 30px;
			margin-bottom: 20px;
			gap: 6px;
		}

		.btn {
			padding: 10px 18px;
			font-size: 15px;
			border: none;
			border-radius: 8px;
			background-color: #f2f2f2;
			color: #444;
			font-weight: 500;
			cursor: pointer;
			transition: all 0.2s ease;
		}

		.btn:hover {
			background-color: #ffe6db;
			color: #ff5c00;
		}

		.btn.active {
			background-color: #ff5c00;
			color: white;
			font-weight: bold;
			box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		}

		.btn:disabled {
			opacity: 0.4;
			cursor: default;
		}
	</style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<h2 class="section-subtitle">법률 사무소 찾기</h2>
<div id="mapApp" class="container">

	<!-- ✅ 탭 + 버튼 묶는 wrapper -->
	<div style="position: relative; margin-bottom: 30px;">
		<!-- 가운데 정렬된 탭들 -->
		<div class="tabs" style="justify-content: center;">
			<a href="?tab=area"><button class="tab-btn" :class="{active: currentTab =='area'}">지역별</button></a>
			<a href="?tab=inner"><button class="tab-btn" :class="{active: currentTab =='inner'}">소속 변호사</button></a>
			<a href="?tab=personal"><button class="tab-btn" :class="{active: currentTab =='personal'}">개인 변호사</button></a>
		</div>

		<!-- 오른쪽 끝에 고정된 버튼 -->
		<button class="find-me-btn"
			style="position: absolute; top: 1; right: 0; height: 75%; margin-bottom: 10px;"
			@click="geoFindMe"
			title="실제 위치와 차이가 있을 수 있습니다;">📍 내 위치 보기</button>
	</div>

	<div class="select-row" v-if="currentTab !== 'area'" style="margin-top: 10px;">
		<input v-model="keyword" class="select-box" style="flex: 1; max-width: 800px;"  @keyup.enter="fnSearchByKeyword" placeholder="지역명을 입력하세요 (예: 강남역)">
		<button class="btn-search" @click="fnSearchByKeyword">지도 이동</button>
	</div>

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

	<!-- 카카오 지도 -->
	<div id="map"></div>

	<!-- 법률 사무소 목록 -->
	<div class="lawyer-list">
		<h3>{{ listTitle }}</h3>

		<!-- 상담 상태 확인 -->
		<div style="text-align: right; margin-bottom: 10px; display: flex; justify-content: flex-end; align-items: center; gap: 8px;">
			<span style="font-weight: bold; font-size: 14px;">현재 상담 가능 여부</span>
			<select v-model="filterStatus" class="select-box" style="width: 160px;">
				<option value="">:: 전체 ::</option>
				<option value="now">상담 가능</option>
				<option value="delayed">상담 지연</option>
				<option value="disabled">상담 불가능</option>
			</select>
		</div>

		<div class="lawyer-card" v-for="lawyer in pagedLawyers" :key="lawyer.lawyerId"  @click="goToLawyerMarker(lawyer)">
			<div style="display: flex; justify-content: space-between; align-items: flex-start;">
			  
			  <div style="display: flex; gap: 16px; align-items: flex-start;">
				<!-- 변호사 사진 -->
				<img :src="lawyer.lawyerImg" alt="변호사 사진"
				  style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover; border: 1px solid #ddd;" />
		  
				<!-- 텍스트 영역 -->
				<div>
				  <div style="display: flex; align-items: center; gap: 8px;">
					<h4 style="margin: 0;">{{ lawyer.lawyerName }}</h4>
					<span :class="['status-badge', lawyer.counsel]">
					  {{ getStatusText(lawyer.counsel) }}
					</span>
				  </div>
		  
				  <p style="margin: 4px 0; font-size: 14px;">{{ lawyer.lawyerAddr }}</p>
				  <p v-if="lawyer.distance !== undefined" style="margin: 0; font-size: 13px; color: #888;">
					거리: {{ lawyer.distance.toFixed(2) }} km
				  </p>
				</div>
			  </div>
		  
			  <!-- 북마크 -->
			  <div v-if="sessionType != 'lawyer'" style="display: flex; flex-direction: column; align-items: flex-end; justify-content: flex-end; height: 100%;">
				<img
				  :src="isBookmarked(lawyer.lawyerId) ? '/img/selectedBookmark.png' : '/img/Bookmark.png'"
				  @click.stop="toggleBookmark(lawyer.lawyerId)"
				  alt="북마크"
				  style="width: 24px; height: 24px; cursor: pointer; margin-top: 8px;" />
			  </div>
			  
			</div>
		</div>	
		
		<div class="pagination-container">
			<button class="btn" @click="page > 1 && (page--)" :disabled="page === 1">〈 이전</button>
		  
			<button
			  v-for="n in pageCount"
			  :key="n"
			  @click="page = n"
			  :class="['btn', page === n ? 'active' : '']"
			>
			  {{ n }}
			</button>
		  
			<button class="btn" @click="page < pageCount && (page++)" :disabled="page === pageCount">다음 〉</button>
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
			sessionId : "${sessionId}",
			sessionType : "${sessionType}",
			bookmarkList : [],
			laweyrId : "",
			page : 1,
			index : 0,
			pageSize : 5

		};
	},
	watch: {
		currentTab(newTab) {
			this.removeMarkers();
			this.lawyerList = [];

			this.keyword = "";
			this.showNearbyList = false;
			this.filterStatus = "";

			if (newTab === 'area') {
				this.fnSi();
				this.loadLawyers(null);
				// ✅ 기본 검색 실행하도록 추가
				if (this.selectSi && this.selectGu && this.selectDong) {
					this.fnSearchArea();
				}

			} else if (newTab === 'inner') { // 소속 변호사
				this.loadLawyers('I');
			} else {
				this.loadLawyers('P');
			}

		},

		filterStatus() {
			this.page = 1;
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

			// 상담 상태 필터링
			if (this.filterStatus) {
				filtered = filtered.filter(lawyer => lawyer.counsel === this.filterStatus);
			}

			if (this.myLatitude && this.myLongitude) {
				// 거리 정보가 있는 사람과 없는 사람 나누기
				const withDistance = filtered.filter(l => l.distance !== undefined);
				const withoutDistance = filtered.filter(l => l.distance === undefined);

				// 거리순 정렬
				withDistance.sort((a, b) => a.distance - b.distance);

				// 거리 없는 사람은 뒤로 붙이기
				return [...withDistance, ...withoutDistance];
			} else {
				// 이름순 정렬 (기본)
				return filtered.sort((a, b) => a.lawyerName.localeCompare(b.lawyerName));
			}
		},


		// 페이징
		pagedLawyers() {
			const start = (this.page - 1) * this.pageSize;
			const end = start + this.pageSize;
			return this.sortedLawyers.slice(start, end);
		},

		pageCount() {
			return Math.ceil(this.sortedLawyers.length / this.pageSize);
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

			let fullAddr = '';
			if (self.selectSi) fullAddr += self.selectSi;
			if (self.selectGu) fullAddr += ' ' + self.selectGu;
			if (self.selectDong) fullAddr += ' ' + self.selectDong;

			if (!fullAddr) {
				alert("검색할 지역을 선택해 주세요.");
				return;
			}

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

			// 주소 가져오기
			const geocoder = new kakao.maps.services.Geocoder();
			geocoder.coord2Address(self.myLongitude, self.myLatitude, function(result, status) {
				if (status === kakao.maps.services.Status.OK) {
					const roadAddress = result[0].road_address
						? result[0].road_address.address_name
						: result[0].address.address_name;

					const contentHtml = `
						<div style="
							width: 230px;
							padding: 12px;
							box-shadow: 0 2px 8px rgba(0,0,0,0.15);
							background-color: white;
							font-family: 'Noto Sans KR', sans-serif;
						">
							<h4 style="margin: 0 0 8px 0; font-size: 16px; color: #333;">📍 내 위치</h4>
							<p style="margin: 0 0 4px 0; font-size: 13px; color: #666;">` + roadAddress + `</p>
						</div>
					`;

					self.myLocationInfoWindow = new kakao.maps.InfoWindow({
						content: contentHtml
					});
					self.myLocationInfoWindow.open(self.map, self.myLocationMarker);

					// 마커 클릭 시 토글
					kakao.maps.event.addListener(self.myLocationMarker, 'click', function () {
						if (self.myLocationInfoWindow.getMap()) {
							self.myLocationInfoWindow.close();
						} else {
							self.myLocationInfoWindow.open(self.map, self.myLocationMarker);
						}
					});
				}
			});

			// 거리 다시 계산
			self.calculateDistances();
		},

		formatPhone(phone) {
			if (!phone) return "";
			return phone.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
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
										box-shadow: 0 2px 8px rgba(0,0,0,0.15);
										background-color: white;
										font-family: 'Noto Sans KR', sans-serif;
									">
										<h4 style="margin: 0 0 8px 0; font-size: 16px; color: #333;">` + lawyer.lawyerName + `</h4>
										<p style="margin: 0 0 4px 0; font-size: 13px; color: #666;">📍 ` + lawyer.lawyerAddr + `</p>
										<p style="margin: 0 0 8px 0; font-size: 13px; color: #666;">
										📞 ` + self.formatPhone(lawyer.lawyerPhone) + `
										</p>
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

			self.selectSi = '';
			self.selectGu = '';
			self.selectDong = '';

			if (!lawyer._lat || !lawyer._lng) return;

			const position = new kakao.maps.LatLng(lawyer._lat, lawyer._lng);
			self.map.panTo(position); 

			// 기존 인포윈도우 닫기
			if (self.infowindow) self.infowindow.close();

			// 새 인포윈도우 열기
			const contentHtml = `
									<div style="
										width: 230px;
										padding: 12px;
										box-shadow: 0 2px 8px rgba(0,0,0,0.15);
										background-color: white;
										font-family: 'Noto Sans KR', sans-serif;
									">
										<h4 style="margin: 0 0 8px 0; font-size: 16px; color: #333;">` + lawyer.lawyerName + `</h4>
										<p style="margin: 0 0 4px 0; font-size: 13px; color: #666;">📍 ` + lawyer.lawyerAddr + `</p>
										<p style="margin: 0 0 8px 0; font-size: 13px; color: #666;">
										📞 ` + self.formatPhone(lawyer.lawyerPhone) + `
										</p>
									</div>
								`;


			self.infowindow.setContent(contentHtml);
			self.infowindow.open(self.map, self.findMarkerByLawyer(lawyer));
			self.infowindowAnchor = self.findMarkerByLawyer(lawyer);

			window.scrollTo({ top: 0, behavior: 'smooth' });

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
		},

		fetchBookmarks() {
			const self = this;

			if (!self.sessionId || self.sessionType !== 'user') return;

			$.post("/bookmark/list.dox", { sessionId: self.sessionId }, function (res) {
				self.bookmarkList = res.list;
			});
		},


		isBookmarked(lawyerId) {
			   return this.bookmarkList.some(bm => bm.lawyerId === lawyerId);
		},

		toggleBookmark(lawyerId) {
			   const self = this;

			   if (!self.sessionId) {
				Swal.fire({
					icon: 'warning',
					title: '로그인이 필요합니다',
					text: '북마크 기능은 로그인 후 이용하실 수 있습니다.',
					confirmButtonColor: '#ff5c00',
					confirmButtonText: '확인'
				}).then((result) => {
						if (result.isConfirmed) {
							location.href = "/user/login.do";
						}
					});
			    return;
			   }

			   const isMarked = self.isBookmarked(lawyerId);
			   const url = isMarked ? "/bookmark/remove.dox" : "/bookmark/add.dox";

			   $.ajax({
			     url: url,
			     type: "POST",
			     data: {
			       userId: self.sessionId,
			       lawyerId: lawyerId
			     },
			     success: function (data) {
			       if (isMarked) {
			         self.bookmarkList = self.bookmarkList.filter(b => b.lawyerId !== lawyerId);
			       } else {
			         self.bookmarkList.push({ lawyerId: lawyerId });
			       }
			     },
			     error: function () {
			       alert("북마크 처리 중 오류가 발생했습니다.");
			     }
			   });
		},
	},
	mounted() {

		const urlParams = new URLSearchParams(window.location.search);
		const tab = urlParams.get("tab");
		if (tab === "inner" || tab === "personal" || tab === "area") {
			this.currentTab = tab;
		}

		this.fetchBookmarks();

		this.fnSi();
		let container = document.getElementById('map');
		let options = {
			center: new kakao.maps.LatLng(37.566826, 126.9786567),
			level: 5
		};
		this.map = new kakao.maps.Map(container, options);
		this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

		if (this.currentTab === 'inner') {
			this.loadLawyers('I');
		} else if (this.currentTab === 'personal') {
			this.loadLawyers('P');
		} else {
			this.loadLawyers(null); // 지역별일 경우 전체
		}

	}
});
mapApp.mount('#mapApp');
</script>
</html>
