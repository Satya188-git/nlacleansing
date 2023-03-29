import { Card, Col, Divider, Row, Space, Spin, Typography } from "antd";
import axios from "axios";
import { ListCard } from "components";
import ChartDateFilter from "components/Dashboard/ChartDateFilter";
import IvrTypes from "components/Dashboard/IvrType";
import TagFilter from "components/Dashboard/TagFilter";
import { BarChartOptions } from "helpers/Bar-chart-options";
import DateUtil from "helpers/DateUtil";
import { HalfDoughnutOptions } from "helpers/half-doughnut-options";
import { LineChartOptions } from "helpers/line-chart-options";
import moment from "moment";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { Line, Bar, Doughnut } from 'react-chartjs-2';
import { useDispatch, useSelector } from "react-redux";
import { setDate, setIvrType, setTag } from "reducers/dashboard-reducer";
import styled from 'styled-components';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
    height: 400px;
    vertical-align: middle;
`;

const Dashboard = () => {
    const [callVolumeData, setCallVolumeData] = useState(null);
    const [callLengthData, setCallLengthData] = useState(null);
    const [callHandleLabels, setCallHandleLabels] = useState([]);
    const [callSentimentData, setCallSentimentData] = useState(null);
    const [selectedSentiment, setSelectedSentiment] = useState(null);
    const colors = ["#F5C846", "#A2AAAD", "#58B947", "#000000", "#58B947", "#F5C846", "#178FFE", "#CA003D", "#32BF8A", "#004693"];
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    const tag = useSelector((state: any) => state.dashboard.tag);
    const monthDiff = DateUtil.monthDiff;
    const [ivrTypes, setIvrTypes] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [isTagsLoading, setIsTagsLoading] = useState(false);
    const { Title } = Typography;
    const [sentiment, setSentiment] = useState("Overall");
    const duration = { "lessthan5mins": "<5:00", "5to10mins": "5-10:00", "10to20mins": "10-20:00", "20to30mins": "20-30:00", "30to45mins": "30-45:00", "morethan45mins": ">45:00" };
    const [sentimentPercent, setSentimentPercent] = useState<any>();
    const [tagsData, setTagsData] = useState(null);
    const [allTags, setAllTags] = useState([]);
    const [firstMetric, setFirstMetric] = useState("");
    const [secondMetric, setSecondMetric] = useState("");
    const dispatch = useDispatch();
    const router = useRouter();

    useEffect(() => {
        router.events.on('routeChangeStart', (url) => {
            if (!url.includes("dashboard")) {
                const currentYear = new Date("2022-05-20").getFullYear();
                const startDate = moment(new Date(currentYear, 0, 1)).format(DateUtil.DATE_FORMAT);
                const endDate = moment(new Date(currentYear, 11, 31)).format(DateUtil.DATE_FORMAT);
                dispatch(setDate({ startDate, endDate }));
                dispatch(setIvrType(""));
                dispatch(setTag(""));
            }
        });
    }, []);

    const onBlur = () => {
        setSelectedSentiment({
            labels: ["Positive", "Negative", "Neutral"],
            datasets: [
                {
                    data: callSentimentData["allsentiment"],
                    backgroundColor: ["#32BF8A", "#F73B2A", "#F5C846"],
                    borderColor: "#031627",
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
        setCallVolumeData(null);
        setIsLoading(true);
        let months = monthDiff(date.startDate, date.endDate) + 1;
        let monthLabels = [];
        for (let m = 1; m <= months; m++) {
            monthLabels = [...monthLabels, m];
        }
        let params = setParams();
        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-volume`, { params })
            .then(res => {
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
                    setCallVolumeData({ labels: monthLabels, datasets: dataset });
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
                setCallHandleLabels(labels);
                setCallLengthData({
                    labels: ["<5:00", "5-10:00", "10-20:00", "20-30:00", "30-45:00", ">45:00"],
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
                setCallSentimentData(values);
                setSelectedSentiment({
                    labels: ["Positive", "Negative", "Neutral"],
                    datasets: [
                        {
                            data: values["allsentiment"],
                            backgroundColor: ["#32BF8A", "#F73B2A", "#F5C846"],
                            borderColor: "#031627",
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

    useEffect(() => {
        setIsTagsLoading(true);
        setTagsData(null);
        let params = setParams();
        if (tag) params = { ...params, taglabel: tag };
        if (ivrType) {
            axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-tag`, { params })
                .then(res => {
                    if (!tag) {
                        setAllTags(res.data?.map(i => i.tagLabel) || []);
                        setFirstMetric("");
                        let topFiveData = res.data?.slice(0, 5);
                        setTagsData({
                            labels: topFiveData?.map(i => i.tagLabel),
                            datasets: [
                                {
                                    data: topFiveData?.map(i => i.tagcount),
                                    backgroundColor: topFiveData?.map((_, i) =>
                                        DateUtil.namedColor(i)
                                    ),
                                    fill: true,
                                    borderWidth: 0,
                                    hoverBorderWidth: 2,
                                    borderColor: "#031627"
                                }]
                        });
                    } else {
                        const tagDetails = res.data?.find(i => i["chosentaglabel"]);
                        const coOccurData = res.data?.filter(i => i["cooccurtagLabel"]);
                        setFirstMetric(`"${tagDetails?.chosentaglabel}" occurred ${tagDetails?.chosentagcount} times` || "");
                        setTagsData({
                            labels: coOccurData?.map(i => i.cooccurtagLabel),
                            datasets: [
                                {
                                    data: coOccurData?.map(i => i.cooccurtagcount),
                                    backgroundColor: coOccurData?.map((_, i) =>
                                        DateUtil.namedColor(i)
                                    ),
                                    fill: true,
                                    borderWidth: 0,
                                    hoverBorderWidth: 2,
                                    borderColor: "#031627"
                                }]
                        });
                    }
                }).catch((error) => {
                    console.log(error);
                }).finally(() => {
                    setIsTagsLoading(false);
                })
        } else {
            setTimeout(() => {
                setTagsData({
                    labels: [], datasets: [{ data: [1], backgroundColor: "#273C4F", borderColor: "#031627" }]
                });
                setAllTags([]);
                dispatch(setTag(''));
                setIsTagsLoading(false);
            }, 200);
        }
    }, [date, ivrType, tag])

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
                setSentiment(xVal ? duration[xVal] : "Overall");
                setSelectedSentiment({
                    labels: ["Positive", "Negative", "Neutral"],
                    datasets: [
                        {
                            data: xVal ? callSentimentData[`sentiment${xVal}`] : callSentimentData["allsentiment"],
                            backgroundColor: ["#32BF8A", "#F73B2A", "#F5C846"],
                            borderColor: "#031627",
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
                const total = callSentimentData["allsentiment"][0] + callSentimentData["allsentiment"][1] + callSentimentData["allsentiment"][2];
                let value = (callSentimentData["allsentiment"][index] / total) * 100;
                setSentimentPercent(Number.isInteger(value) ? value : value.toFixed(2));
            } else {
                setSentimentPercent(null)
            }
        },
        onBlur: () => setSentimentPercent(null)
    };

    const tagsDoughnutOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            datalabels: {
                display: false,
            },
            legend: {
                display: true,
                position: 'top' as const,
                labels: {
                    color: 'white',
                    usePointStyle: true,
                    boxWidth: 10,
                },
            },
            tooltip: {
                enabled: false,
            },
        },
        onHover: (e, op) => {
            if (op[0]) {
                const index = op[0].index;
                const count = tagsData.datasets[0].data[index];
                const label = tagsData.labels[index];
                if (!tag) setFirstMetric(`"${label}" occurred ${count} time${count > 1 ? 's' : ''}`);
                else setSecondMetric(`"${tag}" > "${label}" occurred ${count} time${count > 1 ? 's' : ''}`);
            } else {
                if (!tag) setFirstMetric("");
                setSecondMetric("");
            }
        },
    };

    const getTagSecTitle = () => {
        let title = `Tracked Tags - ${ivrType}`;
        if (tag) {
            title = `Top 5 Most Common "${tag}" Co-occurrences`;
        }
        return title;
    }

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
                    <Row gutter={[24, 24]} className="mb-15">
                        <Col xs={8} md={8}>
                            <Title level={5} className="call-tags-title">Call Tags</Title>
                        </Col>
                        <Col xs={16} md={16}>
                            <TagFilter tags={allTags} />
                        </Col>
                    </Row>
                    <Row gutter={[24, 24]}>
                        <Col xs={24} md={24}>
                            <ListCard hoverable bordered={false} className={`tag-chart-sec ${ivrType && 'with-ivr-chart-sec'} ${tag && 'with-tag-chart-sec'}`}>
                                {(isTagsLoading || !tagsData) ?
                                    <CenterContainer>
                                        <Spin tip='Loading' />
                                    </CenterContainer> : <>
                                        <p className={`no-ivr-alert ${ivrType && 'ivr-type-tag-label'} ${tag && 'with-tag-label'}`}>
                                            {!ivrType ? "Please filter dashboard by IVR Type to view tag data." : getTagSecTitle()}
                                        </p>
                                        <Doughnut
                                            options={tagsDoughnutOptions}
                                            data={tagsData}
                                            height={ivrType ? 215 : 185}
                                        />
                                        {ivrType && <div className={`tag-metrics`}>
                                            <Title className="metric-title" level={5}>Tag Metrics</Title>
                                            {firstMetric && <p className="first-metric">{firstMetric}</p>}
                                            {secondMetric && <p className="first-metric">{secondMetric}</p>}
                                        </div>}
                                    </>
                                }
                            </ListCard>
                        </Col>
                    </Row>
                </Col>
                <Col xs={17} md={17}>
                    <Title level={5}>{ivrType} Call Analytics</Title>
                    <ListCard hoverable bordered={false} className="chart-warpper mb-15">
                        <div className="chart-header">Call Handle Time and Sentiment</div>
                        <Row gutter={[24, 24]} onBlur={onBlur}>
                            {(isLoading || !callLengthData || !selectedSentiment) ?
                                <CenterContainer>
                                    <Spin tip='Loading' />
                                </CenterContainer> : <>
                                    <Col xs={6} md={6}>
                                        <div className="sentiment-label">Sentiment: {sentiment}</div>
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
                        <div className="chart-header mt-15">Call Volume Over Time</div>
                        <Row gutter={[24, 24]}>
                            {(isLoading || !callVolumeData) ?
                                <CenterContainer>
                                    <Spin tip='Loading' />
                                </CenterContainer> :
                                <Line options={LineChartOptions} data={callVolumeData} height={350} />
                            }
                        </Row>
                    </ListCard>
                </Col>
            </Row>
        </>
    )
}

export default Dashboard;