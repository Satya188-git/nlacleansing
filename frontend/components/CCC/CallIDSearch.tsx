import { Input } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { useCallFilterContext } from 'context/CallFilterContext';
import { useCCCDataContext } from 'context/CCCDataContext';
import React, { useRef, useState } from 'react';
import { ICallInsight } from 'types/callInsight';

const CallIDSearch: React.FC = () => {
	const {
		setCallFilter,
		callFilter: { filteredCallInsightData },
	} = useCallFilterContext();
	const callIDRef = useRef(null);

	const { Search } = Input;
	const isFilteredData = () => {
		Array.isArray(filteredCallInsightData) &&
			filteredCallInsightData !== undefined &&
			filteredCallInsightData.length > 0;
	};

	const onSearch = (id: string) => {
		if (isFilteredData) {
			setCallFilter((prev) => ({ ...prev, callID: id }));
		}
	};

	if (callIDRef.current && callIDRef.current.input.value === '') {
		if (isFilteredData) {
			setCallFilter((prev) => ({ ...prev, callID: '' }));
		}
	}

	return (
		<Search
			ref={callIDRef}
			size='middle'
			style={{ width: 210 }}
			allowClear
			placeholder='Search NICE Call ID'
			prefix={<UserOutlined />}
			onSearch={onSearch}
		/>
	);
};

export default CallIDSearch;
