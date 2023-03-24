import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';
import { ICallInsight } from 'types/callInsight';
import { ICallLevel } from 'types/callLevelInfo';

export interface ICallSelectProviderProps {
	children?: React.ReactNode;
}

export interface CallSelectDataState {
	selectedCallInsightData: ICallInsight;
	selectedCallLevelData: ICallLevel;
}

export interface CallSelectContextValue {
	callSelectData: CallSelectDataState;
	setCallSelectData: Dispatch<SetStateAction<CallSelectDataState>>;
}

const callSelectDataDefaultValue: CallSelectContextValue = {
	callSelectData: {
		selectedCallInsightData: {
			callID: '',
			segmentStartTime: '',
			segmentStopTime: '',
			callLengthSeconds: '',
			customerType: '',
			ivrCallCategory: '',
			agentFullName: '',
			participantAgentId: '',
			callSummary: '',
			callEndingSentimentLabel: '',
			callTagLabels: '',
			callSegments: [],
		},
		selectedCallLevelData: {
			agentFullName: '',
			callEndingSentimentLabel: '',
			callID: '',
			callLengthSeconds: 0,
			callSummary: '',
			callTagLabels: '',
			callTranscriptsS3URI: '',
			callsegments: [],
			calltags: [],
			customerType: '',
			participantPhoneNumber: "",
			segmentStartTime: "",
			segmentStopTime: "",
			transcripts: [],
		},
	},
	setCallSelectData: (state: CallSelectDataState) => { },
};

export const CallSelectDataContext = React.createContext<CallSelectContextValue>(null);
export const useCallSelectDataContext = () => useContext(CallSelectDataContext);

export const CallSelectDataProvider: React.FC<ICallSelectProviderProps> = ({ children }) => {
	const [callSelectData, setCallSelectData] = useState<CallSelectDataState>(
		callSelectDataDefaultValue.callSelectData
	);

	const providerValue = useMemo(
		() => ({ callSelectData, setCallSelectData }),
		[callSelectData, setCallSelectData]
	);

	return (
		<CallSelectDataContext.Provider value={providerValue}>
			{children}
		</CallSelectDataContext.Provider>
	);
};
