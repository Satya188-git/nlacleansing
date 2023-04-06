import { Row, Space, Tag, Typography } from 'antd';
import React from 'react';
import { useSelector } from 'react-redux';
import styled from 'styled-components';

const CallSummaryContainer = styled.div`
	word-wrap: break-word;
`;

const SelectedCallSummary: React.FC = () => {
	const { Title, Text } = Typography;
	const selectedCallLevelData = useSelector((state: any) => state.ccc.selectedCallLevelData);

	return (
		<>
			<CallSummaryContainer>
				<Text>{selectedCallLevelData?.callSummary}</Text>
			</CallSummaryContainer>
			{selectedCallLevelData?.callEndingSentimentLabel && (
				<Row style={{ marginTop: '10px' }} className="end-sentiment">
					<Space align='baseline'>
						<Title level={5}>
							<u>Ending Sentiment</u>:{' '}
						</Title>
						{selectedCallLevelData?.callEndingSentimentLabel === 'POSITIVE' && (
							<Tag color='green'>{selectedCallLevelData?.callEndingSentimentLabel}</Tag>
						)}
						{selectedCallLevelData?.callEndingSentimentLabel === 'NEUTRAL' && (
							<Tag color='yellow'>{selectedCallLevelData?.callEndingSentimentLabel}</Tag>
						)}
						{selectedCallLevelData?.callEndingSentimentLabel === 'NEGATIVE' && (
							<Tag color='red'>{selectedCallLevelData?.callEndingSentimentLabel}</Tag>
						)}
					</Space>
				</Row>
			)}
		</>
	);
};

export default SelectedCallSummary;
