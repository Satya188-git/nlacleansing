import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import React, { Dispatch, SetStateAction, useContext, useEffect, useMemo, useState } from 'react';
import { ICallInsight } from 'types/callInsight';
import { useCCCDataContext } from './CCCDataContext';
import { useDateContext } from './DateContext';

export interface ICallFilterProviderProps {
	children?: React.ReactNode;
}

export interface CallFilterState {
	callDuration: string;
	callID: string;
	tags: Array<string>;
	filteredCallInsightData: Array<ICallInsight>;
	justNewlyFiltered: boolean;
	isCallIDSearch: boolean;
	isLoading: boolean;
}

export interface CallFilterContextValue {
	callFilter: CallFilterState;
	setCallFilter: Dispatch<SetStateAction<CallFilterState>>;
}

const callFilterDefaultValue: CallFilterContextValue = {
	callFilter: {
		callDuration: '',
		callID: '',
		tags: [],
		filteredCallInsightData: [],
		justNewlyFiltered: false,
		isCallIDSearch: false,
		isLoading: true,
	},
	setCallFilter: (state: CallFilterState) => { },
};

export const CallFilterContext = React.createContext<CallFilterContextValue>(null);
export const useCallFilterContext = () => useContext(CallFilterContext);

export const CallFilterProvider: React.FC<ICallFilterProviderProps> = ({ children }) => {
	const [callFilter, setCallFilter] = useState(callFilterDefaultValue.callFilter);
	const {
		setCCCData,
		cccData: { callInsights, isLoading },
	} = useCCCDataContext();
	// const { date } = useDateContext();
	// const format = DateUtil.DATE_FORMAT;

	useEffect(() => {
		if (
			Array.isArray(callInsights) &&
			callInsights !== undefined &&
			callInsights.length > 0
		) {
			setCallFilter((prev) => ({
				...prev,
				filteredCallInsightData: callInsights,
				isLoading: isLoading
			}));
		} else {
			setCallFilter((prev) => ({
				...prev,
				filteredCallInsightData: [],
				isLoading: isLoading
			}));
		}
	}, [callInsights, isLoading]);

	useEffect(() => {
		setCCCData((prev) => ({ ...prev, callDuration: callFilter.callDuration }));
	}, [callFilter.callDuration])
	
	useEffect(() => {
		setCCCData((prev) => ({ ...prev, tags: callFilter.tags }));
	}, [callFilter.tags])

	const providerValue = useMemo(
		() => ({ callFilter, setCallFilter }),
		[callFilter, setCallFilter]
	);

	return (
		<CallFilterContext.Provider value={providerValue}>{children}</CallFilterContext.Provider>
	);
};
