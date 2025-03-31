<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
	<title>매출 통계</title>
	<style>
		.chart-header {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-top: 40px;
		}
		.chart-header h3 {
			margin: 0;
		}
		.chart-wrapper {
			margin-top: 10px;
		}
        .chart-button {
			margin-left: 10px;
		}
	</style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <div id="chartApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />

            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
                <div class="filter-bar" style="margin-bottom: 20px;">
                    <label>검색 기간 설정 :</label>
                    <input type="date" v-model="startDate">
                    ~
                    <input type="date" v-model="endDate">

                    <label style="margin-left: 20px;">구분:</label>
                    <select v-model="chartType">
                        <option value="daily">일별</option>
                        <option value="monthly">월별</option>
                        <option value="yearly">연도별</option>
                    </select>

                    <button @click="fnGetChartData">검색</button>
                </div>

                <h2>매출 통계</h2>
                <!-- Grouped Bar Chart -->
                <div class="chart-header">
                    <h3>
                        Grouped Bar Chart
                        <span>
                            <button @click="showGrouped = !showGrouped" class="chart-button">
                                {{ showGrouped ? '숨기기' : '펼치기' }}
                            </button>
                        </span>
                        <span>
                            <button @click="fnDownloadChart('groupedChart')" class="chart-button">
                                엑셀로 저장
                            </button>
                        </span>   
                    </h3>
                </div>
                <div v-show="showGrouped" class="chart-wrapper">
                    <div id="groupedChart"></div>
                </div>

                <!-- Stacked Bar Chart -->
                <div class="chart-header">
                    <h3>Stacked Bar Chart
                        <span>
                            <button @click="showStacked = !showStacked" class="chart-button">
                                {{ showStacked ? '숨기기' : '펼치기' }}
                            </button>
                        </span>
                        <span>
                            <button @click="fnDownloadChart('stackedChart')" class="chart-button">
                                엑셀로 저장
                            </button>
                        </span>
                    </h3>    
                </div>
                <div v-show="showStacked" class="chart-wrapper">
                    <div id="stackedChart"></div>
                </div>

                <!-- Line Chart -->
                <div class="chart-header">
                    <h3>Line Chart
                        <span>
                            <button @click="showLine = !showLine" class="chart-button">
                                {{ showLine ? '숨기기' : '펼치기' }}
                            </button>
                        </span>
                        <span>
                            <button @click="fnDownloadChart('lineChart')" class="chart-button">
                                엑셀로 저장
                            </button>
                        </span>
                    </h3>
                </div>
                <div v-show="showLine" class="chart-wrapper">
                    <div id="lineChart"></div>
                </div>

                <!-- Simple Pie Chart -->
                <div class="chart-header">
                    <h3>Simple Pie Chart
                        <span>
                            <button @click="showPie = !showPie" class="chart-button">
                                {{ showPie ? '숨기기' : '펼치기' }}
                            </button>
                        </span>
                        <span>    
                            <button @click="fnDownloadChart('pieChart')" class="chart-button">
                                엑셀로 저장
                            </button>
                        </span>
                    </h3>
                </div>

                <div v-show="showPie" class="chart-wrapper">
                    <div class="chart-button">
                        <select v-model="selectedYear" @change="fnLoadAvailableMonths">
                            <option value="">전체 연도</option>
                            <option v-for="year in availableYears" :key="year" :value="year">{{ year }}년</option>
                        </select>

                        <select v-model="selectedMonth" @change="fnLoadAvailableDays" v-if="availableMonths.length > 0" class="chart-button">
                            <option value="">전체 월</option>
                            <option v-for="month in availableMonths" :key="month" :value="month">{{ month }}월</option>
                        </select>

                        <select v-model="selectedDay" v-if="availableDays.length > 0" class="chart-button">
                            <option value="">전체 일</option>
                            <option v-for="day in availableDays" :key="day" :value="day">{{ day }}일</option>
                        </select>

                        <button @click="fnGetPieChart" class="chart-button">검색</button>
                    </div>
                    <!-- 총 매출 금액 표시 -->
                    <div v-if="totalSales > 0" style="margin: 10px 0; font-weight: bold;">
                        총 매출 금액: ₩{{ totalSales.toLocaleString() }}
                    </div>

                    <div id="pieChart"></div>
                </div>

                <h2>일반 이용자 통계</h2>
                <!-- 누적 회원 등록수 Line Chart -->
                <div class="chart-header">
                    <h3>회원 누적 등록 수 (Line Chart)
                        <span>
                            <button @click="showUserLine = !showUserLine" class="chart-button">
                                {{ showUserLine ? '숨기기' : '펼치기' }}
                            </button>
                        </span>
                        <span>
                            <button @click="fnDownloadChart('userLineChart')" class="chart-button">
                                엑셀로 저장
                            </button>
                        </span>
                    </h3>
                </div>

                <div v-show="showUserLine" class="chart-wrapper">
                    <div id="userLineChart"></div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp" />
