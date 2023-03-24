export default interface IPostReddit {
	platform: string;
	brand: string;
	content: string;
	url: string;
	id: string;
	likesCount: number;
	commentsCount: string;
	event_keyword: string;
	date: string;
	question_mark: string | number;
	FAQ: string | number;
	contains_question: number;
	predicted_score: number;
	predicted_sentiment: string;
	text: string;
	title: string;
}
