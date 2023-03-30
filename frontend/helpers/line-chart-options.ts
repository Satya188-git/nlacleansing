import DateUtil from "./DateUtil";

export const LineChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
        x: {
            title: {
                display: true,
                text: 'MONTHS',
                color: DateUtil.COLOR_WHITE,
            },
            ticks: {
                precision: 0,
                color: DateUtil.COLOR_WHITE,
            },
            grid: {
                display: false,
                borderColor: DateUtil.COLOR_WHITE,
            },
        },
        y: {
            title: {
                display: true,
                text: 'CALL COUNT',
                color: DateUtil.COLOR_WHITE,
            },
            min: 0,
            ticks: {
                precision: 0,
                color: DateUtil.COLOR_WHITE,
            },
            grid: {
                // display: false,
                color: DateUtil.CHART_GRID_COLOR,
                borderDash: [1, 1],
                borderColor: DateUtil.COLOR_WHITE,
            }
        }
    },
    plugins: {
        datalabels: {
            display: false,
        },
        customCanvasBackgroundColor: {
            color: DateUtil.COLOR_WHITE,
        },
        legend: {
            position: 'bottom' as const,
            labels: {
                color: 'white',
                usePointStyle: true,
                boxWidth: 6,
            },
        },
    },
};