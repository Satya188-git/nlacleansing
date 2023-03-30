import { Button, Col, Divider, Input, Row, Spin, Typography } from 'antd';
import { Partner } from 'constants/partner';
import { usePartnerContext } from 'context/PartnerContext';
import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import Router, { useRouter } from 'next/router';
import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { CallIntentSelector, CallsList, DateSelector, TimeSelector } from '../components';
import axios from 'axios';
import AgentSearch from 'components/CCC/AgentSearch';
import { useDispatch, useSelector } from 'react-redux';
import { resetAll, resetData, setCallID, setCallInsights } from 'reducers/ccc-reducer';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
`;

const CustomerCallCenterAnalytics: React.FC = () => {
	const { partner } = usePartnerContext();
	const [pageLoaded, setPageLoaded] = useState(false);
	const [isLoading, setIsLoading] = useState(true);
	const [callIdSearchLoading, setCallIdSearchLoading] = useState(false);
	const date = useSelector((state: any) => state.ccc.date);
	const tags = useSelector((state: any) => state.ccc.tags);
	const agents = useSelector((state: any) => state.ccc.agents);
	const callDuration = useSelector((state: any) => state.ccc.callDuration);
	const callID = useSelector((state: any) => state.ccc.callID);
	const dispatch = useDispatch();

	const { Title } = Typography;
	const format = DateUtil.DATE_FORMAT;
	const { Search } = Input;
    const router = useRouter();

	useEffect(() => {
		if (partner.name === Partner.SCG) {
			Router.push('/');
		} else {
			setPageLoaded(true);
		}
	}, []);
	
    useEffect(() => {
        router.events.on('routeChangeStart', (url) => {
            if (!url.includes("ccc")) {
                dispatch(resetAll());
            }
        });
    }, []);

	useEffect(() => {
		if (isLoading || callIdSearchLoading) {
			var params: any = {
				callstartdate: `${date.startDate} 00:00:00.000`,
				callenddate: `${date.endDate} 00:00:00.000`,
			}
			if (callDuration) params = { ...params, callduration: callDuration };
			if (tags.length > 0) params = { ...params, calltags: tags.toString() };
			if (callID) params = { ...params, callid: callID };
			axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-list`, { params })
				.then(res => {
					dispatch(setCallInsights(res.data));
				}).catch((error) => {
					console.log(error);
				}).finally(() => {
					setIsLoading(false);
					setCallIdSearchLoading(false);
				})
		}
	}, [isLoading, callIdSearchLoading]);

	if (!pageLoaded) {
		return <div></div>;
	}

	const onSearch = () => {
		dispatch(resetData());
		setCallIdSearchLoading(true);
	}

	return (
		<>
			<Row gutter={[24, 24]} className="call-list-header">
				<Title level={3} className="call-list-title">Customer Call List</Title>
				<Search
					size='middle'
					style={{ width: 250, marginBottom: "2rem" }}
					allowClear
					placeholder='Search by NICE Call ID'
					value={callID}
					onChange={(evt) => dispatch(setCallID(evt.target.value))}
					onSearch={onSearch}
					loading={callIdSearchLoading}
				/>
			</Row>
			<Divider />
			<Row gutter={[24, 24]} className="filter-section">
				<Col xs={7} md={7}>
					<DateSelector />
				</Col>
				<Col xs={5} md={5}>
					<CallIntentSelector />
				</Col>
				<Col xs={5} md={5}>
					<AgentSearch />
				</Col>
				<Col xs={4} md={4}>
					<TimeSelector />
				</Col>
				<Col xs={3} md={3}>
					<Button
						title='Search Filters'
						onClick={() => {setIsLoading(true); dispatch(setCallID(""))}}
						className="search-btn mt-27"
						// icon={<SearchOutlined />}
						loading={isLoading}
					>Filter</Button>
				</Col>
			</Row>
			{/* <Divider /> */}
			<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }} className="call-list-section">
				{(isLoading || callIdSearchLoading) ? (
					<CenterContainer>
						<Spin tip='Loading' />
					</CenterContainer>
				) : (
					<CallsList />
				)}
			</Row>
			<Divider />
		</>
	);
};

export default CustomerCallCenterAnalytics;
