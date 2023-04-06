import { Card, Col, Row, Spin } from "antd";
import axios from "axios";
import moment from "moment";
import { useEffect, useState } from "react";
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

const CallDetails = () => {
    const [isLoading, setIsLoading] = useState(false);
    const [callDetails, setCallDetails] = useState(null);
    const date = useSelector((state: any) => state.dashboard.date);
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);

    const formatted = (secs) => {
        let time = "";
        if (secs) time = moment.utc(secs * 1000).format('HH:mm:ss');
        if (parseInt(time.split(":")[0]) === 0) {
            time = `${time.split(":")[1]}:${time.split(":")[2]}`;
        }
        return time;
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
        axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-aggregated-overallcount`, { params })
            .then(res => {
                setCallDetails(res.data);
            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setIsLoading(false);
            })

    }, [date, ivrType]);

    return (
        isLoading ?
            <CenterContainer>
                <Spin tip='Loading' />
            </CenterContainer> :
            <>
                <Card className="count-card no-border mb-15">
                    <p className="count-val">{callDetails?.totalCallCount}</p>
                    <p>Total Calls</p>
                </Card>
                <Row gutter={[24, 24]} className="mb-15">
                    <Col xs={12} md={12}>
                        <Card className="count-card no-border">
                            <p className="count-val">{formatted(callDetails?.averageTalkTime) || ""}</p>
                            <p>Average Talk Time</p>
                        </Card>
                    </Col>
                    <Col xs={12} md={12}>
                        <Card className="count-card no-border">
                            <p className="count-val">{formatted(callDetails?.averageHoldTime) || ""}</p>
                            <p>Average Hold Time</p>
                        </Card>
                    </Col>
                </Row>
                <Card className="count-card no-border mb-15">
                    <p className="count-val">{callDetails?.positiveCount}%</p>
                    <p>Percent Resolved with Positive Sentiment</p>
                </Card>
            </>
    )
}

export default CallDetails;