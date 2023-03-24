import { List } from 'antd';
import { filterTopPosts, sortTopPostData } from 'helpers/FilterDataUtil';
import { socialLogoSwitch } from 'helpers/LogoUtil';
import Image from 'next/image';
import React from 'react';
import styled from 'styled-components';
import CardTitle from './atoms/CardTitle';
import ListCard from './atoms/ListCard';
import PostDescription from './PostDescription';

interface ITopPostList {
	title: string;
	sentimentAnalysis: string;
}
const ContentTitle = styled.div`
	overflow: hidden;
`;

const ContentSource = styled.span`
	text-decoration: underline;
	font-weight: bold;
`;

const LogoContainer = styled.div`
	box-sizing: border-box;
	margin: 0;
	padding: 0;
	font-size: 12px;
	font-variant: tabular-nums;
	line-height: 1.66667;
	list-style: none;
	font-feature-settings: tnum, 'tnum';
	position: relative;
	display: inline-block;
	overflow: hidden;
	white-space: nowrap;
	text-align: center;
	vertical-align: middle;
	background: white;
	width: 28px;
	height: 28px;
	line-height: 28px;
	border-radius: 50%;
`;

const TopPostList: React.FC<ITopPostList> = ({ title, sentimentAnalysis }) => {
	const filteredUniqueData = filterTopPosts(sentimentAnalysis);
	sortTopPostData(filteredUniqueData);

	// switch (sentimentAnalysis) {
	// 	case Sentiment.POSITIVE:
	// 		setSentiment({
	// 			posCount: filteredUniqueData.length,
	// 			neuCount: neuCount,
	// 			negCount: negCount,
	// 		});
	// 		break;
	// 	case Sentiment.NEGATIVE:
	// 		setSentiment({
	// 			posCount: posCount,
	// 			neuCount: neuCount,
	// 			negCount: filteredUniqueData.length,
	// 		});
	// 		break;
	// 	default:
	// 		setSentiment({
	// 			posCount: posCount,
	// 			neuCount: filteredUniqueData.length,
	// 			negCount: negCount,
	// 		});
	// }
	// if (sentimentAnalysis === Sentiment.POSITIVE) {
	// 	setSentiment({ posCount: filteredUniqueData.length, neuCount, negCount });
	// }
	// if (sentimentAnalysis === Sentiment.NEUTRAL) {
	// 	setSentiment({ posCount, neuCount: filteredUniqueData.length, negCount });
	// }
	// if (sentimentAnalysis === Sentiment.NEGATIVE) {
	// 	setSentiment({ posCount, neuCount, negCount: filteredUniqueData.length });
	// }

	return (
		<>
			<CardTitle title={title} />
			<ListCard hoverable bordered={false} id={`top${sentimentAnalysis}PostsScrollableDiv`}>
				<List
					dataSource={filteredUniqueData}
					renderItem={(item, i) => {
						return (
							<List.Item key={`${i}${item.url}`}>
								<List.Item.Meta
									avatar={
										<LogoContainer>
											<Image
												src={socialLogoSwitch(item.platform)}
												width={28}
												height={28}
											/>
										</LogoContainer>
									}
									title={
										<a href={item.url} target='_blank'>
											<ContentTitle>{item.text}</ContentTitle>
										</a>
									}
									description={
										<>
											<ContentSource>
												<a href={item.url} target='_blank'>
													{item.platform.toUpperCase()}
												</a>
											</ContentSource>{' '}
											<PostDescription {...item} />
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

export default TopPostList;
