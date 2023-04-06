import { Select, Typography } from 'antd';
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setTags } from 'reducers/ccc-reducer';

const CallTagSelector = ({ tagList }) => {

	const { Option } = Select;
	const { Title } = Typography;
	const tags = useSelector((state: any) => state.ccc.tags);
	const dispatch = useDispatch();

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
				{tagList?.map((item, i) => {
					return (
						<Option key={`${i}${item?.tagLabel}`} value={item?.tagLabel}>
							{item?.tagLabel}
						</Option>
					);
				})}
			</Select>
		</>
	);
};

export default CallTagSelector;
