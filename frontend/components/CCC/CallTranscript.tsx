import { List, Row, Space, Tag, Typography } from 'antd';
import CardTitle from 'components/atoms/CardTitle';
import ListCard from 'components/atoms/ListCard';
import { Theme } from 'constants/theme';
import { useCallSelectDataContext } from 'context/CallSelectContext';
import { useCallTimelineSelectDataContext } from 'context/CallTimelineSelectContext';
import moment from 'moment';
import React, { useEffect, useRef } from 'react';

const CallTranscript: React.FC = () => {
	const {
		callSelectData: { selectedCallLevelData },
	} = useCallSelectDataContext();
	const { callTimelineSelectData } = useCallTimelineSelectDataContext();
	const scrollRef = useRef();
	const { Title, Text } = Typography;

	useEffect(() => {
		if (!!callTimelineSelectData && callTimelineSelectData.length > 0) {
			scrollRef[
				selectedCallLevelData.transcripts?.[callTimelineSelectData[0].index]?.lineId
			].scrollIntoView({
				behavior: 'smooth',
				block: 'start',
			});
		}
	}, [callTimelineSelectData]);

	return (
		(!selectedCallLevelData.transcripts || selectedCallLevelData.transcripts.length === 0) ? <></>
			: <>
				<CardTitle title='Call Transcript' />
				<ListCard hoverable bordered={false} id='CallTranscriptScrollableDiv'>
					<List
						dataSource={selectedCallLevelData.transcripts}
						renderItem={(item, i) => {
							if (!item.participantRole) return;
							// const foundTagInLineID = selectedCallInsightData.callTagLabels.find((tag) => {
							// 	if (!!tag.appearsInLineID) {
							// 		return tag.appearsInLineID.find((id) => id === item.lineId);
							// 	}
							// });
							return (
								<List.Item
									key={`${item.lineId}`}
									ref={(el) => (scrollRef[item.lineId] = el)}
								>
									<List.Item.Meta
										title={
											<Row className="end-sentiment">
												<Space align='baseline'>
													<Title level={5}>
														{item.participantRole} (
														{moment
															.utc(item.beginOffsetMillis)
															.format('mm:ss')}{' '}
														-{' '}
														{moment
															.utc(item.endOffsetMillis)
															.format('mm:ss')}
														)
													</Title>
													{item.sentiment === 'POSITIVE' && (
														<Tag color='green'>{item.sentiment}</Tag>
													)}
													{item.sentiment === 'NEUTRAL' && (
														<Tag color='yellow'>{item.sentiment}</Tag>
													)}
													{item.sentiment === 'NEGATIVE' && (
														<Tag color='red'>{item.sentiment}</Tag>
													)}
													{/* {foundTagInLineID && (
													<Tag color={Theme.TAG}>
														{foundTagInLineID.tagLabel}
													</Tag>
												)} */}
												</Space>
											</Row>
										}
										description={
											<>
												<Text>{item.content}</Text>
											</>
										}
									/>
								</List.Item>
							);
						}}
					/>
				</ListCard>
			</>
	);
};

export default CallTranscript;
