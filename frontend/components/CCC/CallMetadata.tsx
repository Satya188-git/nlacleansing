import { Typography } from 'antd';
import moment from 'moment';
import React from 'react';
import { ICallLevel } from 'types/callLevelInfo';

const CallMetadata: React.FC<ICallLevel> = ({
	callID,
	segmentStartTime,
	segmentStopTime,
	participantPhoneNumber,
	callLengthSeconds,
	customerType,
	agentFullName,
}) => {
	const { Title, Text } = Typography;
	return (
		<>
			<Title level={5}>NICE Call ID: </Title>
			<Text>{callID}</Text>
			<Title level={5}>Call Start Timestamp: </Title>
			<Text>{segmentStartTime}</Text>
			<Title level={5}>Call End Timestamp: </Title>
			<Text>{segmentStopTime}</Text>
			<Title level={5}>Customer Phone Number (hidden): </Title>
			<Text>{participantPhoneNumber}</Text>
			<Title level={5}>Handle Time: </Title>
			<Text>{moment.utc(callLengthSeconds * 1000).format('HH:mm:ss')}</Text>
			<Title level={5}>Customer Type: </Title>
			<Text>{customerType}</Text>
			<Title level={5}>Agent Name: </Title>
			<Text>{agentFullName}</Text>
		</>
	);
};

export default CallMetadata;
