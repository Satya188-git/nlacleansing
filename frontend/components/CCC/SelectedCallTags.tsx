import { Row, Tag } from 'antd';
import { Theme } from 'constants/theme';
import React from 'react';
import { useSelector } from 'react-redux';
import styled from 'styled-components';

const TagContainer = styled.div`
	margin-top: 10px;
`;

const SelectedCallTags: React.FC = () => {
	const selectedCallLevelData = useSelector((state: any) => state.ccc.selectedCallLevelData);

	return (
		<>
			<Row className='call-tags'>
				{selectedCallLevelData?.callTagLabels?.split(",")?.map((item, i) => {
					return (
						<TagContainer key={`${i}${item}`}>
							{!!item ? (
								i < selectedCallLevelData?.callTagLabels?.split(",")?.length - 1 ? (
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

export default SelectedCallTags;
