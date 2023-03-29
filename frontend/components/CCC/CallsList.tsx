import { SmileOutlined } from '@ant-design/icons';
import { Card, Col, Result, Row, Spin, Typography } from 'antd';
import { useCallFilterContext } from 'context/CallFilterContext';
import { useRouter } from 'next/router';
import React, { useEffect, useState } from 'react';
// import { useBottomScrollListener } from 'react-bottom-scroll-listener';
import styled from 'styled-components';
import { ICallInsight } from 'types/callInsight';
import CallSummary from './CallSummary';
import CallTags from './CallTags';

const CallCardContainer = styled(Card)`
	margin-top: 16px;
	border: none;
`;

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
	margin-top: 16px;
	margin-left: 16px;
`;
const UnstyledButton = styled.button`
	background: none;
	color: inherit;
	border: none;
	padding: 0;
	font: inherit;
	cursor: pointer;
	outline: inherit;
	text-align: left;
`;

const CallsList: React.FC = () => {
	const {
		setCallFilter,
		callFilter: { filteredCallInsightData, justNewlyFiltered, isCallIDSearch, isLoading },
	} = useCallFilterContext();
	const [data, setData] = useState<ICallInsight[]>([]);
	const [pageLoading, setPageLoading] = useState(false);
	const [count, setCount] = useState(0);
	const [hasMoreData, setHasMoreData] = useState(true);
	const [noResult, setNoResult] = useState(false);
	const router = useRouter();
	const [moreDataLoading, setMoreDataLoading] = useState(false);
	const { Title } = Typography;

	const checkFilteredDataExisting =
		Array.isArray(filteredCallInsightData) &&
		filteredCallInsightData !== undefined &&
		filteredCallInsightData.length > 0;

	const resetData = () => {
		// setCount(20);
		setData([]);
		setCallFilter((prev) => ({ ...prev, justNewlyFiltered: false, isCallIDSearch: false }));
	};

	const loadMoreData = () => {
		if (pageLoading) return;

		setMoreDataLoading(true);

		if (justNewlyFiltered) {
			resetData();
			// } else if (count >= filteredCallInsightData.length) {
			// 	setHasMoreData(false);
			// 	setMoreDataLoading(false);
			// 	return;
		} else {
			// if (isCallIDSearch || filteredCallInsightData.length < 20) return;
			setData([...data, ...filteredCallInsightData]);
			// setCount((prev) => prev + 20);
		}
		setMoreDataLoading(false);
	};

	const handleClick = (selectedCallInsightData: ICallInsight) => {
		router.push(`/ccc/${selectedCallInsightData.callID}`);
	};

	const toHoursAndMinutes = (totalSeconds) => {
		const totalMinutes = Math.floor(totalSeconds / 60);

		const seconds = totalSeconds % 60;
		const hours = Math.floor(totalMinutes / 60);
		const minutes = totalMinutes % 60;

		return `${hours}:${minutes}:${seconds}`;
	}

	useEffect(() => {
		setData(filteredCallInsightData);
		setPageLoading(false);
		// loadMoreData();
		if (filteredCallInsightData.length === 0) {
			if (!isLoading) setNoResult(true);
			else setNoResult(false);
		} else {
			setPageLoading(true);
		}
	}, [filteredCallInsightData, isLoading]);

	useEffect(() => {
		if (isLoading) setData([]);
	}, [isLoading])


	// useBottomScrollListener(loadMoreData, {
	// 	offset: 100,
	// 	debounce: 0,
	// 	triggerOnNoScroll: true,
	// });

	return (
		<>
			{(data.length > 0 && !isLoading) ? (
				data.map((item: ICallInsight) => {
					return (
						<Col key={`${item.callID}`} span={24}>
							<CallCardContainer hoverable bordered={false}>
								<UnstyledButton
									style={{ width: '100%' }}
									onClick={() => handleClick(item)}
								>
									<Row gutter={[24, 24]}>
										<Col
											xs={24}
											sm={12}
											md={6}
											// style={{ borderRight: '1px solid #0E263B' }}
										>
											<Title level={5} className="f-16">{item.segmentStartTime?.split(".")?.[0]}</Title>
											<Row>
												<Title level={5}>
													Duration: <span className='fw-100'>{toHoursAndMinutes(item.callLengthSeconds)}</span>
												</Title>
											</Row>
											<Row>
												<Title level={5}>
													Agent: <span className='fw-100'>{item.agentFullName}</span>
												</Title>
											</Row>
										</Col>
										<Col
											xs={24}
											sm={12}
											md={6}
											// style={{ borderRight: '1px solid #0E263B' }}
										>
											<Row>
												<Title level={5}>
													NICE Call ID: <span className='fw-100'>{item.callID}</span>
												</Title>
											</Row>
											<Row>
												<Title level={5}>
													Customer Type: <span className='fw-100'>{item.customerType}</span>
												</Title>
											</Row>
											<Row>
												<Title level={5}>
													IVR Category: <span className='fw-100'>{item.ivrCallCategory}</span>
												</Title>
											</Row>
										</Col>
										<Col
											xs={24}
											sm={12}
											md={6}
											// style={{ borderRight: '1px solid #0E263B' }}
										>
											<Title level={5}>
												Summary:{' '}
											</Title>
											<CallSummary {...item} />
										</Col>
										<Col xs={24} sm={12} md={6}>
											<Title level={5} className="mb-0">
												Tags:
											</Title>
											<CallTags {...item} />
										</Col>
									</Row>
								</UnstyledButton>
							</CallCardContainer>
						</Col>
					);
				})
			) : (
				<>
					{noResult && (
						<CenterContainer>
							<Result icon={<SmileOutlined />} title='No results, please try again' />
						</CenterContainer>
					)}
				</>
			)}
			{/* {moreDataLoading && (
				<CenterContainer>
					<Spin tip='Loading More Data' />
				</CenterContainer>
			)}
			{!hasMoreData ? (
				<CenterContainer>
					<Title level={5}>** End of call list **</Title>
				</CenterContainer>
			) : (
				<CenterContainer>
					<Title level={5}>** Scroll down to load more call data **</Title>
				</CenterContainer>
			)} */}
		</>
	);
};

export default CallsList;
