import { ICallSegment, ICallTag } from "./callInsight";

export interface ICallLevelInfo {
	companyName: string;
	fileID: string;
	fileName: string;
	fullName: string;
	participantAgentId: string;
	segmentCallDirectionTypeId: string;
	participantPhoneNumber: string;
	participantAreaCode: string;
	segmentID: string;
	segmentDialedNumber: string;
	segmentStartTime: string;
	segmentStopTime: string;
	segmentVectorNumber: string;
	internalSegmentClientStartTime: string;
	internalSegmentClientStopTime: string;
	callLengthSeconds: string;
	language: string;
	customerType: string;
	ivrCallCategory: string;
	batchName: string;
}

interface ISentimentScore {
	Positive: number;
	Negative: number;
	Neutral: number;
	Mixed: number;
}

export interface ICallLevelTranscript {
	lineId: string;
	content: string;
	beginOffsetMillis: number;
	endOffsetMillis: number;
	sentiment: string;
	sentimentScore: string | ISentimentScore;
	participantRole: string;
}

export interface ICallLevel {
	// callLevelInformation: ICallLevelInfo;
	agentFullName: string,
	callEndingSentimentLabel: string,
	callID: string,
	callLengthSeconds: number,
	callSummary: string,
	callTagLabels: string,
	callTranscriptsS3URI: string,
	callsegments: ICallSegment[],
	calltags: ICallTag[],
	customerType: string,
	participantPhoneNumber: "",
	segmentStartTime: "",
	segmentStopTime: "",
	transcripts: Array<ICallLevelTranscript>;
}
