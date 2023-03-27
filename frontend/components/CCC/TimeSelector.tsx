import { CaretDownOutlined, CaretUpOutlined } from '@ant-design/icons';
import { Select, Typography } from 'antd';
import { useCallFilterContext } from 'context/CallFilterContext';
import React, { useState } from 'react';

const TimeSelector: React.FC = () => {
	const { Option } = Select;
	const [open, setOpen] = useState(false);
	const { Title } = Typography;
	const {
		setCallFilter,
		callFilter: { callDuration },
	} = useCallFilterContext();

	const handleChange = (value: string) => {
		let time = '';
		switch (value) {
			case '5':
				time = '<5MINS';
				break;
			case '10':
				time = '<10MINS';
				break;
			case '20':
				time = '<20MINS';
				break;
			case '30':
				time = '<30MINS';
				break;
			case '45':
				time = '<45MINS';
				break;
			case '+':
				time = '>45MINS';
				break;
		}
		setCallFilter((prev) => ({ ...prev, callDuration: time }));
	};

	return (
		<>
			<Title level={5}>Call Duration</Title>
			<Select
				// showSearch
				bordered={false}
				placeholder='Call Duration Filter'
				suffixIcon={open ? <CaretUpOutlined /> : <CaretDownOutlined />}
				onChange={handleChange}
				onDropdownVisibleChange={(open) => setOpen(open)}
				defaultValue={callDuration ? callDuration : ''}
			>
				{/* <Option key='all' value=''>
				All Call Duration
			</Option> */}
				<Option key='5' value='5'>
					&lt; 5 MINS
				</Option>
				<Option key='10' value='10'>
					&lt; 10 MINS
				</Option>
				<Option key='20' value='20'>
					&lt; 20 MINS
				</Option>
				<Option key='30' value='30'>
					&lt; 30 MINS
				</Option>
				<Option key='45' value='45'>
					&lt; 45 MINS
				</Option>
				<Option key='+' value='+'>
					&gt; 45 MINS
				</Option>
			</Select>
		</>
	);
};

export default TimeSelector;
