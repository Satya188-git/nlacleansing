import { DownloadOutlined } from '@ant-design/icons-svg';
import { Button } from 'antd';
import React from 'react';
import { PDFDownloadLink } from '@react-pdf/renderer';
import { useDateContext } from 'context/DateContext';
import SDGEPDFReport from './SDGEPDFReport';
import SCGPDFReport from './SCGPDFReport';
import { usePartnerContext } from 'context/PartnerContext';
import { Partner } from 'constants/partner';

const ExportPDFButton: React.FC = () => {
	const { date } = useDateContext();
	const { partner } = usePartnerContext();
	return (
		<PDFDownloadLink
			document={partner.name === Partner.SCG ? <SCGPDFReport /> : <SDGEPDFReport />}
			fileName={`${partner.name.toUpperCase()} Social Listening Report (${date.start} to ${
				date.end
			})`}
		>
			<Button type='primary' shape='round' size='middle'>
			Export PDF
			</Button>
		</PDFDownloadLink>
	);
};

export default ExportPDFButton;
