import { Typography } from 'antd';
import { CardTitle, ListCard } from 'components/atoms';
import { useCallSelectDataContext } from 'context/CallSelectContext';
import { useCallTimelineSelectDataContext } from 'context/CallTimelineSelectContext';
import moment from 'moment';
import React, { useRef } from 'react';
import { getElementAtEvent, Line } from 'react-chartjs-2';
import styled from 'styled-components';
import { ICallLevelTranscript } from 'types/callLevelInfo';

const GraphContainer = styled.div`
	min-height: 300px;
	max-height: 750px;
`;

const CallSentimentAnalysisGraph: React.FC = () => {
	const {
		callSelectData: { selectedCallLevelData },
	} = useCallSelectDataContext();
	const { setCallTimelineSelectData } = useCallTimelineSelectDataContext();
	const chartRef = useRef();
	const { Title } = Typography;
	if (!selectedCallLevelData.transcripts || selectedCallLevelData.transcripts.length === 0)
		return <Title level={5}>No Transcript Data.</Title>;
	const checkSentiment = (item: ICallLevelTranscript) => {
		if (item.sentiment === 'POSITIVE') return 1;
		if (item.sentiment === 'NEUTRAL' || item.sentiment === 'MIXED') return 0;
		if (item.sentiment === 'NEGATIVE') return -1;
	};
	const graphData = {
		labels: selectedCallLevelData.transcripts.map((item) =>
			moment.utc(item.beginOffsetMillis).format('mm:ss')
		),
		datasets: [
			{
				label: 'AGENT',
				data: selectedCallLevelData.transcripts.map((item) => {
					if (item.participantRole != 'AGENT' || !item.sentiment) return;
					if (item.sentiment === 'POSITIVE') return 1;
					if (item.sentiment === 'NEUTRAL' || item.sentiment === 'MIXED') return 0;
					if (item.sentiment === 'NEGATIVE') return -1;
				}),
				backgroundColor: '#0193D5',
				borderColor: '#0193D5',
				pointStyle: 'rect',
				pointRadius: 5,
			},
			{
				label: 'CUSTOMER',
				data: selectedCallLevelData.transcripts.map((item) => {
					if (item.participantRole != 'CUSTOMER' || !item.sentiment) return;
					if (item.sentiment === 'POSITIVE') return 1;
					if (item.sentiment === 'NEUTRAL' || item.sentiment === 'MIXED') return 0;
					if (item.sentiment === 'NEGATIVE') return -1;
				}),
				backgroundColor: '#FFE600',
				borderColor: '#FFE600',
				pointStyle: 'rect',
				pointRadius: 5,
			},
			{
				label: 'BOTH',
				data: selectedCallLevelData.transcripts.map((item) => {
					if (item.participantRole != 'BOTH' || !item.sentiment) return;
					if (item.sentiment === 'POSITIVE') return 1;
					if (item.sentiment === 'NEUTRAL' || item.sentiment === 'MIXED') return 0;
					if (item.sentiment === 'NEGATIVE') return -1;
				}),
				backgroundColor: '#23B42F',
				borderColor: '#23B42F',
				pointStyle: 'rect',
				pointRadius: 5,
			},
		],
	};
console.log(graphData)
	const legendMargin = {
		beforeInit(chart) {
			// Get reference to the original fit function
			const originalFit = chart.legend.fit;

			// Override the fit function
			chart.legend.fit = function fit() {
				// Call original function and bind scope in order to use `this` correctly inside it
				originalFit.bind(chart.legend)();
				// Change the height as suggested in another answers
				this.height += 15;
			};
		},
		// id: 'legendMargin',
		// beforeInit(chart, legend, options) {
		// 	const fitValue = chart.legend.fit;
		// 	chart.legend.fit = function fit() {
		// 		fitValue.bind(chart.legend)();
		// 		return (this.height += 50);
		// 	};
		// },
	};
	const config = {
		type: 'line',
		data: graphData,
		legend: {
			maxHeight: 20,
		},
		plugins: [
			{
				beforeInit: (chart, options) => {
					chart.legend.afterFit = () => {
						if (chart.legend.margins) {
							// Put some padding around the legend/labels
							chart.legend.options.labels.padding = 20;
							// Because you added 20px of padding around the whole legend,
							// you will need to increase the height of the chart to fit it
							chart.height += 40;
						}
					};
				},
			},
		],
		options: {
			responsive: true,
			maintainAspectRatio: false,
			interaction: {
				intersect: false,
			},
			plugins: {
				legend: {
					position: 'bottom' as const,
					labels: {
						color: 'white',
						padding: 20,
						usePointStyle: true,
						pointStyle: 'circle',
						boxWidth: 10,
					},
					maxHeight: 50,
				},
				datalabels: {
					display: false,
				},
			},
			scales: {
				yAxes: {
					display: true,
					beginAtZero: false,
					grid: {
						color: '#fff',
						borderDash: [4, 4],
					},
					ticks: {
						color: 'white',
						min: -1,
						max: 1,
						stepSize: 1,
						suggestedMin: -1,
						suggestedMax: 1,
						callback: function (value, index) {
							switch (value) {
								case 0:
									return 'NEUTRAL/MIXED';
								case -1:
									return 'NEGATIVE';
								case 1:
									return 'POSITIVE';
							}
						},
					},
				},
				xAxes: {
					ticks: {
						color: 'white',
					},
				},
			},
		},
	};

	return (
		<>
			<CardTitle title='Call Sentiment Timeline' />
			<ListCard hoverable bordered={false} className="call-sentiment-sec">
				<GraphContainer>
					<Line
						ref={chartRef}
						onClick={(event) => {
							setCallTimelineSelectData(getElementAtEvent(chartRef.current, event));
						}}
						data={config.data}
						options={config.options}
						height={300}
					/>
				</GraphContainer>
			</ListCard>
		</>
	);
};

export default CallSentimentAnalysisGraph;
