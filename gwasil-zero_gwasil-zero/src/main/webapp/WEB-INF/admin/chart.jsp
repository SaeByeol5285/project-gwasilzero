<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
  <title>매출 통계</title>
</head>
<body>>
    <div id="chartApp">
        <div class="layout">
            <jsp:include page="layout.jsp" />
            <div class="content">
                <div class="header">
                    <div>관리자페이지</div>
                    <div>Admin님</div>
                </div>
                <h3>매출 통계</h3>
                <div class="filter-bar" style="margin-bottom: 20px;">
                    <label>기간:</label>
                    <input type="date" v-model="startDate">
                    ~
                    <input type="date" v-model="endDate">
                
                    <label style="margin-left: 20px;">구분:</label>
                    <select v-model="chartType">
                        <option value="daily">일별</option>
                        <option value="monthly" selected>월별</option>
                        <option value="yearly">연도별</option>
                    </select>
                
                    <button @click="fnGetChartData">검색</button>
                </div>

                <div id="chart"></div>
            </div>
        </div>
    </div>  
</body>
</html>
<script>
    const chartApp = Vue.createApp({
        data() {
            return {
                chartType: 'monthly',      // 그룹 기준
                startDate: '',             // 시작일
                endDate: '',               // 종료일
                chartList: []              // 서버에서 받아온 데이터 
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
                    self.fnRenderChart(data.series, data.categories);
                }
                });
            },
            fnRenderChart(series, categories) {
                if (this.chart) {
                this.chart.updateOptions({
                    series: series,
                    xaxis: { categories: categories }
                });
                } else {
                    const options = {
                    series: series,
                    chart: {
                    type: 'bar',
                    height: 400
                    },
                    plotOptions: {
                        bar: {
                            horizontal: false,
                            columnWidth: '55%',
                            borderRadius: 5,
                            borderRadiusApplication: 'end'
                        }
                    },
                    dataLabels: { enabled: false },
                    stroke: {
                        show: true,
                        width: 2,
                        colors: ['transparent']
                    },
                    xaxis: {
                        categories: categories
                    },
                    yaxis: {
                        title: {
                            text: '₩ 매출'
                        }
                    },
                    tooltip: {
                        y: {
                            formatter: function (val) {
                            return "₩ " + val.toLocaleString();
                            }
                        }
                    }
                };

                this.chart = new ApexCharts(document.querySelector("#chart"), options);
                this.chart.render();
                }
            }
        }, // 메소드 끝
        mounted() {
            var self = this;
            self.fnGetChartData();
        }
    });
    chartApp.mount('#chartApp');
</script>