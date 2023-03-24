import { MinusOutlined } from '@ant-design/icons';
import { DatePicker, Typography } from 'antd';
import moment from 'moment';
import React from 'react';
import { useDateContext } from '../context/DateContext';
import DateUtil from '../helpers/DateUtil';

const { RangePicker } = DatePicker;
const format = DateUtil.DATE_FORMAT;
const customFormat = DateUtil.customFormat;
const { Title } = Typography;

const disabledDates = [
	{
		start: moment('1900-01-01', format),
		end: moment('2021-06-01', format),
	},
	{
		start: moment('2022-05-31', format),
		end: moment('2100-12-31', format),
	},
];

const DateSelector: React.FC = () => {
	const { date, setDate } = useDateContext();
	return (
		<>
			<Title level={5}>Date Range</Title>
			<RangePicker
				defaultValue={[moment(date.start, format), moment(date.end, format)]}
				format={customFormat}
				onChange={(_, dateString) => {
					// const startDate = moment(new Date(new Date(dateString[0]).getFullYear(), new Date(dateString[0]).getMonth(), 1).toLocaleDateString()).format(format);
					// const endDate = moment(new Date(new Date(dateString[1]).getFullYear(), new Date(dateString[1]).getMonth() + 1, 0).toLocaleDateString()).format(format);
					setDate({ start: dateString[0], end: dateString[1], click: date.click });
				}}
				style={{ width: '291px' }}
				allowClear={false}
				separator={"-"}
			// disabledDate={(current) =>
			// 	disabledDates.some((date) =>
			// 		current.isBetween(
			// 			moment(date['start'], format),
			// 			moment(date['end'], format),
			// 			'day'
			// 		)
			// 	)
			// }
			/>
		</>
	);
};

export default DateSelector;
