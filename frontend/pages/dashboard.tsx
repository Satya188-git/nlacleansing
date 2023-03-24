import { Col, Divider, Row } from "antd";
import axios from "axios";
import ChartDateFilter from "components/Dashboard/ChartDateFilter";
import { useEffect, useState } from "react";
import { Line } from 'react-chartjs-2';

const Dashboard = () => {
    const [data, setData] = useState(null);
    const colors = ["#000000", "#A2AAAD", "#58B947", "#F5C846", "#178FFE", "#CA003D", "#32BF8A", "#004693"];
    const monthLabels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    useEffect(() => {
        setData(null);
        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-volume?callstartdate=2022-01-01&callenddate=2022-12-31`)
            .then(res => {
                console.log(res);
                if (res.data) {
                    let dataset = [];
                    let index = 0;
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
                    }
                    setData({ labels: monthLabels, datasets: dataset });
                }
            }).catch((error) => {
                console.log(error);
            });
    }, []);

    console.log(data);

    const config = {
        type: 'scatter',
        data: data,
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
                        display: false,
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
                title: {
                    display: true,
                    text: 'Call Volume Analysis',
                    color: '#FFFFFF',
                },
            },
        },
    };

    return (
        <>
            <Row gutter={[24, 24]}>
                <Col xs={6} md={6}>
                    <ChartDateFilter />
                </Col>
            </Row>
            <Divider />
            <Row gutter={[24, 24]}>
                <Col xs={12} md={12}>
                    {data &&
                        <Line options={config.options} data={config.data} height={400} />}
                </Col>
            </Row>
        </>
    )
}

export default Dashboard;