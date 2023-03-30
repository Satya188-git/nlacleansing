import { Typography } from 'antd';
import moment from 'moment';
import React from 'react';
import { useSelector } from 'react-redux';

const CallMetadata = () => {
	const { Title, Text } = Typography;
	const selectedCallLevelData = useSelector((state: any) => state.ccc.selectedCallLevelData);
	return (
		<>
			<Title level={5}>NICE Call ID: </Title>
			<Text>{selectedCallLevelData?.callID}</Text>
			<Title level={5}>Call Start Timestamp: </Title>
			<Text>{selectedCallLevelData?.segmentStartTime}</Text>
			<Title level={5}>Call End Timestamp: </Title>
			<Text>{selectedCallLevelData?.segmentStopTime}</Text>
			<Title level={5}>Customer Phone Number (hidden): </Title>
			<Text>{selectedCallLevelData?.participantPhoneNumber}</Text>
			<Title level={5}>Handle Time: </Title>
			<Text>{moment.utc(selectedCallLevelData?.callLengthSeconds * 1000).format('HH:mm:ss')}</Text>
			<Title level={5}>Customer Type: </Title>
			<Text>{selectedCallLevelData?.customerType}</Text>
			<Title level={5}>Agent Name: </Title>
			<Text>{selectedCallLevelData?.agentFullName}</Text>
		</>
	);
};

export default CallMetadata;
