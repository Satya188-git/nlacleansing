export const BarChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
        x: {
            title: {
                display: true,
                text: 'HANDLE TIME(MINS)',
                color: '#FFFFFF',
            },
            ticks: {
                precision: 0,
                color: '#FFFFFF',
            },
            grid: {
                display: false,
                borderColor: '#FFFFFF',
            },
        },
        y: {
            title: {
                display: true,
                color: '#FFFFFF',
            },
            min: 0,
            ticks: {
                precision: 0,
                color: '#FFFFFF',
            },
            grid: {
                // display: false,
                color: '#747B84',
                borderDash: [1, 1],
                borderColor: '#FFFFFF',
            }
        }
    },
    plugins: {
        datalabels: {
            display: false,
        },
        customCanvasBackgroundColor: {
            color: '#fff',
        },
        legend: {
            display: false,
        },
    },
}