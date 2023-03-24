import { useCallSelectDataContext } from 'context/CallSelectContext';
import { useCCCDataContext } from 'context/CCCDataContext';
import { useDateContext } from 'context/DateContext';
import { useState, useEffect } from 'react';

export const useFilteredData = () => {
	const [filteredData, setFilteredData] = useState(false);
	const {
		cccData: { callInsights },
	} = useCCCDataContext();
	const {
		date: { start, end },
	} = useDateContext();

	return filteredData;
};
