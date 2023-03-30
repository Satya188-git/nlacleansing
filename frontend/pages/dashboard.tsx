import { Card, Col, Divider, Row, Typography } from "antd";
import { ListCard } from "components";
import CallHandleTimeSentimentChart from "components/Dashboard/CallHandleTimeSentimentCharts";
import CallTagsChart from "components/Dashboard/CallTagsChart";
import CallVolumeChart from "components/Dashboard/CallVolumeChart";
import ChartDateFilter from "components/Dashboard/ChartDateFilter";
import IvrTypes from "components/Dashboard/IvrType";
import TagFilter from "components/Dashboard/TagFilter";
import { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { resetDashboardData } from "reducers/dashboard-reducer";

const Dashboard = () => {
    const ivrType = useSelector((state: any) => state.dashboard.ivrType);
    const allTags = useSelector((state: any) => state.dashboard.allTags);
    const { Title } = Typography;
    const dispatch = useDispatch();

    useEffect(() => {
        return() => {
            dispatch(resetDashboardData());
        }
    }, []);

    return (
        <>
            <Row gutter={[24, 24]} className="dashboard-filter-section">
                <Title level={3} className="call-analytics-title">Customer Call Center Analytics</Title>
                <Col xs={10} md={10}>
                    <Row gutter={[24, 24]}>
                        <Col xs={14} md={14}>
                            <ChartDateFilter />
                        </Col>
                        <Col xs={10} md={10}>
                            <IvrTypes />
                        </Col>
                    </Row>
                </Col>
            </Row>
            {/* <Divider /> */}
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
                            <CallTagsChart />
                        </Col>
                    </Row>
                </Col>
                <Col xs={17} md={17} className="call-analysis-right-sec">
                    <Title level={5}>{ivrType} Call Analytics</Title>
                    <ListCard hoverable bordered={false} className="chart-warpper mb-15">
                        <div className="chart-header">Ending Sentiment and Call Volume By Handle Time</div>
                        <CallHandleTimeSentimentChart />
                        <div className="chart-header mt-15">Call Volume Over Time</div>
                        <CallVolumeChart />
                    </ListCard>
                </Col>
            </Row>
        </>
    )
}

export default Dashboard;