</body>
</html>
<script>
    const chartApp = Vue.createApp({
        data() {
            return {
                chartType: 'monthly',
                startDate: '',
                endDate: '',
                showGrouped: false,
                showStacked: false,
                chartGrouped: null,
                chartStacked: null,
                showLine: false,
                chartLine: null,
                showPie: false,
                chartPie: null,
                availableYears: [],
                availableMonths: [],
                availableDays: [],
                selectedYear: '',
                selectedMonth: '',
                selectedDay: '',
                totalSales: 0,
                showUserLine: true,
                chartUserLine: null,
            };
        },
        methods: {
            fnGetChartData() {
                const self = this;
                $.ajax({
                    url: '/admin/statChart.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        groupType: self.chartType,
                        startDate: self.startDate,
                        endDate: self.endDate
                    }),
                    success(data) {
                        self.fnRenderGroupedChart(data.series, data.categories);
                        self.fnRenderStackedChart(data.series, data.categories);
                        self.fnRenderLineChart(data.series, data.categories); 
                    }
                });
                self.fnGetUserChart();
            },
            fnRenderGroupedChart(series, categories) {
                if (this.chartGrouped) {
                    this.chartGrouped.updateOptions({
                        series: series,
                        xaxis: { categories: categories }
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'bar',
                            height: 400,
                            toolbar: {
                                show: true,
                                tools: {
                                    download: true,
                                    zoom: true,
                                    reset: true
                                }
                            }
                        },
                        plotOptions: {
                            bar: {
                                horizontal: true,
                                dataLabels: { position: 'top' }
                            }
                        },
                        dataLabels: {
                            enabled: true,
                            offsetX: -6,
                            style: {
                                fontSize: '12px',
                                colors: ['#fff']
                            }
                        },
                        stroke: {
                            show: true,
                            width: 1,
                            colors: ['#fff']
                        },
                        xaxis: {
                            categories: categories
                        },
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            shared: true,
                            intersect: false,
                            y: {
                                formatter: val => '₩ ' + val.toLocaleString()
                            }
                        }
                    };
                    this.chartGrouped = new ApexCharts(document.querySelector("#groupedChart"), options);
                    this.chartGrouped.render();
                }
            },
            fnRenderStackedChart(series, categories) {
                if (this.chartStacked) {
                    this.chartStacked.updateOptions({
                        series: series,
                        xaxis: { categories: categories }
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'bar',
                            height: 430,
                            stacked: true,
                            toolbar: {
                                show: true
                            }
                        },
                        plotOptions: {
                            bar: {
                                horizontal: false,
                                borderRadius: 5,
                                columnWidth: '60%'
                            }
                        },
                        dataLabels: {
                            enabled: false
                        },
                        xaxis: {
                            categories: categories
                        },
                        yaxis: {
                            title: {
                                text: '₩ 매출'
                            }
                        },
                        legend: {
                            position: 'bottom',
                            horizontalAlign: 'center'
                        },
                        tooltip: {
                            y: {
                                formatter: val => '₩ ' + val.toLocaleString()
                            }
                        }
                    };
                    this.chartStacked = new ApexCharts(document.querySelector("#stackedChart"), options);
                    this.chartStacked.render();
                }
            },
            fnRenderLineChart(series, categories) {
                if (this.chartLine) {
                    this.chartLine.updateOptions({
                        series: series,
                        xaxis: { categories: categories }
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'line',
                            height: 400,
                            toolbar: {
                                show: true
                            }
                        },
                        dataLabels: {
                            enabled: true
                        },
                        stroke: {
                            curve: 'smooth'
                        },
                        xaxis: {
                            categories: categories
                        },
                        yaxis: {
                            title: {
                                text: '₩ 매출'
                            }
                        },
                        legend: {
                            position: 'bottom',
                            horizontalAlign: 'center'
                        },
                        tooltip: {
                            y: {
                                formatter: val => '₩ ' + val.toLocaleString()
                            }
                        }
                    };
                    this.chartLine = new ApexCharts(document.querySelector("#lineChart"), options);
                    this.chartLine.render();
                }
            },
            fnDownloadChart(chartId) {
                const chartDom = document.querySelector(`#${chartId} svg`);
                const svgData = new XMLSerializer().serializeToString(chartDom);
                const canvas = document.createElement("canvas");
                const ctx = canvas.getContext("2d");
                const img = new Image();
                const svgBlob = new Blob([svgData], {type: "image/svg+xml;charset=utf-8"});
                const url = URL.createObjectURL(svgBlob);

                img.onload = function () {
                    canvas.width = img.width;
                    canvas.height = img.height;
                    ctx.drawImage(img, 0, 0);
                    const pngFile = canvas.toDataURL("image/png");

                    const a = document.createElement("a");
                    a.download = `${chartId}_매출통계.png`;
                    a.href = pngFile;
                    a.click();
                    URL.revokeObjectURL(url);
                };

                img.src = url;
            },
            fnLoadAvailableYears() {
                const self = this;
                $.ajax({
                    url: '/admin/pieAvailableYears.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success(data) {
                        self.availableYears = data.years;
                    }
                });
            },
            fnLoadAvailableMonths() {
                const self = this;
                if (!self.selectedYear) {
                    self.availableMonths = [];
                    return;
                }
                $.ajax({
                    url: '/admin/pieAvailableMonths.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({ year: self.selectedYear }),
                    success(data) {
                        self.availableMonths = data.months;
                        self.availableDays = [];
                        self.selectedMonth = '';
                        self.selectedDay = '';
                    }
                });
            },
            fnLoadAvailableDays() {
                const self = this;
                if (!self.selectedYear || !self.selectedMonth) {
                    self.availableDays = [];
                    return;
                }
                $.ajax({
                    url: '/admin/pieAvailableDays.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        year: self.selectedYear,
                        month: self.selectedMonth
                    }),
                    success(data) {
                        self.availableDays = data.days;
                        self.selectedDay = '';
                    }
                });
            },
            fnGetPieChart() {
                const self = this;
                $.ajax({
                    url: '/admin/statPie.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        year: self.selectedYear,
                        month: self.selectedMonth,
                        day: self.selectedDay
                    }),
                    success(data) {
                        self.fnRenderPieChart(data.series, data.labels);
                        self.totalSales = data.totalSales || 0;
                    }
                });
            },
            fnRenderPieChart(series, labels) {
                if (this.chartPie) {
                    this.chartPie.updateOptions({
                        series: series,
                        labels: labels
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'pie',
                            height: 400
                        },
                        labels: labels,
                        dataLabels: {
                            enabled: true,
                            formatter: function (val, opts) {
                                return val.toFixed(1) + '%';
                            }
                        },
                        tooltip: {
                            y: {
                                formatter: val => '₩ ' + val.toLocaleString()
                            }
                        },
                        legend: {
                            position: 'bottom'
                        }
                    };
                    this.chartPie = new ApexCharts(document.querySelector("#pieChart"), options);
                    this.chartPie.render();
                }
            },
            fnGetUserChart() {
                const self = this;
                $.ajax({
                    url: '/admin/statUserLine.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        startDate: self.startDate,
                        endDate: self.endDate,
                        groupType: self.chartType
                    }),
                    success(data) {
                        self.fnRenderUserLineChart(data.series, data.categories);
                    }
                });
            },
            fnRenderUserLineChart(series, categories) {
                if (this.chartUserLine) {
                    this.chartUserLine.updateOptions({
                        series: series,
                        xaxis: { categories: categories }
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'line',
                            height: 400,
                            toolbar: {
                                show: true
                            }
                        },
                        stroke: {
                            curve: 'smooth'
                        },
                        dataLabels: {
                            enabled: true
                        },
                        xaxis: {
                            categories: categories
                        },
                        yaxis: {
                            title: {
                                text: '회원 수'
                            }
                        },
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            y: {
                                formatter: val => val.toLocaleString() + ' 명'
                            }
                        }
                    };
                    this.chartUserLine = new ApexCharts(document.querySelector("#userLineChart"), options);
                    this.chartUserLine.render();
                }
            }    
        }, // 메소드 영역 끝
        mounted() {
            this.fnGetChartData();
            this.fnLoadAvailableYears(); 
            this.fnGetPieChart();
            this.fnGetUserChart();
        }
    });
    chartApp.mount('#chartApp');
</script>
