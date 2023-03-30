import { Select, Typography } from 'antd';
import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setTags } from 'reducers/ccc-reducer';

const CallTagSelector: React.FC = () => {

	const [tagArr, setTagArr] = useState([]);
	const { Option } = Select;
	const uniqueTags = new Set<string>();
	const { Title } = Typography;
	const callInsights = useSelector((state: any) => state.ccc.callInsights);
	const tags = useSelector((state: any) => state.ccc.tags);
	const dispatch = useDispatch();

	useEffect(() => {
		if (callInsights && callInsights?.length > 0) {
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
		dispatch(setTags(value));
	};

	return (
		<>
			<Title level={5}>Call Tags</Title>
			<Select
				className='tags-select text-uppercase'
				showSearch
				mode='multiple'
				allowClear
				style={{ width: '100%' }}
				value={tags}
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

export default CallTagSelector;
