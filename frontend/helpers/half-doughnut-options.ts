export const HalfDoughnutOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        datalabels: {
            display: false,
        },
        legend: {
            display: false,
            position: 'bottom' as const,
            labels: {
                color: 'white',
                usePointStyle: true,
                boxWidth: 15,
            },
        },
        tooltip: {
            enabled: false,
        }
    },
    rotation: -90,
    circumference: 180,
    cutout: "60%",
};