import { Select, Typography } from 'antd';
import { useCallFilterContext } from 'context/CallFilterContext';
import { useCCCDataContext } from 'context/CCCDataContext';
import React, { useEffect, useState } from 'react';

const AgentSearch = () => {
	const {
		cccData: { callInsights },
	} = useCCCDataContext();
	const {
		setCallFilter,
		callFilter: { tags },
	} = useCallFilterContext();
	const [tagArr, setTagArr] = useState([]);

	const { Option } = Select;
	const uniqueTags = new Set<string>();
	const { Title } = Typography;

	useEffect(() => {
		if (
			Array.isArray(callInsights) &&
			callInsights !== undefined &&
			callInsights.length > 0
		) {
			callInsights.forEach((item) =>
				item.callTagLabels?.split(",")?.forEach((tag) => {
					if (tag) {
						uniqueTags.add(tag);
					}
				})
			);
			setTagArr(Array.from(uniqueTags).sort());
		}
	}, [callInsights]);

	const handleChange = (value: string[]) => {
		setCallFilter((prev) => ({ ...prev, tags: value }));
	};

	return (
		<>
			<Title level={5}>Call Tags</Title>
			<Select
				className='tags-select'
				showSearch
				mode='multiple'
				allowClear
				style={{ width: '291px' }}
				onChange={handleChange}
				placeholder='Search and Select from List'
			>
				{tagArr.map((item, i) => {
					return (
						<Option key={`${i}${item}`} value={item}>
							{item}
						</Option>
					);
				})}
			</Select>
		</>
	);
};

export default AgentSearch;
