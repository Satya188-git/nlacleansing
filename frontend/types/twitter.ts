export default interface IPostTwitter {
	platform: string;
	brand: string;
	content: string;
	url: string;
	id: number;
	followersCount: number;
	replyCount: number;
	retweetCount: number;
	likeCount: number;
	quoteCount: number;
	event_keyword: string;
	date: string;
	nw_propagation_score: number;
	likeability_score: number;
	question_mark: string | number;
	FAQ: string | number;
	contains_question: number;
	predicted_score: string | number;
	predicted_sentiment: string;
	text: string;
}
