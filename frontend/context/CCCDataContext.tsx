import React, { Dispatch, SetStateAction, useContext, useEffect, useMemo, useState } from 'react';
import { ICallInsight } from 'types/callInsight';
import { ICallLevel } from 'types/callLevelInfo';
import { useDateContext } from './DateContext';
export interface ICCCDataProviderProps {
	children?: React.ReactNode;
}

export interface CCCDataState {
	callInsights: Array<ICallInsight>;
	callLevelInfos: Array<ICallLevel>;
	isLoading: boolean;
	callDuration: string;
	callID: string;
	tags: Array<string>;
}

export interface CCCDataContextValue {
	cccData: CCCDataState;
	setCCCData: Dispatch<SetStateAction<CCCDataState>>;
}

export interface CCCParams {
	callstartdate: string,
	callenddate: string,
	callDuration: string,
	callid: string,
}

const cccDataDefaultValue: CCCDataContextValue = {
	cccData: {
		callInsights: [],
		callLevelInfos: [],
		tags: [],
		callDuration: '',
		callID: '',
		isLoading: true
	},
	setCCCData: (state: CCCDataState) => { },
};

export const CCCDataContext = React.createContext<CCCDataContextValue>(null);
export const useCCCDataContext = () => useContext(CCCDataContext);

export const CCCDataProvider: React.FC<ICCCDataProviderProps> = ({ children }) => {
	const [cccData, setCCCData] = useState<CCCDataState>(cccDataDefaultValue.cccData);
	// const providerValue = { cccData, setCCCData };
	const providerValue = useMemo(() => ({ cccData, setCCCData }), [cccData, setCCCData]);

	return <CCCDataContext.Provider value={providerValue}>{children}</CCCDataContext.Provider>;
};
