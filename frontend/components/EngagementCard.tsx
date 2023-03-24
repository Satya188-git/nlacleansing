import { ArrowsAltOutlined } from '@ant-design/icons';
import { Button, Card, Col, Modal, Row, Select, Space, Typography } from 'antd';
import { SocialMediaChannel } from 'constants/social';
import { useSLDataContext } from 'context/SLDataContext';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { useEventTypeContext } from 'context/EventTypeContext';
import { addUniquePostToArr } from 'helpers/FilterDataUtil';
import moment from 'moment';
import React, { useState } from 'react';
import { Doughnut } from 'react-chartjs-2';
import styled from 'styled-components';
import { IPost } from 'types';
import { useDateContext } from '../context/DateContext';
import { useSocialChannelContext } from '../context/SocialChannelContext';
import CardTitle from './atoms/CardTitle';
import DateSelector from './DateSelector';
import EventKeywordSelector from './EventKeywordSelector';
import TopicCard from './TopicCard';
import TopPostList from './TopPostList';

const GraphContainer = styled.div`
	padding: 1.5rem;
	min-height: 200px;
	max-height: 750px;
`;

const { Option } = Select;
const { Title } = Typography;

interface ISocialData {
	platform_name: string;
	engagement_count: number;
}

const EngagementCard: React.FC = () => {
	const [modal2Visible, setModal2Visible] = useState(false);
	const { date } = useDateContext();
	const { keyword } = useEventKeywordContext();
	const { event } = useEventTypeContext();
	const {
		data: { posts },
	} = useSLDataContext();
	const { channel, setChannel } = useSocialChannelContext();
	const uniqueData: Array<IPost> = [];
	const twitterData: Array<IPost> = [];
	const redditData: Array<IPost> = [];
	posts.forEach((item) => {
		addUniquePostToArr(uniqueData, item);
	});
	let psps = '';
	let pspsChanged = false;

	if (!!keyword.name || !!event.type) {
		uniqueData.forEach((item) => {
			if (item.event_keyword === 'public safety power shutoff') {
				psps = 'psps';
				pspsChanged = true;
			}
			if (
				(pspsChanged && event.type === psps) ||
				((event.type === item.event_keyword.toLowerCase() ||
					item.event_keyword.toLowerCase() === keyword.name) &&
					item.platform === SocialMediaChannel.TWITTER)
			) {
				twitterData.push(item);
			} else if (
				(pspsChanged && event.type === psps) ||
				((event.type === item.event_keyword.toLowerCase() ||
					item.event_keyword.toLowerCase() === keyword.name) &&
					item.platform === SocialMediaChannel.REDDIT)
			) {
				redditData.push(item);
			}
		});
	} else {
		uniqueData.forEach((item) => {
			if (item.platform === SocialMediaChannel.TWITTER) {
				twitterData.push(item);
			} else if (item.platform === SocialMediaChannel.REDDIT) {
				redditData.push(item);
			}
		});
	}

	const graphData = {
		labels: ['Twitter', 'Reddit'],
		datasets: [
			{
				data: [twitterData.length, redditData.length],
				backgroundColor: ['#4ACCD4', '#F39B30'],
			},
		],
	};

	const config = {
		type: 'doughnut',
		data: graphData,
		options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				title: {
					display: true,
					text: 'Social Platforms',
					color: 'white',
				},
				legend: {
					labels: {
						color: 'white',
					},
				},
				datalabels: {
					color: 'white',
					formatter: (value, ctx) => {
						let datasets = ctx.chart.data.datasets;
						if (datasets.indexOf(ctx.dataset) === datasets.length - 1) {
							let sum = datasets[0].data.reduce((a, b) => a + b, 0);
							let percentage = Math.round((value / sum) * 100) + '%';
							return percentage;
						}
					},
				},
				tooltip: {
					callbacks: {
						label: function (tooltipItem) {
							const metaData = [];
							let datasets = tooltipItem.dataset.data;
							let sum = datasets.reduce((a, b) => a + b, 0);
							let percentage = Math.round((tooltipItem.raw / sum) * 100);
							metaData.push(`${tooltipItem.label} ${percentage}%\n`);
							return metaData;
						},
					},
				},
			},
		},
	};

	const handleSocialSelectChange = (value: string) => {
		setChannel({ name: value });
	};

	return (
		<>
			<CardTitle title='Social Media Engagements' />
			<Card
				hoverable
				bordered={false}
				actions={[
					<Button type='link' onClick={() => setModal2Visible(true)}>
						<ArrowsAltOutlined />
						View More Details
					</Button>,
				]}
			>
				<GraphContainer>
					{twitterData.length > 0 || redditData.length > 0 ? (
						<Doughnut data={config.data} options={config.options} height={200} />
					) : (
						<Title style={{ color: 'white' }} level={4}>
							No social engagements in this category
						</Title>
					)}
				</GraphContainer>
			</Card>
			<Modal
				title={`Social Media Engagements Details (${moment().format(date.start)} to ${
					date.end
				})`}
				centered
				visible={modal2Visible}
				onOk={() => setModal2Visible(false)}
				onCancel={() => setModal2Visible(false)}
				width={'90%'}
			>
				<Space>
					<DateSelector />
					<Select
						showSearch
						style={{ width: 150 }}
						onChange={handleSocialSelectChange}
						defaultValue={channel.name}
					>
						<Option value='all'>All Socials</Option>
						<Option value='twitter'>Twitter</Option>
						<Option value='reddit'>Reddit</Option>
					</Select>
					<EventKeywordSelector />
				</Space>
				<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }}>
					<Col xs={24} xl={6}>
						<TopicCard />
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
		</>
	);
};

export default EngagementCard;
