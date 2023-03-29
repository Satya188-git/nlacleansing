export const LineChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
        x: {
            title: {
                display: true,
                text: 'MONTHS',
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
                text: 'CALL COUNT',
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
            position: 'bottom' as const,
            labels: {
                color: 'white',
                usePointStyle: true,
                boxWidth: 6,
            },
        },
    },
};