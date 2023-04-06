export interface ICallTranscript {
	id: string;
	loudnessScores?: Array<number>;
	content?: string;
	beginOffsetMillis?: number;
	endOffsetMillis?: number;
	sentiment?: string;
	participantRole?: string;
}
