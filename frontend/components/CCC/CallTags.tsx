import { Row, Tag } from 'antd';
import { Theme } from 'constants/theme';
import React from 'react';
import styled from 'styled-components';
import { ICallInsight } from 'types/callInsight';

const TagContainer = styled.div`
	margin-top: 10px;
`;

const CallTags: React.FC<ICallInsight> = ({ callTagLabels }) => {
	return (
		<>
			<Row className='call-tags'>
				{callTagLabels?.split(",")?.map((item, i) => {
					return (
						<TagContainer key={`${i}${item}`}>
							{!!item ? (
								i < callTagLabels?.split(",")?.length - 1 ? (
									<>
										<Tag color={Theme.TAG}>{item}</Tag>
									</>
								) : (
									<>
										<Tag color={Theme.TAG}>{item}</Tag>
									</>
								)
							) : (
								<></>
							)}
						</TagContainer>
					);
				})}
			</Row>
		</>
	);
};

export default CallTags;
