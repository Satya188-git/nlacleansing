import { List, Skeleton } from 'antd';
import { newsLogoSwitch } from 'helpers/LogoUtil';
import Image from 'next/image';
import React, { useEffect, useState } from 'react';
import InfiniteScroll from 'react-infinite-scroll-component';
import styled from 'styled-components';
import { useSLDataContext } from '../context/SLDataContext';
import { useDateContext } from '../context/DateContext';
import { IMedia } from '../types';
import CardTitle from './atoms/CardTitle';
import ListCard from './atoms/ListCard';

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

const LocalMediaCard: React.FC = () => {
	const { date } = useDateContext();
	const {
		data: { local_media_coverage },
	} = useSLDataContext();
	const [count, setCount] = useState(0);
	const [mediaData, setMediaData] = useState<IMedia[]>([]);
	const [isLoading, setIsLoading] = useState(false);
	const [hasMore, setHasMore] = useState(true);

	const filteredOriginalData: IMedia[] = local_media_coverage.filter((media) => {
		return media.posting_date >= date.start && media.posting_date <= date.end;
	});

	const loadMoreData = () => {
		if (isLoading) {
			return;
		}

		if (count >= filteredOriginalData.length) {
			setHasMore(false);
			setIsLoading(false);
			return;
		}

		setIsLoading(true);
		setMediaData([...mediaData, ...filteredOriginalData.slice(count, count + 6)]);
		setCount(count + 6);
		setIsLoading(false);
	};

	useEffect(() => {
		loadMoreData();
	}, [count]);

	return (
		<>
			<CardTitle title='Local Media Coverage' />
			<ListCard hoverable bordered={false} id='localMediaScrollableDiv'>
				<InfiniteScroll
					dataLength={filteredOriginalData.length}
					next={loadMoreData}
					hasMore={hasMore}
					loader={isLoading ?? <Skeleton avatar paragraph={{ rows: 1 }} active />}
					scrollableTarget='localMediaScrollableDiv'
				>
					<List
						dataSource={filteredOriginalData}
						renderItem={(item, i) => {
							return (
								<List.Item key={`${i}${item.content_url}`}>
									<List.Item.Meta
										avatar={
											<LogoContainer>
												<Image
													src={newsLogoSwitch(item.content_source)}
													width={28}
													height={28}
												/>
											</LogoContainer>
										}
										title={
											<a href={item.content_url} target='_blank'>
												<ContentTitle>{item.content_title}</ContentTitle>
											</a>
										}
										description={
											<>
												<ContentSource>
													<a href={item.content_url} target='_blank'>
														{item.content_source}
													</a>
												</ContentSource>{' '}
												({item.posting_date})
											</>
										}
									/>
								</List.Item>
							);
						}}
					/>
				</InfiniteScroll>
			</ListCard>
		</>
	);
};

export default LocalMediaCard;
