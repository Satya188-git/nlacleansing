import { Col, List, Modal, Row, Select, Space } from 'antd';
import { EventType } from 'constants/event';
import { useSLDataContext } from 'context/SLDataContext';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { useEventTypeContext } from 'context/EventTypeContext';
import { capitalize } from 'helpers/StringUtil';
import Image from 'next/image';
import React, { useState } from 'react';
import styled from 'styled-components';
import { Partner } from '../constants/partner';
import { useDateContext } from '../context/DateContext';
import { usePartnerContext } from '../context/PartnerContext';
import { useSocialChannelContext } from '../context/SocialChannelContext';
import IEvent from '../types/event';
import CardTitle from './atoms/CardTitle';
import ListCard from './atoms/ListCard';
import EventCategoryMetaData from './EventCategoryMetaData';
import FAQCard from './FAQCard';
import LocalMediaCard from './LocalMediaCard';
import TopPostList from './TopPostList';

const { Option } = Select;

const ContentTitle = styled.div`
	overflow: hidden;
`;

const ImageTitleContainer = styled.div`
	display: flex;
	flex: 1;
	align-items: center;
`;

const sdgeOperationEventData = [
	{
		category: 'Planned Outages',
		events: [
			{
				event_type: 'Planned Outage',
				event_location: 'Beach Cities',
				datestamp: '2022-04-15',
				timestamp: '10:30AM - 2:45PM',
				net_score: -18,
				impression_count: 2100,
				engagement_count: 32,
				pos_count: 38,
				neg_count: 90,
				neu_count: 115,
			},
		],
	},
	{
		category: 'Red Flag Warnings',
		events: [
			{
				event_type: 'Red Flag',
				event_location: 'Beach Cities',
				datestamp: '2022-05-02',
				timestamp: '1:30PM - 4:45PM',
				net_score: 34,
				impression_count: 1200,
				engagement_count: 545,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
			{
				event_type: 'Red Flag',
				event_location: 'Ramona and Eastern',
				datestamp: '2021-09-10',
				timestamp: '5:30PM - 10:45PM',
				net_score: -58,
				impression_count: 987,
				engagement_count: 256,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
			{
				event_type: 'Red Flag',
				event_location: 'Mountain Empire',
				datestamp: '2022-10-08',
				timestamp: '6:30AM - 2:45PM',
				net_score: 90,
				impression_count: 450,
				engagement_count: 25,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
		],
	},
];

const scgOperationEventData = [
	{
		category: 'Brush Fires',
		events: [
			{
				event_type: 'Palmer Type',
				event_location: 'Beach Cities',
				datestamp: '2022-04-15',
				timestamp: '10:30AM - 2:45PM',
				net_score: -18,
				impression_count: 2100,
				engagement_count: 32,
				pos_count: 38,
				neg_count: 90,
				neu_count: 115,
			},
		],
	},
	{
		category: 'Red Flag Warnings',
		events: [
			{
				event_type: 'Red Flag',
				event_location: 'Beach Cities',
				datestamp: '2022-05-02',
				timestamp: '1:30PM - 4:45PM',
				net_score: 34,
				impression_count: 1200,
				engagement_count: 545,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
			{
				event_type: 'Red Flag',
				event_location: 'Ramona and Eastern',
				datestamp: '2021-09-10',
				timestamp: '5:30PM - 10:45PM',
				net_score: -58,
				impression_count: 987,
				engagement_count: 256,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
			{
				event_type: 'Red Flag',
				event_location: 'Mountain Empire',
				datestamp: '2022-10-08',
				timestamp: '6:30AM - 2:45PM',
				net_score: 90,
				impression_count: 450,
				engagement_count: 25,
				pos_count: 18,
				neg_count: 90,
				neu_count: 40,
			},
		],
	},
];

const OperationEvents: React.FC = () => {
	const [modal2Visible, setModal2Visible] = useState(false);
	const [eventInfo, setEventInfo] = useState<IEvent>();
	const { setChannel } = useSocialChannelContext();
	const { partner } = usePartnerContext();

	const { date } = useDateContext();
	const {
		data: { timeline },
	} = useSLDataContext();
	const { keyword } = useEventKeywordContext();
	const { event } = useEventTypeContext();
	let fireFilteredEvents = Array<IEvent>();
	let pspsFilteredEvents = Array<IEvent>();
	let diginFilteredEvents = Array<IEvent>();
	const isSDGE = partner.name === Partner.SDGE;

	timeline.forEach((item) => {
		if (item.datestamp >= date.start && item.datestamp <= date.end) {
			item.events.forEach((event) => {
				if (
					event.event_type?.toLowerCase() === EventType.WILDFIRE &&
					fireFilteredEvents.findIndex(
						(i) => i.event_lat_long === event.event_lat_long
					) === -1
				) {
					fireFilteredEvents.push(event);
				}
				if (
					isSDGE &&
					event.event_type?.toLowerCase() === EventType.PSPS &&
					pspsFilteredEvents.findIndex(
						(i) => i.event_lat_long === event.event_lat_long
					) === -1
				) {
					pspsFilteredEvents.push(event);
				}
				if (
					!isSDGE &&
					event.event_type?.toLowerCase() === EventType.DIG_INS &&
					diginFilteredEvents.findIndex(
						(i) => i.event_lat_long === event.event_lat_long
					) === -1
				) {
					diginFilteredEvents.push(event);
				}
			});
		}
	});

	if (!!event.type || !!keyword.name) {
		if (isSDGE) {
			pspsFilteredEvents = pspsFilteredEvents.filter((i) => {
				if (i.event_keyword) {
					return (
						i.event_type.toLowerCase() === event.type ||
						i.event_keyword === keyword.name
					);
				}
				return i.event_type.toLowerCase() === event.type;
			});
		}
		diginFilteredEvents = diginFilteredEvents.filter((i) => {
			if (i.event_keyword) {
				return (
					i.event_type.toLowerCase() === event.type || i.event_keyword === keyword.name
				);
			}
			return i.event_type.toLowerCase() === event.type;
		});
		fireFilteredEvents = fireFilteredEvents.filter((i) => {
			if (i.event_keyword) {
				return (
					i.event_type.toLowerCase() === event.type || i.event_keyword === keyword.name
				);
			}
			return i.event_type.toLowerCase() === event.type;
		});
	}

	const operationEventData =
		partner.name === Partner.SCG ? scgOperationEventData : sdgeOperationEventData;

	const openModal = (eventInfo: IEvent) => {
		setEventInfo(eventInfo);
		setModal2Visible(true);
	};

	const handleSocialSelectChange = (value: string) => {
		setChannel({ name: value });
	};

	return (
		<>
			{(event.type === '' || event.type === EventType.WILDFIRE) && (
				<Col xs={24} xl={8}>
					<Space style={{ display: 'flex' }}>
						<Image src={'/fire.svg'} width={18} height={18} />{' '}
						<CardTitle title={`WildFire (${fireFilteredEvents.length})`} />
					</Space>
					<ListCard
						hoverable
						bordered={false}
						id={`${EventType.WILDFIRE}EventsScrollableDiv`}
						style={{ height: 600 }}
					>
						<List
							dataSource={fireFilteredEvents}
							renderItem={(item, i) => {
								return (
									<List.Item
										key={`${i}${item.event_type}`}
										// actions={[
										// 	<Button
										// 		onClick={() => {
										// 			openModal(item);
										// 		}}
										// 		type='text'
										// 		icon={<RightOutlined />}
										// 		size='small'
										// 	/>,
										// ]}
									>
										<List.Item.Meta
											title={
												<ContentTitle>
													{`${item.event_name} in ${item.event_location}`}
												</ContentTitle>
											}
											description={
												<>
													<ContentTitle>
														<EventCategoryMetaData {...item} />
													</ContentTitle>
												</>
											}
										/>
									</List.Item>
								);
							}}
						/>
					</ListCard>
				</Col>
			)}
			{!isSDGE && (event.type === '' || event.type === EventType.DIG_INS) && (
				<Col xs={24} xl={8}>
					<Space style={{ display: 'flex' }}>
						<Image src={'/alert.svg'} width={18} height={18} />{' '}
						<CardTitle title={`Dig-in (${diginFilteredEvents.length})`} />
					</Space>
					<ListCard
						hoverable
						bordered={false}
						id={`${EventType.DIG_INS}OperationEventsScrollableDiv`}
						style={{ height: 600 }}
					>
						<List
							dataSource={diginFilteredEvents}
							renderItem={(item, i) => {
								return (
									<List.Item
										key={`${i}${item.event_type}`}
										// actions={[
										// 	<Button
										// 		onClick={() => {
										// 			openModal(item);
										// 		}}
										// 		type='text'
										// 		icon={<RightOutlined />}
										// 		size='small'
										// 	/>,
										// ]}
									>
										<List.Item.Meta
											title={
												<ContentTitle>
													{`${capitalize(item.event_location)}`}
												</ContentTitle>
											}
											description={
												<>
													<ContentTitle>
														<EventCategoryMetaData {...item} />
													</ContentTitle>
												</>
											}
										/>
									</List.Item>
								);
							}}
						/>
					</ListCard>
				</Col>
			)}
			{isSDGE && (event.type === '' || event.type === EventType.PSPS) && (
				<Col xs={24} xl={8}>
					<Space style={{ display: 'flex' }}>
						<Image src={'/outage.svg'} width={18} height={18} />{' '}
						<CardTitle title={`PSPS (${pspsFilteredEvents.length})`} />
					</Space>
					<ListCard
						hoverable
						bordered={false}
						id={`${EventType.PSPS}EventsScrollableDiv`}
						style={{ height: 600 }}
					>
						<List
							dataSource={pspsFilteredEvents}
							renderItem={(item, i) => {
								return (
									<List.Item
										key={`${i}${item.event_type}`}
										// actions={[
										// 	<Button
										// 		onClick={() => {
										// 			openModal(item);
										// 		}}
										// 		type='text'
										// 		icon={<RightOutlined />}
										// 		size='small'
										// 	/>,
										// ]}
									>
										<List.Item.Meta
											title={
												<ContentTitle>
													{`${item.event_name} in ${item.event_location}`}
												</ContentTitle>
											}
											description={
												<>
													<ContentTitle>
														<EventCategoryMetaData {...item} />
													</ContentTitle>
												</>
											}
										/>
									</List.Item>
								);
							}}
						/>
					</ListCard>
				</Col>
			)}
			{/* {operationEventData.map((item, i) => {
				return (
					<Col xs={24} xl={8} key={`${i}`}>
						<CardTitle title={`${item.category}`} />
						<ListCard
							hoverable
							bordered={false}
							id={`${i}operationEventsScrollableDiv`}
						>
							<List
								dataSource={item.events}
								renderItem={(event, i) => {
									return (
										<List.Item
											key={`${i}${event}`}
											actions={[
												<Button
													onClick={() => {
														openModal(event);
													}}
													type='text'
													icon={<RightOutlined />}
													size='small'
												/>,
											]}
										>
											<List.Item.Meta
												title={
													<ContentTitle>
														{`${event.event_type} in ${event.event_location}`}
													</ContentTitle>
												}
												description={
													<>
														<ContentTitle>
															{event.timestamp} ({event.datestamp}
															)<br />
															<b>{`${event.net_score} positivity`}</b>
															<br />
															{`${event.engagement_count} Mentions / ${event.impression_count} Impressions`}
														</ContentTitle>
													</>
												}
											/>
										</List.Item>
									);
								}}
							/>
						</ListCard>
					</Col>
				);
			})} */}
			<Modal
				title={`${eventInfo?.event_name || eventInfo?.event_type} in ${
					eventInfo?.event_location
				}`}
				centered
				visible={modal2Visible}
				onOk={() => setModal2Visible(false)}
				onCancel={() => setModal2Visible(false)}
				width={'90%'}
			>
				<Select
					defaultValue='all'
					style={{ width: 120 }}
					size='large'
					onChange={handleSocialSelectChange}
				>
					<Option value='all'>All</Option>
					<Option value='twitter'>Twitter</Option>
					<Option value='reddit'>Reddit</Option>
				</Select>
				<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }}>
					<Col xs={24} xl={6}>
						<TopPostList title='Top Positive' sentimentAnalysis='Positive' />
					</Col>
					<Col xs={24} xl={6}>
						<TopPostList title='Top Negative' sentimentAnalysis='Negative' />
					</Col>
					<Col xs={24} xl={6}>
						<FAQCard />
					</Col>
					<Col xs={24} xl={6}>
						<LocalMediaCard />
					</Col>
				</Row>
			</Modal>
		</>
	);
};

export default OperationEvents;
