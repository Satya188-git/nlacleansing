import { Col, Row, Spin } from "antd";
import { useEffect, useState } from "react";
import DateUtil from "helpers/DateUtil";
import { useSelector } from "react-redux";
import styled from 'styled-components';
import axios from "axios";
import { Bar, Doughnut } from "react-chartjs-2";
import { CallDurationValues } from "helpers/CallDurationValue";

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
    height: 400px;
    vertical-align: middle;
`;

const CallHandleTimeSentimentChart = () => {
    const [isLoading, setIsLoading] = useState(false);
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    const [callLengthData, setCallLengthData] = useState(null);
    const [callHandleLabels, setCallHandleLabels] = useState([]);
    const [allSentimentData, setAllSentimentData] = useState(null);
    const [selectedSentiment, setSelectedSentiment] = useState(null);
    const [sentimentPercent, setSentimentPercent] = useState<any>();
    const [sentiment, setSentiment] = useState("Overall");

    const barChartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            x: {
                title: {
                    display: true,
                    text: 'HANDLE TIME(MINS)',
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
                display: false,
            },
            tooltip: {
                callbacks: {
                    label: function (context) {
                        var sum = context.dataset.data.reduce((sum, dataset) => {
                            return sum + dataset;
                        }, 0);
                        var percent: any = context.dataset.data[context.dataIndex] / sum * 100;
                        percent = percent?.toFixed(2);
                        return context.dataset.data[context.dataIndex] + ' (' + percent + '%)';
                    }
                }
            },
        },
        onHover: (e, op) => {
            if (op[0]) {
                const xVal = callHandleLabels[op[0].index];
                setSentiment(xVal ? CallDurationValues[xVal] : "Overall");
                setSelectedSentiment({
                    labels: DateUtil.SENTIMENT_CHART_LABELS,
                    datasets: [
                        {
                            data: xVal ? allSentimentData[`sentiment${xVal}`] : allSentimentData["allsentiment"],
                            backgroundColor: DateUtil.SENTIMENT_CHART_COLORS,
                            borderColor: DateUtil.TAGS_CHART_BORDER_COLOR,
                            borderWidth: 5,
                            fill: true,
                            hoverBorderWidth: 0
                        }
                    ]
                });
            } else {
                setSentiment("Overall");
                onBlur();
            }
        },
        onBlur: () => {
            onBlur();
        },
    }

    const halfDoughnutOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            datalabels: {
                display: false,
            },
            legend: {
                display: true,
                position: 'bottom' as const,
                labels: {
                    color: 'white',
                    usePointStyle: true,
                    boxWidth: 10,
                    generateLabels: function (chart) {
                        var data = chart.data;
                        if (data.labels.length && data.datasets.length) {
                            return data.labels.map(function (label, i) {
                                var meta = chart.getDatasetMeta(0);
                                var ds = data.datasets[0];
                                return {
                                    text: `${label} (${ds.data[i]})`,
                                    fillStyle: ds.backgroundColor[i],
                                    hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
                                    index: i
                                };
                            });
                        }
                        return [];
                    }
                },
            },
            tooltip: {
                enabled: false,
            },
        },
        rotation: -90,
        circumference: 180,
        cutout: "60%",
        onHover: (e, op) => {
            if (op[0]) {
                let index = op[0].index;
                const total = allSentimentData["allsentiment"][0] + allSentimentData["allsentiment"][1] + allSentimentData["allsentiment"][2];
                let value = (allSentimentData["allsentiment"][index] / total) * 100;
                setSentimentPercent(Number.isInteger(value) ? value : value.toFixed(2));
            } else {
                setSentimentPercent(null)
            }
        },
        onBlur: () => setSentimentPercent(null)
    };

    
    const onBlur = () => {
        setSelectedSentiment({
            labels: DateUtil.SENTIMENT_CHART_LABELS,
            datasets: [
                {
                    data: allSentimentData["allsentiment"],
                    backgroundColor: DateUtil.SENTIMENT_CHART_COLORS,
                    borderColor: DateUtil.TAGS_CHART_BORDER_COLOR,
                    borderWidth: 5,
                    fill: true,
                    hoverBorderWidth: 0
                }
            ]
        });
    }

    const setParams = () => {
        var params: any = {
            callstartdate: date.startDate,
            callenddate: date.endDate,
        }
        if (ivrType) params = { ...params, ivrcallcategory: ivrType };
        return params;
    }

    useEffect(() => {
        setIsLoading(true);
        let params = setParams();
        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-handlingtime`, { params })
            .then(res => {
                let labels = [];
                let values = [];
                for (let i in res.data) {
                    labels = [...labels, i];
                    values = [...values, res.data[i]];
                }
                setCallHandleLabels(labels);
                setCallLengthData({
                    labels: ["<5:00", "5-10:00", "10-20:00", "20-30:00", "30-45:00", ">45:00"],
                    datasets: [
                        {
                            data: values,
                            borderColor: DateUtil.CALL_HANDLE_TIME_COLOR,
                            backgroundColor: DateUtil.CALL_HANDLE_TIME_COLOR,
                            borderWidth: 0.5,
                        },
                    ]
                })

            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setIsLoading(false);
            })

        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-sentiment`, { params })
            .then(res => {
                let values = {};
                for (let d in res.data) {
                    let objCount = [];
                    let countData = res.data[d];
                    for (let e in countData) {
                        objCount = [...objCount, countData[e]];
                    }
                    values = { ...values, [d]: objCount };
                }
                setAllSentimentData(values);
                setSelectedSentiment({
                    labels: DateUtil.SENTIMENT_CHART_LABELS,
                    datasets: [
                        {
                            data: values["allsentiment"],
                            backgroundColor: DateUtil.SENTIMENT_CHART_COLORS,
                            borderColor: DateUtil.TAGS_CHART_BORDER_COLOR,
                            borderWidth: 5,
                            fill: true,
                            hoverBorderWidth: 0
                        }
                    ]
                });
            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setIsLoading(false);
            })
    }, [date, ivrType]);

    return (
        <Row gutter={[24, 24]} onBlur={onBlur}>
            {(isLoading || !callLengthData || !selectedSentiment) ?
                <CenterContainer>
                    <Spin tip='Loading' />
                </CenterContainer> : <>
                    <Col xs={6} md={6}>
                        <span className="calls-label">Calls:</span><div className="sentiment-label">{sentiment}</div>
                        {!!sentimentPercent && <span className="sentiment-percent">{sentimentPercent}%</span>}
                        <Doughnut
                            options={halfDoughnutOptions}
                            data={selectedSentiment}
                            width={"100%"}
                            height={300}
                        />
                    </Col>
                    <Col xs={18} md={18}>
                        <Bar options={barChartOptions} data={callLengthData} height={300} />
                    </Col>
                </>}
        </Row>
    )
}

export default CallHandleTimeSentimentChart;