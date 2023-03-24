import { Col, Divider, Modal, Row, Select, Typography } from 'antd';
import { Theme } from 'constants/theme';
import { useSLDataContext } from 'context/SLDataContext';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { useEventTypeContext } from 'context/EventTypeContext';
import { filterTopPosts } from 'helpers/FilterDataUtil';
import { useEffect, useRef, useState } from 'react';
import { Bar, getElementAtEvent } from 'react-chartjs-2';
import styled from 'styled-components';
import { useDateContext } from '../context/DateContext';
import { useSocialChannelContext } from '../context/SocialChannelContext';
import { IEvent, ITimeline } from '../types';
import EventDetailsTable from './EventDetailsTable';
import FAQCard from './FAQCard';
import MetadataCard from './MetadataCard';
import TopPostList from './TopPostList';

const StyledBarGraph = styled.div`
	min-height: 400px;
	max-height: 650px;
`;

const SentimentAnalysisGraph: React.FC = () => {
	const [modal2Visible, setModal2Visible] = useState(false);
	const chartRef = useRef();
	const [clickData, setClickData] = useState<any>(null);
	const { date, setDate } = useDateContext();
	const { keyword } = useEventKeywordContext();
	const { event } = useEventTypeContext();
	const { setChannel } = useSocialChannelContext();
	const {
		data: { timeline, posts },
	} = useSLDataContext();
	const posUniqueData = filterTopPosts('Positive');
	const neuUniqueData = filterTopPosts('Neutral');
	const negUniqueData = filterTopPosts('Negative');

	const { Option } = Select;
	const { Title } = Typography;

	const filteredData = Array<ITimeline>();
	let events = Array<IEvent>();

	if (!!event.type) {
		if (!!keyword.name) {
			const arr = posts.filter((item) => {
				return (
					item.date >= date.start &&
					item.date <= date.end &&
					item.event_keyword === keyword.name
				);
			});
			timeline.forEach((item) => {
				if (item.datestamp >= date.start && item.datestamp <= date.end) {
					var index = arr.findIndex((arr) => arr.date === item.datestamp);
					if (index !== -1) {
						events = [];
						item.events.forEach((i) => {
							if (i.event_type.toLowerCase() === event.type) {
								events.push(i);
							}
						});
						filteredData.push({
							datestamp: item.datestamp,
							metrics: item.metrics,
							events: events,
							weather: item.weather,
						});
					}
				}
			});
		} else {
			timeline.forEach((item) => {
				if (item.datestamp >= date.start && item.datestamp <= date.end) {
					events = item.events.filter((i) => i.event_type.toLowerCase() === event.type);
					if (events.length > 0) {
						filteredData.push({
							datestamp: item.datestamp,
							metrics: item.metrics,
							events: events,
							weather: item.weather,
						});
					}
				}
			});
		}
	} else {
		timeline.forEach((item) => {
			if (item.datestamp >= date.start && item.datestamp <= date.end) {
				filteredData.push(item);
			}
		});
	}
	const [clickTimelineData, setClickTimelineData] = useState<ITimeline>();

	const handleSocialSelectChange = (value: string) => {
		setChannel({ name: value });
	};

	const graphData = {
		labels: filteredData.map((i) => i.datestamp),
		datasets: [
			{
				label: 'Positive Sentiments',
				data: filteredData.map((i) => i.metrics[0].metric_count),
				backgroundColor: 'green',
				borderWidth: 1,
				hoverOffset: 10,
			},
			{
				label: 'Negative Sentiments',
				data: filteredData.map((i) => i.metrics[1].metric_count),
				backgroundColor: 'red',
				borderWidth: 1,
				hoverOffset: 10,
			},
			{
				label: 'Neutral Sentiments',
				data: filteredData.map((i) => i.metrics[2].metric_count),
				backgroundColor: '#808080',
				borderWidth: 1,
				hoverOffset: 10,
			},
			{
				label: 'Events',
				data: filteredData.map((i) => {
					if (i.events.length > 0) {
						return 1;
					} else {
						return;
					}
				}),
				backgroundColor: Theme.ACCENT,
				borderColor: Theme.ACCENT,
				borderWidth: 1,
				hoverOffset: 10,
			},
		],
	};

	const initModalData = () => {
		if (clickData.length > 0) {
			setClickTimelineData(filteredData[clickData[0].index]);
			setDate({
				start: date.start,
				end: date.end,
				click: filteredData[clickData[0].index].datestamp,
			});

			if (!!date.click) {
				setModal2Visible(true);
			} else if (!date.click) {
				setModal2Visible(false);
			}
		}
	};

	const footer = (tooltipItems) => {
		let sum = 0;

		tooltipItems.forEach(function (tooltipItem) {
			if (
				tooltipItem.datasetIndex === 0 ||
				tooltipItem.datasetIndex === 1 ||
				tooltipItem.datasetIndex === 2
			) {
				sum += tooltipItem.raw;
			}
		});
		return 'Total Mentions: ' + sum;
	};

	useEffect(() => {
		if (clickData) {
			initModalData();
		}
	}, [clickData]);

	const config = {
		type: 'bar',
		data: graphData,
		options: {
			responsive: true,
			maintainAspectRatio: false,
			interaction: {
				intersect: false,
			},
			plugins: {
				title: {
					display: true,
					text: 'Sentiment Analysis',
					color: 'white',
				},
				legend: {
					labels: {
						color: 'white',
					},
				},
				datalabels: {
					display: false,
				},
				tooltip: {
					callbacks: {
						afterTitle: function (tooltipItem) {
							const tooltipDateData: ITimeline = filteredData.find(
								(i) => tooltipItem[0].label === i.datestamp
							);
							let eventLabelArr = [];
							if (tooltipDateData.events.length > 0) {
								tooltipDateData.events.forEach((i) => {
									eventLabelArr.push(`Event type: ${i.event_type}`);
									eventLabelArr.push(`Event name: ${i.event_name}`);
									eventLabelArr.push(`Event location: ${i.event_location}`);
									eventLabelArr.push(
										`Event date: ${i.event_start_date} - ${i.event_end_date}`
									);
									eventLabelArr.push(`Event Lat Lng: ${i.event_lat_long}`);
									eventLabelArr.push(`- - - - - - -`);
								});
							}
							if (!eventLabelArr) return;
							return eventLabelArr;
						},
						footer: footer,
					},
				},
			},
			scales: {
				x: {
					stacked: true,
				},
				y: {
					beginAtZero: true,
					stacked: true,
				},
			},
		},
	};

	return (
		<>
			<StyledBarGraph>
				<Bar
					ref={chartRef}
					onClick={(event) => {
						setClickData(getElementAtEvent(chartRef.current, event));
					}}
					data={config.data}
					options={config.options}
					height={300}
				/>
			</StyledBarGraph>
			{clickTimelineData && !!date.click && (
				<Modal
					title={
						<Title style={{ color: Theme.ACCENT }} level={1}>
							Sentiment Graph Details
						</Title>
					}
					centered
					visible={modal2Visible}
					onOk={() => {
						setDate({ start: date.start, end: date.end, click: '' });
						setModal2Visible(false);
					}}
					onCancel={() => {
						setDate({ start: date.start, end: date.end, click: '' });
						setModal2Visible(false);
					}}
					width={'90%'}
				>
					<Row gutter={8}>
						<Col flex={1}>
							<MetadataCard title='Total Mentions'>
								{posUniqueData.length + negUniqueData.length + neuUniqueData.length}
							</MetadataCard>
						</Col>
						<Col flex={1}>
							<MetadataCard title='Positive Sentiment'>
								{posUniqueData.length}
							</MetadataCard>
						</Col>
						<Col flex={1}>
							<MetadataCard title='Negative Sentiment'>
								{negUniqueData.length}
							</MetadataCard>
						</Col>
						<Col flex={1}>
							<MetadataCard title='Neutral Sentiment'>
								{neuUniqueData.length}
							</MetadataCard>
						</Col>
					</Row>
					<Divider />
					<EventDetailsTable {...clickTimelineData} />
					<Divider />
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
							<FAQCard />
						</Col>
						<Col xs={24} xl={6}>
							<TopPostList title='Top Positive' sentimentAnalysis='Positive' />
						</Col>
						<Col xs={24} xl={6}>
							<TopPostList title='Top Negative' sentimentAnalysis='Negative' />
						</Col>
						<Col xs={24} xl={6}>
							<TopPostList title='Top Neutral' sentimentAnalysis='Neutral' />
						</Col>
					</Row>
				</Modal>
			)}
		</>
	);
};

export default SentimentAnalysisGraph;
