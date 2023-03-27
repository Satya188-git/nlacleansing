import { Card, Col, Divider, Row, Space, Spin, Typography } from "antd";
import axios from "axios";
import { ListCard } from "components";
import ChartDateFilter from "components/Dashboard/ChartDateFilter";
import IvrTypes from "components/Dashboard/IvrType";
import DateUtil from "helpers/DateUtil";
import { useEffect, useState } from "react";
import { Line, Bar } from 'react-chartjs-2';
import { useSelector } from "react-redux";
import styled from 'styled-components';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
    height: 400px;
    vertical-align: middle;
`;

const barChartOptions = {
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

const config = {
    type: 'scatter',
    options: {
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
    },
};

const Dashboard = () => {
    const [data, setData] = useState(null);
    const [callLengthData, setCallLengthData] = useState(null);
    const colors = ["#F5C846", "#A2AAAD", "#58B947", "#000000", "#58B947", "#F5C846", "#178FFE", "#CA003D", "#32BF8A", "#004693"];
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    const monthDiff = DateUtil.monthDiff;
    const [ivrTypes, setIvrTypes] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const { Title } = Typography;

    useEffect(() => {
        setData(null);
        setIsLoading(true);
        let months = monthDiff(date.startDate, date.endDate) + 1;
        let monthLabels = [];
        for (let m = 1; m <= months; m++) {
            monthLabels = [...monthLabels, m];
        }
        var params: any = {
            callstartdate: date.startDate,
            callenddate: date.endDate,
        }
        if (ivrType) params = { ...params, ivrcallcategory: ivrType };
        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-volume`, { params })
            .then(res => {
                console.log(res);
                if (res.data) {
                    let dataset = [];
                    let index = 0;
                    let types = [];
                    for (let d in res.data) {
                        const dataArr = JSON.parse(res.data[d]);
                        let _data = [];
                        for (let i = 1; i < dataArr.length; i++) {
                            _data = [..._data, dataArr[i]];
                        }
                        const obj = {
                            data: _data,
                            label: d,
                            borderColor: colors[index],
                            borderWidth: 2,
                            backgroundColor: colors[index],
                        }
                        dataset = [...dataset, obj];
                        index++;
                        types = [...types, d];
                    }
                    if (ivrTypes.length === 0) setIvrTypes(types);
                    setData({ labels: monthLabels, datasets: dataset });
                }
            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setIsLoading(false);
            });

        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-handlingtime`, { params })
            .then(res => {
                let labels = [];
                let values = [];
                for (let i in res.data) {
                    labels = [...labels, i];
                    values = [...values, res.data[i]];
                }
                setCallLengthData({
                    labels,
                    datasets: [
                        {
                            data: values,
                            borderColor: "#56C7DA",
                            backgroundColor: "#56C7DA",
                            borderWidth: 0.5,
                        },
                    ]
                })

            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setIsLoading(false);
            })
    }, [date, ivrType]);

    return (
        <>
            <Row gutter={[24, 24]} className="dashboard-filter-section">
                <Col xs={24} md={24}>
                    <Space>
                        <IvrTypes />
                        <ChartDateFilter />
                    </Space>
                </Col>
            </Row>
            <Divider />
            <Row gutter={[24, 24]}>
                <Col xs={7} md={7}>
                    <Card className="count-card no-border mb-15">
                        <p className="count-val">1,300,000</p>
                        <p>Total Calls</p>
                    </Card>
                    <Row gutter={[24, 24]} className="mb-15">
                        <Col xs={12} md={12}>
                            <Card className="count-card no-border">
                                <p className="count-val">18:32</p>
                                <p>Average Talk Time</p>
                            </Card>
                        </Col>
                        <Col xs={12} md={12}>
                            <Card className="count-card no-border">
                                <p className="count-val">5:32</p>
                                <p>Average Hold Time</p>
                            </Card>
                        </Col>
                    </Row>
                    <Card className="count-card no-border mb-15">
                        <p className="count-val">82%</p>
                        <p>Percent Resolved with Positive Sentiment</p>
                    </Card>
                </Col>
                <Col xs={17} md={17}>
                    <Title level={5}>{ivrType} Call Analytics</Title>
                    <ListCard hoverable bordered={false} className="chart-warpper">
                        <div className="chart-header">Call Handle Time and Sentiment</div>
                        <Row gutter={[24, 24]}>
                            <Col xs={6} md={6}></Col>
                            <Col xs={18} md={18}>
                                {(isLoading || !data) ?
                                    <CenterContainer>
                                        <Spin tip='Loading' />
                                    </CenterContainer> :
                                    <Bar options={barChartOptions} data={callLengthData} height={300} />
                                }
                            </Col>
                        </Row>
                        <div className="chart-header mt-15">Call Volume Over Time</div>
                        <Row gutter={[24, 24]}>
                            {(isLoading || !data) ?
                                <CenterContainer>
                                    <Spin tip='Loading' />
                                </CenterContainer> :
                                <Line options={config.options} data={data} height={350} />
                            }
                        </Row>
                    </ListCard>
                </Col>
            </Row>
        </>
    )
}

export default Dashboard;