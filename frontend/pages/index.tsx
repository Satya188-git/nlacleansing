import { DownloadOutlined } from '@ant-design/icons';
import { Button, Col, Divider, Row, Space, Spin, Typography } from 'antd';
import { Route } from 'constants/routes';
import AuthenticatorContext from 'context/AuthenticatorContext';
import { useDateContext } from 'context/DateContext';
import { usePartnerContext } from 'context/PartnerContext';
import { useRouter } from 'next/router';
import { useContext, useEffect, useRef, useState } from 'react';
import { useReactToPrint } from 'react-to-print';
import {
	DateSelector,
	EngagementCard,
	EventKeywordSelector,
	EventTypeSelector,
	FAQCard,
	LocalMediaCard,
	SelectPartner,
	SentimentAnalysisGraph,
	WeatherGraph,
} from '../components';
import { useSLDataContext } from '../context/SLDataContext';

const Home: React.FC = () => {
	const [loading, setLoading] = useState(true);
	const router = useRouter();
	const { user } = useContext(AuthenticatorContext);
	useEffect(() => {
		if (!user) {
			router.push(Route.SIGNIN);
			return;
		} else {
			setLoading(false);
		}
	}, [user]);
	const { data } = useSLDataContext();
	const { date } = useDateContext();
	const { partner } = usePartnerContext();
	const componentRef = useRef();
	const { Title } = Typography;
	const handlePrint = useReactToPrint({
		content: () => componentRef.current,
		documentTitle: `${partner.name.toUpperCase()} Social Listening Report (${date.start} to ${
			date.end
		})`,
		onAfterPrint: () => console.log('Print Success'),
	});

	return (
		<>
			{loading || !data ? (
				<Spin size='large' />
			) : (
				<div ref={componentRef}>
					<SelectPartner />
					<Title>Emergency Operations &amp; Outreach Dashboard</Title>
					<Space>
						<DateSelector />
						<EventTypeSelector />
						<EventKeywordSelector />
						<Button
							onClick={handlePrint}
							type='primary'
							shape='round'
							icon={<DownloadOutlined />}
							size='middle'
						>
							Export PDF
						</Button>
					</Space>
					<Divider />
					<SentimentAnalysisGraph />
					<Divider />
					<WeatherGraph />
					<Divider />

					<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }}>
						<Col xs={24} xl={8}>
							<FAQCard />
						</Col>
						<Col xs={24} xl={8}>
							<EngagementCard />
						</Col>
						<Col xs={24} xl={8}>
							<LocalMediaCard />
						</Col>
					</Row>
					<Divider />
				</div>
			)}
		</>
	);
};

export default Home;
