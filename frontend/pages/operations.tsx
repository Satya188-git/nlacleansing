import { Button, Divider, Row, Space, Typography } from 'antd';
import { DownloadOutlined } from '@ant-design/icons';
import {
	DateSelector,
	EventTypeSelector,
	ExportPDFButton,
	OperationEvents,
	SelectPartner,
} from '../components';
import { useRef } from 'react';
import { useReactToPrint } from 'react-to-print';
import { useDateContext } from 'context/DateContext';
import { usePartnerContext } from 'context/PartnerContext';

const Operations = () => {
	const componentRef = useRef();
	const { date } = useDateContext();
	const { partner } = usePartnerContext();
	const handlePrint = useReactToPrint({
		content: () => componentRef.current,
		documentTitle: `${partner.name.toUpperCase()} Social Listening Report (${date.start} to ${
			date.end
		})`,
		onAfterPrint: () => console.log('Print Success'),
	});
	const { Title } = Typography;

	return (
		<div ref={componentRef}>
			<SelectPartner />
			<Title>Event Category Dashboard</Title>
			<Space>
				<DateSelector />
				<EventTypeSelector />
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
			<Row gutter={{ xs: 8, sm: 16, md: 24, lg: 32 }}>
				<OperationEvents />
			</Row>
			<Divider />
		</div>
	);
};

export default Operations;
