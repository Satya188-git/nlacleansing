import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';
import { ICallInsight } from 'types/callInsight';
import { ICallLevel } from 'types/callLevelInfo';

export interface ICallTimelineSelectProviderProps {
	children?: React.ReactNode;
}

export interface CallTimelineSelectDataState {
	selectedCallInsightData: ICallInsight;
	selectedCallLevelData: ICallLevel;
}

export interface CallTimelineSelectContextValue {
	callTimelineSelectData: any;
	setCallTimelineSelectData: Dispatch<SetStateAction<any>>;
}

const callTimelineSelectDataDefaultValue: CallTimelineSelectContextValue = {
	callTimelineSelectData: {},
	setCallTimelineSelectData: (state: CallTimelineSelectDataState) => {},
};

export const CallTimelineSelectDataContext =
	React.createContext<CallTimelineSelectContextValue>(null);
export const useCallTimelineSelectDataContext = () => useContext(CallTimelineSelectDataContext);

export const CallTimelineSelectDataProvider: React.FC<ICallTimelineSelectProviderProps> = ({
	children,
}) => {
	const [callTimelineSelectData, setCallTimelineSelectData] =
		useState<CallTimelineSelectDataState>(
			callTimelineSelectDataDefaultValue.callTimelineSelectData
		);

	const providerValue = useMemo(
		() => ({ callTimelineSelectData, setCallTimelineSelectData }),
		[callTimelineSelectData, setCallTimelineSelectData]
	);

	return (
		<CallTimelineSelectDataContext.Provider value={providerValue}>
			{children}
		</CallTimelineSelectDataContext.Provider>
	);
};
