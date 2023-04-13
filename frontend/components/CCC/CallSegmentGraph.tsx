import { capitalize } from 'helpers/StringUtil';
import moment from 'moment';
import React from 'react';
import { Doughnut } from 'react-chartjs-2';
import { useSelector } from 'react-redux';
import styled from 'styled-components';
import DateUtil from '../../helpers/DateUtil';

const GraphContainer = styled.div`
	padding: 1.5rem;
	min-height: 100px;
`;

const CallSegmentGraph: React.FC = () => {
	const selectedCallLevelData = useSelector((state: any) => state.ccc.selectedCallLevelData);
	const graphData = {
		labels: selectedCallLevelData?.callsegments?.map(
			(item) =>
				capitalize(item.segmentName) +
				' (' +
				moment.utc(parseInt(item.durationSeconds.toString()) * 1000).format('HH:mm:ss') +
				')'
		),
		datasets: [
			{
				data: selectedCallLevelData?.callsegments?.map((item) => item.durationSeconds),
				backgroundColor: selectedCallLevelData?.callsegments?.map((_, i) =>
					DateUtil.namedColor(i)
				),
				borderWidth: 0,
			},
		],
	};

	const config = {
		type: 'Doughnut',
		data: graphData,
		options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				datalabels: {
					display: false,
				},
				legend: {
					position: 'bottom' as const,
					labels: {
						color: 'white',
						usePointStyle: true,
						boxWidth: 10,
					},
				},
			},
		},
	};

	return (
		<>
			<GraphContainer>
				<Doughnut data={config.data} options={config.options} height={300} />
			</GraphContainer>
		</>
	);
};

export default CallSegmentGraph;
