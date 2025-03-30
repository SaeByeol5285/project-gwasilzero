<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
<div id="chartApp">
    <div class="layout">
        <jsp:include page="layout.jsp" />

        <div class="content">
            <div class="header">
                <div>관리자페이지</div>
                <div>Admin님</div>
            </div>

            <h2>매출 통계</h2>
            <div class="filter-bar" style="margin-bottom: 20px;">
                <label>기간:</label>
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

            <!-- 📊 Doughnut Chart -->
            <div class="chart-header">
                <h3>Doughnut Chart</h3>
                <div>
                    <button @click="showDonut = !showDonut">{{ showDonut ? '숨기기' : '펼치기' }}</button>
                    <button @click="fnDownloadChart('donutChart')">엑셀로 저장</button>
                </div>
            </div>
            <div v-show="showDonut" class="chart-wrapper">
                <div id="donutChart"></div>
            </div>

        </div>
    </div>
</div>
</body>
</html>

<script>
    const chartApp = Vue.createApp({
        data() {
            return {
                chartType: 'monthly',
                startDate: '',
                endDate: '',
                showGrouped: true,
                showStacked: true,
                chartGrouped: null,
                chartStacked: null,
                showLine: true,
                chartLine: null,
                showDonut: true,
                chartDonut: null
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
            fnGetDonutChart() {
                const self = this;
                $.ajax({
                    url: '/admin/statDonut.dox',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        startDate: self.startDate,
                        endDate: self.endDate
                    }),
                    success(data) {
                        self.fnRenderDonutChart(data.series, data.labels);
                    }
                });
            },
            fnRenderDonutChart(series, labels) {
                if (this.chartDonut) {
                    this.chartDonut.updateOptions({
                        series: series,
                        labels: labels
                    });
                } else {
                    const options = {
                        series: series,
                        chart: {
                            type: 'donut',
                            height: 400,
                            toolbar: {
                                show: true
                            }
                        },
                        labels: labels,
                        dataLabels: {
                            enabled: true,
                            formatter: function (val, opts) {
                                return val.toFixed(1) + "%";
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
                    this.chartDonut = new ApexCharts(document.querySelector("#donutChart"), options);
                    this.chartDonut.render();
                }
            }
        },
        mounted() {
            this.fnGetChartData();
            this.fnGetDonutChart();  
        }
    });
    chartApp.mount('#chartApp');
</script>
