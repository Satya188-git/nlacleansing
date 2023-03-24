import { DatePicker } from 'antd';
import { useDateContext } from 'context/DateContext';
import DateUtil from 'helpers/DateUtil';
import moment from 'moment';

const ChartDateFilter = () => {

    const { RangePicker } = DatePicker;
    const format = DateUtil.DATE_FORMAT;
    const { date, setDate } = useDateContext();
    return (
        <RangePicker
            onChange={(_, dateString) => {
                const startDate = moment(new Date(new Date(dateString[0]).getFullYear(), new Date(dateString[0]).getMonth(), 1).toLocaleDateString()).format(format);
                const endDate = moment(new Date(new Date(dateString[1]).getFullYear(), new Date(dateString[1]).getMonth() + 1, 0).toLocaleDateString()).format(format);
                setDate({ start: startDate, end: endDate, click: date.click });
            }}
            style={{ width: '291px' }}
            allowClear={false}
            separator={"-"}
            picker={"month"}
        />
    )
}

export default ChartDateFilter;
