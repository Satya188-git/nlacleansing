import { Row, Space, Tag, Typography } from 'antd';
import { useCallSelectDataContext } from 'context/CallSelectContext';
import React from 'react';
import styled from 'styled-components';
import { ICallInsight } from 'types/callInsight';

const CallSummaryContainer = styled.div`
	word-wrap: break-word;
`;

const CallSummary: React.FC<ICallInsight> = ({ callEndingSentimentLabel, callSummary }) => {
	const { Title, Text } = Typography;

	return (
		<>
			<CallSummaryContainer>
				<Text>{callSummary}</Text>
			</CallSummaryContainer>
			{callEndingSentimentLabel && (
				<Row style={{ marginTop: '10px' }} className="end-sentiment">
					<Space align='baseline'>
						<Title level={5}>
							<u>Ending Sentiment</u>:{' '}
						</Title>
						{callEndingSentimentLabel === 'POSITIVE' && (
							<Tag color='green'>{callEndingSentimentLabel}</Tag>
						)}
						{callEndingSentimentLabel === 'NEUTRAL' && (
							<Tag color='yellow'>{callEndingSentimentLabel}</Tag>
						)}
						{callEndingSentimentLabel === 'NEGATIVE' && (
							<Tag color='red'>{callEndingSentimentLabel}</Tag>
						)}
					</Space>
				</Row>
			)}
		</>
	);
};

export default CallSummary;
