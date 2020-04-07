var TimeSeries = {
    initChart: function (data, selector) {
        Highcharts.stockChart(selector, {
            chart: {
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
                align: "left",
                x: 50,
                verticalAlign: "top",
                y: 75,
                floating: true,
                backgroundColor: "white",
                borderColor: "#CCC",
                borderWidth: 1,
                shadow: false,
                enabled: true,
                layout: "vertical",
            },

            navigator: {
                enabled: false,
            },

            rangeSelector: {
                style: {
                    color: "white",
                },
            },

            scrollbar: {
                enabled: false,
            },

            series: data,

            title: {
                text: "",
            },

            xAxis: {
                dateTimeLabelFormats: {
                    day: "%e %b %Y",
                },
                labels: {
                    style: {
                        color: "white",
                    },
                },
            },

            yAxis: {
                labels: {
                    style: {
                        color: "white",
                    },
                },
            },
        });
    },
};
