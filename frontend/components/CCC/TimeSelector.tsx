import { CaretDownOutlined, CaretUpOutlined } from '@ant-design/icons';
import { Select, Typography } from 'antd';
import { callDurations } from 'constants/callDuraions';
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setCallDuration } from 'reducers/ccc-reducer';

const TimeSelector: React.FC = () => {
	const { Option } = Select;
	const [open, setOpen] = useState(false);
	const { Title } = Typography;
	const dispatch = useDispatch();
	const callDuration = useSelector((state: any) => state.ccc.callDuration);

	return (
		<>
			<Title level={5}>Call Duration</Title>
			<Select
				// showSearch
				bordered={false}
				placeholder='Call Duration Filter'
				suffixIcon={open ? <CaretUpOutlined /> : <CaretDownOutlined />}
				style={{ width: '100%' }}
				value={callDuration}
				onChange={(value) => dispatch(setCallDuration(value))}
				onDropdownVisibleChange={(open) => setOpen(open)}
			>
				{
					callDurations.map(d => (
						<Option key={d.value} value={d.value}>
							{d.name}
						</Option>
					))
				}
			</Select>
		</>
	);
};

export default TimeSelector;
