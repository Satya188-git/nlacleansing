import { Button, Col, Divider, Input, Pagination, Row, Spin, Typography } from 'antd';
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
	const [filtered, setFiltered] = useState(false);
	const [isLoading, setIsLoading] = useState(true);
	const [callIdSearchLoading, setCallIdSearchLoading] = useState(false);
	const date = useSelector((state: any) => state.ccc.date);
	const tags = useSelector((state: any) => state.ccc.tags);
	const agent = useSelector((state: any) => state.ccc.agent);
	const callDuration = useSelector((state: any) => state.ccc.callDuration);
	const callID = useSelector((state: any) => state.ccc.callID);
	const [page, setPage] = useState(1);
	const [limit, setLimit] = useState(30);
	const pageSizeOptions = [30, 50, 100];
	const [listOfValues, setListOfValues] = useState({ agentList: [], tagList: [] });
	const dispatch = useDispatch();

	const [pageDetails, setPageDetails] = useState(null);

	const { Title } = Typography;
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
				page,
				limit,
			}
			if (callDuration) params = { ...params, callduration: callDuration };
			if (tags.length > 0) params = { ...params, calltags: tags.toString() };
			if (callID) params = { ...params, callid: callID };
			axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-list`, { params })
				.then(res => {
					setPageDetails(res.data);
					dispatch(setCallInsights(res?.data?.contents || []));
				}).catch((error) => {
					console.log(error);
				}).finally(() => {
					setIsLoading(false);
					if (filtered) setFiltered(false);
					setCallIdSearchLoading(false);
				})
		}
	}, [isLoading, callIdSearchLoading, page, limit]);

	useEffect(() => {
		var _params: any = {
			callstartdate: `${date.startDate} 00:00:00.000`,
			callenddate: `${date.endDate} 00:00:00.000`,
		}
		if (callDuration) _params = { ..._params, callduration: callDuration };
		axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-list-tagagentlister`, { params: _params })
			.then(res => {
				setListOfValues(res.data);
			}).catch((error) => {
				console.log(error);
			});
	}, [date, callDuration]);

	if (!pageLoaded) {
		return <div></div>;
	}

	const onSearch = () => {
		dispatch(resetData());
		setCallIdSearchLoading(true);
		setPage(1);
	}

	const onFilter = () => {
		setIsLoading(true);
		setPage(1);
		setFiltered(true);
		dispatch(setCallID(""));
	}

	const onChange = (page, pageSize) => {
		setPage(page);
		setLimit(pageSize);
		setIsLoading(true);
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
					disabled={isLoading}
				/>
			</Row>
			<Divider />
			<Row gutter={[24, 24]} className="filter-section">
				<Col xs={7} md={7}>
					<DateSelector />
				</Col>
				<Col xs={5} md={5}>
					<CallIntentSelector tagList={listOfValues?.tagList} />
				</Col>
				<Col xs={5} md={5}>
					<AgentSearch agentList={listOfValues?.agentList} />
				</Col>
				<Col xs={4} md={4}>
					<TimeSelector />
				</Col>
				<Col xs={3} md={3}>
					<Button
						title='Search Filters'
						onClick={onFilter}
						className="search-btn mt-27"
						// icon={<SearchOutlined />}
						loading={filtered}
						disabled={isLoading || callIdSearchLoading}
					>Filter</Button>
				</Col>
			</Row>
			<Divider />
			{(pageDetails && !filtered && !callIdSearchLoading) && <Row className='call-list-pagination'>
				<Pagination
					showSizeChanger
					onChange={onChange}
					defaultCurrent={pageDetails?.currentPageNumber}
					pageSize={limit}
					pageSizeOptions={pageSizeOptions}
					total={pageDetails?.totalRecordCount}
				/>
			</Row>}
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
