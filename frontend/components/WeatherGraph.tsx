import { useSLDataContext } from 'context/SLDataContext';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { useEventTypeContext } from 'context/EventTypeContext';
import React from 'react';
import { Line } from 'react-chartjs-2';
import styled from 'styled-components';
import { useDateContext } from '../context/DateContext';
import { IEvent, ITimeline } from '../types';

const GraphContainer = styled.div`
	min-height: 300px;
	max-height: 750px;
`;

const filterDataByDateRange = (data: Array<ITimeline>) => {
	const { date } = useDateContext();
	const filteredData = Array<ITimeline>();

	for (const i in data) {
		if (data[i].datestamp >= date.start && data[i].datestamp <= date.end) {
			filteredData.push(data[i]);
		}
	}

	return filteredData;
};

const WeatherGraph: React.FC = () => {
	const {
		data: { timeline, posts },
	} = useSLDataContext();
	const { date } = useDateContext();
	const { keyword } = useEventKeywordContext();
	const { event } = useEventTypeContext();

	const filteredData = Array<ITimeline>();
	let events = Array<IEvent>();

	if (!!event.type) {
		if (!!keyword.name) {
			const arr = posts.filter((item) => {
				return (
					item.date >= date.start &&
					item.date <= date.end &&
					item.event_keyword === keyword.name
				);
			});
			timeline.forEach((item) => {
				if (item.datestamp >= date.start && item.datestamp <= date.end) {
					var index = arr.findIndex((arr) => arr.date === item.datestamp);
					if (index !== -1) {
						events = [];
						item.events.forEach((i) => {
							if (i.event_type.toLowerCase() === event.type) {
								events.push(i);
							}
						});
						filteredData.push({
							datestamp: item.datestamp,
							metrics: item.metrics,
							events: events,
							weather: item.weather,
						});
					}
				}
			});
		} else {
			timeline.forEach((item) => {
				if (item.datestamp >= date.start && item.datestamp <= date.end) {
					events = item.events.filter((i) => i.event_type.toLowerCase() === event.type);
					if (events.length > 0) {
						filteredData.push({
							datestamp: item.datestamp,
							metrics: item.metrics,
							events: events,
							weather: item.weather,
						});
					}
				}
			});
		}
	} else {
		timeline.forEach((item) => {
			if (item.datestamp >= date.start && item.datestamp <= date.end) {
				filteredData.push(item);
			}
		});
	}

	const graphData = {
		labels: filteredData.map((i) => i.datestamp),
		datasets: [
			{
				label: 'Highest Temperature',
				data: filteredData.map((i) => parseInt(i.weather.max_temp)),
				backgroundColor: 'red',
				borderColor: 'red',
			},
			{
				label: 'Lowest Temperature',
				data: filteredData.map((i) => parseInt(i.weather.min_temp)),
				backgroundColor: 'blue',
				borderColor: 'blue',
			},
		],
	};

	const config = {
		type: 'line',
		data: graphData,
		options: {
			responsive: true,
			maintainAspectRatio: false,
			interaction: {
				intersect: false,
			},
			plugins: {
				title: {
					display: true,
					text: 'Weather Graph',
					color: 'white',
				},
				legend: {
					labels: {
						color: 'white',
					},
				},
				datalabels: {
					display: false,
				},
			},
		},
	};

	return (
		<>
			<GraphContainer>
				<Line data={config.data} options={config.options} height={300} />
			</GraphContainer>
		</>
	);
};

export default WeatherGraph;
