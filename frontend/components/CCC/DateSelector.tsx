import { DatePicker, Typography } from 'antd';
import moment from 'moment';
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setDate } from 'reducers/ccc-reducer';
import DateUtil from '../../helpers/DateUtil';

const { RangePicker } = DatePicker;
const format = DateUtil.DATE_FORMAT;
const customFormat = DateUtil.customFormat;
const { Title } = Typography;

const DateSelector: React.FC = () => {
	const date = useSelector((state: any) => state.ccc.date);
	const dispatch = useDispatch();
	const [start, setStart] = useState(date.startDate);
	const [end, setEnd] = useState(date.endDate);

	const checkDates = (dateString) => {
		const __start = moment(dateString[0]).format(format);
		const __end = moment(dateString[1]).format(format);
		if (__end !== date.endDate) {
			const _start = new Date(new Date(dateString[1]).setFullYear(new Date(dateString[1]).getFullYear() - 1));
			setStart(moment(_start).format(format));
			setEnd(__end);
		} else if (__start !== date.startDate) {
			const _end = new Date(new Date(dateString[0]).setFullYear(new Date(dateString[0]).getFullYear() + 1));
			setEnd(moment(_end).format(format));
			setStart(__start);
		}
	}

	return (
		<>
			<Title level={5}>Date Range</Title>
			<RangePicker
				defaultValue={[moment(date.startDate, format), moment(date.endDate, format)]}
				format={customFormat}
				onChange={(_, dateString) => {
					dispatch(setDate({
						startDate: moment(dateString[0]).format(DateUtil.DATE_FORMAT),
						endDate: moment(dateString[1]).format(DateUtil.DATE_FORMAT),
					}));
					checkDates(dateString);
				}}
				style={{ width: '100%' }}
				allowClear={false}
				separator={"-"}
				disabledDate={(current) => (current.isAfter(moment(end)) || current.isBefore(moment(start)))}
			/>
		</>
	);
};

export default DateSelector;