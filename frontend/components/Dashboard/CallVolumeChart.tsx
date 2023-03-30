import { Row, Spin } from "antd";
import styled from 'styled-components';
import axios from "axios";
import { useEffect, useState } from "react";
import { Line } from "react-chartjs-2";
import { LineChartOptions } from "helpers/line-chart-options";
import DateUtil from "helpers/DateUtil";
import { useSelector } from "react-redux";

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
    height: 400px;
    vertical-align: middle;
`;

const CallVolumeChart = () => {
    const [isLoading, setIsLoading] = useState(false);
    const [callVolumeData, setCallVolumeData] = useState(null);
    const monthDiff = DateUtil.monthDiff;
    const [ivrTypes, setIvrTypes] = useState([]);
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    
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
                            borderColor: DateUtil.CALL_VOLUME_CHART_COLOR[0],
                            borderWidth: 4,
                            backgroundColor: DateUtil.CALL_VOLUME_CHART_COLOR[0],
                        }
                        dataset = [...dataset, obj];
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
    }, [date, ivrType]);
    return (
        <Row gutter={[24, 24]}>
            {(isLoading || !callVolumeData) ?
                <CenterContainer>
                    <Spin tip='Loading' />
                </CenterContainer> :
                <Line options={LineChartOptions} data={callVolumeData} height={350} />
            }
        </Row>
    )
}

export default CallVolumeChart;