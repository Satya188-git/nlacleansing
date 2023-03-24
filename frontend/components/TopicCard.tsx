import { List } from 'antd';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { numFormatter } from 'helpers/NumberUtil';
import Link from 'next/link';
import { useState } from 'react';
import styled from 'styled-components';
import { ITopic } from 'types';
import { Theme } from '../constants/theme';
import { useSLDataContext } from '../context/SLDataContext';
import CardTitle from './atoms/CardTitle';
import ListCard from './atoms/ListCard';

const TopicTitle = styled.p`
	margin-bottom: 0.5em;
	color: ${Theme.ACCENT};
	font-weight: 600;
	font-size: 21px;
	line-height: 1.35;
`;

const TopicCard: React.FC = () => {
	const {
		data: { keywords_and_topics },
	} = useSLDataContext();
	const { keyword } = useEventKeywordContext();
	const [topicData, setTopicData] = useState<ITopic[]>(keywords_and_topics);
	topicData.sort((a, b) => Number(b.metrics[1].metric_count) - Number(a.metrics[1].metric_count));

	return (
		<>
			<CardTitle title='Event Keywords' />
			<ListCard hoverable bordered={false} id='topicScrollableDiv'>
				<List
					dataSource={
						!!keyword.name
							? topicData.filter(
									(item) => item.keyword_name.toLowerCase() === keyword.name
							  )
							: topicData
					}
					renderItem={(item, i) => {
						return (
							<List.Item key={`${i}${item.keyword_name}`}>
								<List.Item.Meta
									title={
										<TopicTitle>
											<Link href={`/topic/${item.keyword_name}`}>
												<a>{item.keyword_name}</a>
											</Link>
										</TopicTitle>
									}
									description={`Mentions ${numFormatter(
										item.metrics[0].metric_count,
										1
									)} | Outreach ${numFormatter(item.metrics[1].metric_count, 1)}`}
								/>
							</List.Item>
						);
					}}
				/>
			</ListCard>
		</>
	);
};

export default TopicCard;
