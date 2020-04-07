var WorldMap = {
    initChart: function (data) {
        Highcharts.mapChart("map-container", {
            chart: {
                map: "custom/world",
                backgroundColor: "#343a40",
                style: {
                    color: "white",
                },
            },

            colorAxis: {
                min: 1,
                max: 100000,
                type: "logarithmic",
            },

            credits: {
                enabled: false,
            },

            exporting: {
                enabled: false
            },

            legend: {
                enabled: false,
            },

            mapNavigation: {
                enabled: true,
            },

            series: [
                {
                    data: data,
                    joinBy: ["iso-a3", "code3"],
                    name: "Corona Virus Stats",
                    states: {
                        hover: {
                            color: "#a4edba",
                        },
                    },
                },
            ],

            title: {
                text: null,
            },
        });
    },
};
