import { Select } from 'antd';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { capitalize } from 'helpers/StringUtil';
import React from 'react';
import { useSLDataContext } from '../context/SLDataContext';

const EventKeywordSelector: React.FC = () => {
	const { Option } = Select;
	const { keyword, setKeyword } = useEventKeywordContext();
	const {
		data: { posts },
	} = useSLDataContext();
	const uniqueKeyword = new Set<string>();
	posts.forEach((i) => {
		if (!!i.event_keyword) {
			if (i.event_keyword.toLowerCase() === 'public safety power shutoff') {
				uniqueKeyword.add('psps');
			} else {
				uniqueKeyword.add(i.event_keyword.toLowerCase());
			}
		}
	});

	const handleChange = (value: string) => {
		setKeyword({ name: value.toLowerCase() });
	};

	return (
		<Select
			showSearch
			style={{ width: 150 }}
			onChange={handleChange}
			defaultValue={keyword.name}
		>
			<Option key='all' value=''>
				All Event Keywords
			</Option>
			{Array.from(uniqueKeyword).map((item, i) => (
				<Option key={i} value={`${item}`}>
					{capitalize(item)}
				</Option>
			))}
		</Select>
	);
};

export default EventKeywordSelector;
