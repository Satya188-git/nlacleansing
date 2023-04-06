export default interface IPost {
	platform: string;
	brand: string;
	url: string;
	id: string | number;
	event_keyword: string;
	date: string;
	contains_question: number;
	predicted_sentiment: string;
	FAQ?: string | number;
	content?: string | number;
	text?: string | number;
	question_mark?: string | number;
	likeability_score?: number;
	nw_propagation_score?: number;
	predicted_score?: string | number;
	followersCount?: number;
	replyCount?: number;
	retweetCount?: number;
	likeCount?: number;
	likesCount?: number;
	commentsCount?: string;
	quoteCount?: number;
	title?: string;
}
