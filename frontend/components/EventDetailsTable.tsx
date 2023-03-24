import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useDateContext } from 'context/DateContext';
import { capitalize } from 'helpers/StringUtil';
import moment from 'moment';
import React from 'react';
import { ITimeline } from 'types';

interface IEventTable {
	type: string;
	name: string;
	location: string;
	start: string;
	end: string;
}
const EventDetailsTable: React.FC<ITimeline> = ({ datestamp, metrics, events, weather }) => {
	const { Title } = Typography;
	const { date } = useDateContext();
	const DATE_FORMAT = 'YYYY-MM-DD';
	const columns: ColumnsType<IEventTable> = [
		{
			title: 'Type',
			dataIndex: 'type',
			key: 'type',
		},
		{
			title: 'Name',
			dataIndex: 'name',
			key: 'name',
		},
		{
			title: 'Location',
			dataIndex: 'location',
			key: 'location',
		},
		{
			title: 'Start',
			dataIndex: 'start',
			key: 'start',
		},
		{
			title: 'End',
			dataIndex: 'end',
			key: 'end',
		},
	];

	const data = Array<IEventTable>();
	events.forEach((i) => {
		data.push({
			type: capitalize(i.event_type),
			name: i.event_name ? capitalize(i.event_name) : '-',
			location: capitalize(i.event_location),
			start: moment(i.event_start_date).format(DATE_FORMAT),
			end: moment(i.event_end_date).format(DATE_FORMAT),
		});
	});
	return (
		<>
			<Title style={{ color: 'white' }} level={4}>
				List of Events on {date.click}
			</Title>
			<Table columns={columns} dataSource={data} size='middle' />
		</>
	);
};

export default EventDetailsTable;
