import { Select } from 'antd';
import { useEventTypeContext } from 'context/EventTypeContext';
import { filterEventTypesSelection } from 'helpers/FilterDataUtil';
import { capitalize } from 'helpers/StringUtil';
import React from 'react';

const EventTypeSelector: React.FC = () => {
	const { Option } = Select;
	const { event, setEvent } = useEventTypeContext();

	const uniqueData = filterEventTypesSelection();

	const handleChange = (value: string) => {
		setEvent({ type: value.toLowerCase() });
	};

	return (
		<Select showSearch style={{ width: 150 }} onChange={handleChange} defaultValue={event.type}>
			<Option key='all' value=''>
				All Event Types
			</Option>
			{uniqueData.map((item, i) => (
				<Option key={i} value={`${item.event_type}`}>
					{capitalize(item.event_type)}
				</Option>
			))}
		</Select>
	);
};

export default EventTypeSelector;
