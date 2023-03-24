import Image from 'next/image';
import React from 'react';
import { IEvent } from 'types';

const EventCategoryMetaData: React.FC<IEvent> = ({
	event_lat_long,
	event_start_date,
	event_end_date,
	event_metrics,
}) => {
	return (
		<>
			<Image src={'/calendar.svg'} width={15} height={15} /> {event_start_date} -{' '}
			{event_end_date}
			<br />
			<b>{`LatLng - ${event_lat_long}`}</b>
			<br />
			{!!event_metrics[0] && !!event_metrics[0].event_metric_value && (
				<>
					<b>Event Metrics:</b>
					<br />
					{event_metrics.map((i, count) => {
						return (
							<div key={`${count}${i.event_metric_name}`}>
								{i.event_metric_name} - {i.event_metric_value}
								<br />
							</div>
						);
					})}
				</>
			)}
		</>
	);
};

export default EventCategoryMetaData;
