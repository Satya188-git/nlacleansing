import { List } from 'antd';
import { filterFAQs, sortFAQData } from 'helpers/FilterDataUtil';
import React from 'react';
import styled from 'styled-components';
import CardTitle from './atoms/CardTitle';
import ListCard from './atoms/ListCard';
import PostDescription from './PostDescription';

const ContentTitle = styled.div`
	overflow: hidden;
`;

const ContentSource = styled.span`
	text-decoration: underline;
	font-weight: bold;
`;

const FAQCard: React.FC = () => {
	const uniqueFAQs = filterFAQs();
	sortFAQData(uniqueFAQs);

	return (
		<>
			<CardTitle title='Community FAQs' />
			<ListCard hoverable bordered={false} id='FAQsScrollableDiv'>
				<List
					dataSource={uniqueFAQs}
					renderItem={(item, i) => {
						return (
							<List.Item key={`${i}${item.url}`}>
								<List.Item.Meta
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

export default FAQCard;
