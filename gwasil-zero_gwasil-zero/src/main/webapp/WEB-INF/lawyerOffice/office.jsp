<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b58f49b3384edf05982d77a3259c7afb&libraries=services"></script>
	<title>변호사 위치 검색</title>
</head>
<body>
<div id="office">
	<h2>변호사 사무실 찾기</h2>

	<!-- ✅ 지역 선택 -->
	<div style="margin-bottom: 20px;">
		시:
		<select v-model="selectSi" @change="fnGu">
			<option value="">:: 시 선택 ::</option>
			<option v-for="item in siList" :value="item.si">{{ item.si }}</option>
		</select>

		구:
		<select v-model="selectGu" @change="fnDong">
			<option value="">:: 구 선택 ::</option>
			<option v-for="item in guList" :value="item.gu">{{ item.gu }}</option>
		</select>

		동:
		<select v-model="selectDong">
			<option value="">:: 동 선택 ::</option>
			<option v-for="item in dongList" :value="item.dong">{{ item.dong }}</option>
		</select>

		<button @click="fnSearch" style="margin-left: 10px;">검색</button>
	</div>

	<!-- ✅ 지도 -->
	<div id="map" style="width: 700px; height: 500px;"></div>
</div>
</body>
</html>
]<script>
    const office = Vue.createApp({
        data() {
            return {
                siList: [],
                guList: [],
                dongList: [],
    
                selectSi: "",
                selectGu: "",
                selectDong: "",
    
                map: null,
                infowindow: null,
                markers: [],
                lawyerList: []
            };
        },
        methods: {
            fnSi() {
                let self = this;
                $.ajax({
                    url: "si.dox",
                    type: "POST",
                    dataType: "json",
                    success: function(data) {
                        self.siList = data.siList;
                    }
                });
            },
            fnGu() {
                let self = this;
                self.selectGu = "";
                self.selectDong = "";
                self.guList = [];
                self.dongList = [];
    
                $.ajax({
                    url: "gu.dox",
                    type: "POST",
                    data: { si: self.selectSi },
                    dataType: "json",
                    success: function(data) {
                        self.guList = data.guList;
                    }
                });
            },
            fnDong() {
                let self = this;
                self.selectDong = "";
                self.dongList = [];
    
                $.ajax({
                    url: "dong.dox",
                    type: "POST",
                    data: {
                        si: self.selectSi,
                        gu: self.selectGu
                    },
                    dataType: "json",
                    success: function(data) {
                        self.dongList = data.dongList;
                    }
                });
            },
            fnSearch() {
                let self = this;
                $.ajax({
                    url: "/lawyer/list.dox",
                    type: "POST",
                    data: {
                        si: self.selectSi,
                        gu: self.selectGu,
                        dong: self.selectDong
                    },
                    dataType: "json",
                    success: function(res) {
                        self.lawyerList = res.list;
                        self.removeMarkers();
                        self.geocodeAndMark();
                    }
                });
            },
            geocodeAndMark() {
                let self = this;
                let geocoder = new kakao.maps.services.Geocoder();
    
                self.lawyerList.forEach((lawyer) => {
                    geocoder.addressSearch(lawyer.lawyerAddr, function(result, status) {
                        if (status === kakao.maps.services.Status.OK) {
                            let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
    
                            let marker = new kakao.maps.Marker({
                                map: self.map,
                                position: coords
                            });
    
                            self.markers.push(marker);
    
                            kakao.maps.event.addListener(marker, 'click', function () {
                                self.infowindow.setContent(`<div style="padding:5px;">${lawyer.name}<br>${lawyer.lawyerAddr}</div>`);
                                self.infowindow.open(self.map, marker);
                            });
                        }
                    });
                });
            },
            removeMarkers() {
                for (let i = 0; i < this.markers.length; i++) {
                    this.markers[i].setMap(null);
                }
                this.markers = [];
            }
        },
        mounted() {
            let container = document.getElementById('map');
            let options = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                level: 5
            };
            this.map = new kakao.maps.Map(container, options);
            this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
            this.fnSi(); // 시 리스트 불러오기
        }
    });
    office.mount('#office');
</script>
