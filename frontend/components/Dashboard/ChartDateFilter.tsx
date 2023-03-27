import { DatePicker } from 'antd';
import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import { useDispatch, useSelector } from 'react-redux';
import { setDate } from 'reducers/dashboard-reducer';

const ChartDateFilter = () => {

    const { RangePicker } = DatePicker;
    const format = DateUtil.DATE_FORMAT;
    const dispatch = useDispatch();
    const customMonthFormat = DateUtil.customMonthFormat;
    const date = useSelector((state: any) => state.dashboard.date);

    return (
        <RangePicker
            format={customMonthFormat}
            defaultValue={[moment(date.startDate, format), moment(date.endDate, format)]}
            onChange={(_, dateString) => {
                const startDate = moment(new Date(new Date(dateString[0]).getFullYear(), new Date(dateString[0]).getMonth(), 1).toLocaleDateString()).format(format);
                const endDate = moment(new Date(new Date(dateString[1]).getFullYear(), new Date(dateString[1]).getMonth() + 1, 0).toLocaleDateString()).format(format);
                dispatch(setDate({ startDate, endDate }))
            }}
            style={{ width: '291px' }}
            allowClear={false}
            separator={"-"}
            picker={"month"}
        />
    )
}

export default ChartDateFilter;
