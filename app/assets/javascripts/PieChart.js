var PieChart = {
    initChart: function (data) {
        Highcharts.chart("rate-distribution-container", {
            accessibility: {
                point: {
                    valueSuffix: "%",
                },
            },

            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: "pie",
                backgroundColor: "#343a40",
                style: {
                    color: "white",
                },
            },

            credits: {
                enabled: false,
            },

            exporting: {
                enabled: false
            },

            legend: {
                enabled: false
            },

            plotOptions: {
                pie: {
                    size: 250,
                    allowPointSelect: true,
                    cursor: "pointer",
                    dataLabels: {
                        enabled: true,
                        format: "<b>{point.name}</b>: {point.percentage:.1f} %",
                    },
                },
            },

            series: data,

            title: {
                text: null,
            },

            tooltip: {
                pointFormat: "{series.name}: <b>{point.percentage:.1f}%</b>",
            },
        });
    },
};
