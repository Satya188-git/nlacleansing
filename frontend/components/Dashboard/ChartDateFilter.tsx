import { DatePicker } from 'antd';
import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setDate } from 'reducers/dashboard-reducer';

const ChartDateFilter = () => {

    const { RangePicker } = DatePicker;
    const format = DateUtil.DATE_FORMAT;
    const dispatch = useDispatch();
    const customMonthFormat = DateUtil.customMonthFormat;
    const date = useSelector((state: any) => state.dashboard.date);
    const [start, setStart] = useState(date.startDate);
    const [end, setEnd] = useState(date.endDate);

    const checkDates = (dateString) => {
        const __start = moment(dateString[0]).format(DateUtil.MONTH_FORMAT);
        const __end = moment(dateString[1]).format(DateUtil.MONTH_FORMAT);
        const prevStart = moment(date.startDate).format(DateUtil.MONTH_FORMAT);
        const prevEnd = moment(date.endDate).format(DateUtil.MONTH_FORMAT);
        if (__end !== prevEnd) {
            let _start = new Date(new Date(dateString[1]).setFullYear(new Date(dateString[1]).getFullYear() - 1));
            _start = new Date(_start.getFullYear(), _start.getMonth() + 1, 1);
            setStart(moment(_start).format(DateUtil.MONTH_FORMAT));
            setEnd(__end);
        } else if (__start !== prevStart) {
            let _end = new Date(new Date(dateString[0]).setFullYear(new Date(dateString[0]).getFullYear() + 1));
            _end = new Date(_end.getFullYear(), _end.getMonth() - 1, 1);
            setEnd(moment(_end).format(DateUtil.MONTH_FORMAT));
            setStart(__start);
        }
    }

    return (
        <RangePicker
            className='month-picker'
            format={customMonthFormat}
            defaultValue={[moment(date.startDate, format), moment(date.endDate, format)]}
            onChange={(_, dateString) => {
                const startDate = moment(new Date(new Date(dateString[0]).getFullYear(), new Date(dateString[0]).getMonth(), 1).toLocaleDateString()).format(format);
                const endDate = moment(new Date(new Date(dateString[1]).getFullYear(), new Date(dateString[1]).getMonth() + 1, 0).toLocaleDateString()).format(format);
                dispatch(setDate({ startDate, endDate }));
                checkDates(dateString);
            }}
            style={{ width: '100%' }}
            allowClear={false}
            separator={"-"}
            picker={"month"}
            disabledDate={(current) => (current.isAfter(moment(end)) || current.isBefore(moment(start)))}
        />
    )
}

export default ChartDateFilter;
