var CountryMap = {
    initChart: function (data) {
        Highcharts.mapChart("map-container", {
            chart: {
                map: data.map_name,
                backgroundColor: "#343a40",
                style: {
                    color: "white",
                },
            },

            colorAxis: {
                min: 1,
                max: 1000,
                type: "logarithmic",
            },

            credits: {
                enabled: false,
            },

            exporting: {
                enabled: false
            },

            legend: {
                enabled: true,
            },

            mapNavigation: {
                enabled: true,
            },

            tooltip: {
                formatter: function() {
                    return '<b>' + this.point.name + '</b><br>' +
                        'Confirmed: ' + this.point.confirmed + '<br>' +
                        'Recovered: ' + this.point.recovered + '<br>' +
                        'Deaths: ' + this.point.deaths + '<br>';
                }
            },

            series: [
                {
                    data: data.data,
                    joinBy: ['name', 'name'],
                    name: "Corona Virus Stats",
                    states: {
                        hover: {
                            color: "#a4edba",
                        },
                    },
                    dataLabels: {
                        enabled: true,
                        format: "{point.name} <br> {point.confirmed}"
                    }
                },
            ],

            title: {
                text: null,
            },
        });
    },
};
