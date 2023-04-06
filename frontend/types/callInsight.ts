interface IEndSentiment {
	label: string;
	confidence: number;
}

export interface ICallTag {
	tagLabel: string;
	tagType: string;
	appearsInLineID: Array<string>;
}

export interface ICallSegment {
	segmentName: string;
	startLineId: string;
	endLineId: string;
	beginOffsetMillis: string | number;
	endOffsetMillis: string | number;
	duration: string;
	durationSeconds: number;
}

export interface ICallInsight {
	callID: string;
	segmentStartTime: string;
	segmentStopTime: string;
	callLengthSeconds: string;
	customerType: string;
	ivrCallCategory: string;
	agentFullName: string;
	participantAgentId: string;
	callSummary: string;
	callEndingSentimentLabel: string;
	callTagLabels: string;
	callSegments: Array<ICallSegment>;
}
