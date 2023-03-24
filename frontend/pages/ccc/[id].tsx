import { LeftOutlined } from '@ant-design/icons';
import { Button, Col, Divider, Row, Spin, Typography } from 'antd';
import {
	CallMetadata,
	CallSegmentGraph,
	CallSentimentAnalysisGraph,
	CallSummary,
	CallTags,
	CallTranscript,
	CardTitle,
	ListCard,
	SelectedCallSummary,
	SelectedCallTags,
} from 'components';
import { useCallSelectDataContext } from 'context/CallSelectContext';
import { useRouter } from 'next/router';
import { useEffect, useState } from 'react';
import styled from 'styled-components';
import axios from 'axios';
import { ICallLevel } from 'types/callLevelInfo';

const CallSummaryContainer = styled.div`
	padding: 0 10px;
`;

const TitleContainer = styled.div`
	margin-left: 16px;
`;

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
	margin-top: 16px;
	margin-left: 16px;
`;

const CallID: React.FC = () => {
	const {
		query: { id },
	} = useRouter();
	const router = useRouter();
	const {
		setCallSelectData,
		callSelectData: { selectedCallLevelData },
	} = useCallSelectDataContext();
	console.log(id)
	const { Title } = Typography;
	const [loading, setLoading] = useState(false);

	useEffect(() => {
		if (id) {
			setLoading(true);
			const urlCallLevelInfo = `${process.env.NEXT_PUBLIC_CCC_API_GATEWAY}/call-details?callid=${id}`;
			axios.get(urlCallLevelInfo)
				.then((response) => {
					const callLevelData = response.data as ICallLevel;
					if (!callLevelData) {
						router.push('/error');
					} else {
						setCallSelectData((prev) => ({
							...prev,
							selectedCallLevelData: callLevelData,
						}));
					}
				})
				.catch((error) => {
					console.error(error);
					router.push('/error');
				})
				.finally(() => {
					setLoading(false);
				})
		}
	}, [id]);

	return (
		<>
			<Row>
				<Button shape='circle' icon={<LeftOutlined />} onClick={router.back} />
				<TitleContainer>
					<Title level={4}>Call Details</Title>
				</TitleContainer>
			</Row>
			<Divider />
			{loading ?
				<CenterContainer>
					<Spin tip='Loading' />
				</CenterContainer > : <>
					<Row gutter={[16, 24]}>
						<Col xs={24} sm={12} lg={6}>
							<CardTitle title='Summary' />
							<ListCard hoverable bordered={false}>
								<CallSummaryContainer>
									<SelectedCallSummary />
								</CallSummaryContainer>
							</ListCard>
						</Col>
						<Col xs={24} sm={12} lg={6}>
							<CardTitle title='Segment Share' />
							<ListCard hoverable bordered={false}>
								<CallSegmentGraph />
							</ListCard>
						</Col>
						<Col xs={24} sm={12} lg={6}>
							<CardTitle title='Call Tags' />
							<ListCard hoverable bordered={false}>
								<SelectedCallTags />
							</ListCard>
						</Col>
						<Col xs={24} sm={12} lg={6}>
							<CardTitle title='Call Data' />
							<ListCard hoverable bordered={false}>
								<CallMetadata {...selectedCallLevelData} />
							</ListCard>
						</Col>
					</Row>
					<Divider />
					<Row gutter={[16, 24]}>
						<Col xs={24} sm={12}>
							<CallSentimentAnalysisGraph />
						</Col>
						<Col xs={24} sm={12}>
							<CallTranscript />
						</Col>
					</Row>
					<Divider />
				</>
			}
		</>
	);
};

export default CallID;
