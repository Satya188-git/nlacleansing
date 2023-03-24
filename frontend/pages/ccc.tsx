import { SearchOutlined, UserOutlined } from '@ant-design/icons';
import { Button, Col, Divider, Input, Row, Space, Spin, Typography } from 'antd';
import { Partner } from 'constants/partner';
import AuthenticatorContext from 'context/AuthenticatorContext';
import { useCallFilterContext } from 'context/CallFilterContext';
import { useCCCDataContext } from 'context/CCCDataContext';
import { useDateContext } from 'context/DateContext';
import { usePartnerContext } from 'context/PartnerContext';
import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import Router from 'next/router';
import React, { useEffect, useRef, useState } from 'react';
import styled from 'styled-components';
import { ICallInsight } from 'types/callInsight';
import { CallIntentSelector, CallsList, DateSelector, TimeSelector } from '../components';
import axios from 'axios';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
`;

const CustomerCallCenterAnalytics: React.FC = () => {
	const { date } = useDateContext();
	const { partner } = usePartnerContext();
	const {
		setCCCData,
		cccData: { callInsights, isLoading, callID },
	} = useCCCDataContext();
	const {
		setCallFilter,
		callFilter: { filteredCallInsightData, callDuration, tags },
	} = useCallFilterContext();
	const [pageLoaded, setPageLoaded] = useState(false);
	const [isFiltering, setIsFiltering] = useState(false);
	const [saveFilteredResults, setSaveFilteredResults] = useState(filteredCallInsightData);
	const callIDRef = useRef(null);

	useEffect(() => {
		if (partner.name === Partner.SCG) {
			Router.push('/');
		} else {
			setPageLoaded(true);
		}
	}, []);

	useEffect(() => {
		if (callIDRef.current && callIDRef.current.input.value === '') {
			setCallFilter((prev) => ({
				...prev,
				justNewlyFiltered: true,
				isCallIDSearch: true,
				filteredCallInsightData: saveFilteredResults,
			}));
		}
	}, [callIDRef]);

	useEffect(() => {
		if (isLoading) {
			var params: any = {
				callstartdate: `${moment(date.start).format(format)} 00:00:00.000`,
				callenddate: `${moment(date.end).format(format)} 00:00:00.000`,
			}
			if (callDuration) params = { ...params, callduration: callDuration };
			if (tags.length > 0) params = { ...params, calltags: tags.toString() };
			if (callID) params = { ...params, callid: callID };
			axios.get(`${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-list`, { params })
				.then(res => {
					setCCCData((prev) => ({ ...prev, callInsights: res.data as Array<ICallInsight> }));
				}).catch((error) => {
					console.log(error);
				}).finally(() => {
					setCCCData((prev) => ({ ...prev, isLoading: false }));
				})
		}
	}, [isLoading]);

	if (!pageLoaded) {
		return <div></div>;
	}

	const { Title } = Typography;
	const format = DateUtil.DATE_FORMAT;
	const { Search } = Input;

	const onFilter = () => {
		setIsFiltering(true);
		setCCCData((prev) => ({
			...prev,
			isLoading: true,
		}));
		setCallFilter((prev) => ({
			...prev,
			justNewlyFiltered: true,
			isCallIDSearch: false,
		}));
		if (date.start === '' && date.end === '' && callDuration === '' && tags.length === 0) {
			setCallFilter((prev) => ({
				...prev,
				justNewlyFiltered: true,
				isCallIDSearch: false,
				filteredCallInsightData: callInsights,
			}));
		} else {
			console.log('*******UNKNOWN FILTERING CONDITION!!');
		}
		setIsFiltering(false);
	};

	const onSearch = (id: string) => {
		setIsFiltering(true);
		setCCCData((prev) => ({
			...prev,
			callID: id,
		}));
		setIsFiltering(false);
		onFilter();
	};

	return (
		<>
			<Title>Customer Call Center Analytics Dashboard</Title>
			<Row gutter={[24, 24]} className="filter-section">
				<Col xs={24} md={24}>
					<Title level={5}>NICE Call ID</Title>
					<Search
						ref={callIDRef}
						size='middle'
						style={{ width: 250, marginBottom: "2rem" }}
						allowClear
						placeholder='Search by NICE Call ID'
						value={callID}
						onChange={(evt) => setCCCData((prev) => ({ ...prev, callID: evt.target.value, }))}
						// prefix={<UserOutlined />}
						// onSearch={onSearch}
						// loading={isFiltering}
					/>
					<Space>
						<DateSelector />
						<CallIntentSelector />
						<TimeSelector />
						<Button
							title='Search Filters'
							onClick={onFilter}
							className="search-btn mt-27"
							// icon={<SearchOutlined />}
							loading={isFiltering}
						>Search</Button>
					</Space>
				</Col>
			</Row>
			<Divider />
			<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }}>
				{isFiltering ? (
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
