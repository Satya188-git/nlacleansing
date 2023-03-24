import { useCallSelectDataContext } from 'context/CallSelectContext';
import { capitalize } from 'helpers/StringUtil';
import moment from 'moment';
import React from 'react';
import { Pie } from 'react-chartjs-2';
import styled from 'styled-components';
import { ICallInsight, ICallSegment } from 'types/callInsight';
import DateUtil from '../../helpers/DateUtil';

const GraphContainer = styled.div`
	padding: 1.5rem;
	min-height: 100px;
`;

const CallSegmentGraph: React.FC = () => {
	const {
		callSelectData: { selectedCallLevelData },
	} = useCallSelectDataContext();
	const graphData = {
		labels: selectedCallLevelData.callsegments?.map(
			(item) =>
				capitalize(item.segmentName) +
				' (' +
				moment.utc(parseInt(item.durationSeconds.toString()) * 1000).format('HH:mm:ss') +
				')'
		),
		datasets: [
			{
				data: selectedCallLevelData.callsegments?.map((item) => item.durationSeconds),
				backgroundColor: selectedCallLevelData.callsegments?.map((_, i) =>
					DateUtil.namedColor(i)
				),
			},
		],
	};

	const config = {
		type: 'pie',
		data: graphData,
		options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				datalabels: {
					display: false,
				},
				legend: {
					labels: {
						color: 'white',
					},
				},
			},
		},
	};

	return (
		<>
			<GraphContainer>
				<Pie data={config.data} options={config.options} height={300} />
			</GraphContainer>
		</>
	);
};

export default CallSegmentGraph;
