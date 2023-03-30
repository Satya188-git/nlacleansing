import { Spin, Typography } from "antd";
import axios from "axios";
import { ListCard } from "components";
import DateUtil from "helpers/DateUtil";
import { useEffect, useState } from "react";
import { Doughnut } from "react-chartjs-2";
import { useDispatch, useSelector } from "react-redux";
import { setAllTags, setTag } from "reducers/dashboard-reducer";
import styled from 'styled-components';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
    height: 400px;
    vertical-align: middle;
`;

const CallTagsChart = () => {
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    const tag = useSelector((state: any) => state.dashboard.tag);
    const [isTagsLoading, setIsTagsLoading] = useState(false);
    const [tagsData, setTagsData] = useState(null);
    const [tagsMetrics, setTagsMetrics] = useState([]);
    const { Title } = Typography;
    const [firstMetric, setFirstMetric] = useState("");
    const [secondMetric, setSecondMetric] = useState("");
    const [thirdMetric, setThirdMetric] = useState("");
    const dispatch = useDispatch();

    const getTagSecTitle = () => {
        let title = `Tracked Tags - ${ivrType}`;
        if (tag) {
            title = `Top 5 Most Common "${tag}" Co-occurrences`;
        }
        return title;
    }

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
                const metric = tagsMetrics?.find(i => i["level1cooccurtagLabel"] === label);
                if (!tag) setFirstMetric(`"${label}" occurred ${count} time${count > 1 ? 's' : ''}`);
                else {
                    setSecondMetric(`"${tag}" > "${label}" occurred ${count} time${count > 1 ? 's' : ''}`);
                    setThirdMetric(`"${tag}" > "${label}" > "${metric?.level2cooccurtagLabel}" occurred ${metric?.level2cooccurtagcount} time${metric?.level2cooccurtagcount > 1 ? 's' : ''}`);
                }
            } else {
                if (!tag) setFirstMetric("");
                setSecondMetric("");
                setThirdMetric("");
            }
        },
    };

    const setParams = () => {
        var params: any = {
            callstartdate: date.startDate,
            callenddate: date.endDate,
        }
        if (ivrType) params = { ...params, ivrcallcategory: ivrType };
        return params;
    }

    useEffect(() => {
        setIsTagsLoading(true);
        setTagsData(null);
        let params = setParams();
        if (tag) params = { ...params, taglabel1: tag };
        if (ivrType) {
            axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-tag`, { params })
                .then(res => {
                    if (!tag) {
                        dispatch(setAllTags(res.data?.map(i => i.tagLabel) || []));
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
                                    borderColor: DateUtil.TAGS_CHART_BORDER_COLOR
                                }]
                        });
                    } else {
                        setTagsMetrics(res.data);
                        const tagDetails = res.data?.find(i => i["chosentaglabel"]);
                        const coOccurData = res.data?.filter(i => i["level1cooccurtagLabel"]);
                        setFirstMetric(`"${tagDetails?.chosentaglabel}" occurred ${tagDetails?.chosentagcount} times` || "");
                        setTagsData({
                            labels: coOccurData?.map(i => i.level1cooccurtagLabel),
                            datasets: [
                                {
                                    data: coOccurData?.map(i => i.level1cooccurtagcount),
                                    backgroundColor: coOccurData?.map((_, i) =>
                                        DateUtil.namedColor(i)
                                    ),
                                    fill: true,
                                    borderWidth: 0,
                                    hoverBorderWidth: 2,
                                    borderColor: DateUtil.TAGS_CHART_BORDER_COLOR
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
                    labels: [], datasets: [{ data: [1], backgroundColor: DateUtil.TAGS_CHART_BG_COLOR, borderColor: DateUtil.TAGS_CHART_BORDER_COLOR }]
                });
                dispatch(setAllTags([]));
                dispatch(setTag(''));
                setIsTagsLoading(false);
            }, 200);
        }
    }, [date, ivrType, tag]);

    return (
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
                        {thirdMetric && <p className="first-metric">{thirdMetric}</p>}
                    </div>}
                </>
            }
        </ListCard>

    )
}

export default CallTagsChart;