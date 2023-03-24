import { SocialMediaChannel } from 'constants/social';
import { useSLDataContext } from 'context/SLDataContext';
import { useDateContext } from 'context/DateContext';
import { useEventKeywordContext } from 'context/EventKeywordContext';
import { useSocialChannelContext } from 'context/SocialChannelContext';
import { IEvent, IPost } from 'types';

export const addUniquePostToArr = (posts: IPost[], item: IPost) => {
	var index = posts.findIndex((arr) => arr.id == item.id);
	if (index === -1) {
		posts.push(item);
	}
};

export const filterTopPosts = (sentiment: string): Array<IPost> => {
	const { date } = useDateContext();
	const {
		data: { posts },
	} = useSLDataContext();
	const { keyword } = useEventKeywordContext();
	const { channel } = useSocialChannelContext();
	const filteredPosts: Array<IPost> = posts.filter((item) => {
		if (sentiment === 'Neutral') {
			return item.predicted_sentiment === sentiment || item.predicted_sentiment === 'NEU';
		}

		return item.predicted_sentiment === sentiment;
	});
	const uniqueData: Array<IPost> = [];

	if (!!keyword.name && channel.name === SocialMediaChannel.ALL) {
		filteredPosts.forEach((item) => {
			if (
				!!date.click &&
				item.date === date.click &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			} else if (
				!date.click &&
				item.date >= date.start &&
				item.date <= date.end &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			}
		});
	} else if (!!keyword.name && channel.name !== SocialMediaChannel.ALL) {
		filteredPosts.forEach((item) => {
			if (
				!!date.click &&
				item.date === date.click &&
				item.platform === channel.name &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			} else if (
				!date.click &&
				item.date >= date.start &&
				item.date <= date.end &&
				item.platform === channel.name &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			}
		});
	} else if (!keyword.name && channel.name !== SocialMediaChannel.ALL) {
		filteredPosts.forEach((item) => {
			if (!!date.click && item.date === date.click && item.platform === channel.name) {
				addUniquePostToArr(uniqueData, item);
			} else if (
				!date.click &&
				item.date >= date.start &&
				item.date <= date.end &&
				item.platform === channel.name
			) {
				addUniquePostToArr(uniqueData, item);
			}
		});
	} else {
		filteredPosts.forEach((item) => {
			if (!!date.click && item.date === date.click) {
				addUniquePostToArr(uniqueData, item);
			} else if (!date.click && item.date >= date.start && item.date <= date.end) {
				addUniquePostToArr(uniqueData, item);
			}
		});
	}

	return uniqueData;
};

export const filterEventTypesSelection = (): Array<IEvent> => {
	const {
		data: { timeline },
	} = useSLDataContext();

	const uniqueData: Array<IEvent> = [];
	timeline.forEach((item) => {
		item.events.forEach((event) => {
			var index = uniqueData.findIndex((arr) => arr.event_type == event.event_type);
			if (index === -1) {
				uniqueData.push(event);
			}
		});
	});
	return uniqueData;
};

export const filterFAQs = (): Array<IPost> => {
	const { date } = useDateContext();
	const {
		data: { posts },
	} = useSLDataContext();
	const { keyword } = useEventKeywordContext();
	const uniqueData: Array<IPost> = [];

	if (!!date.click) {
		posts.forEach((item) => {
			if (
				!!keyword.name &&
				item.date === date.click &&
				item.FAQ === 'Yes' &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			} else if (item.date === date.click && item.FAQ === 'Yes') {
				addUniquePostToArr(uniqueData, item);
			}
		});
	} else if (!!keyword.name) {
		posts.forEach((item) => {
			if (
				item.date >= date.start &&
				item.date <= date.end &&
				item.FAQ === 'Yes' &&
				item.event_keyword.toLowerCase() === keyword.name
			) {
				addUniquePostToArr(uniqueData, item);
			}
		});
	} else {
		posts.forEach((item) => {
			if (item.date >= date.start && item.date <= date.end && item.FAQ === 'Yes') {
				addUniquePostToArr(uniqueData, item);
			}
		});
	}

	return uniqueData;
};

export const sortTopPostData = (arr: Array<IPost>) => {
	arr.sort((a, b) => {
		if (a.nw_propagation_score || b.nw_propagation_score) {
			return Number(b.nw_propagation_score) - Number(a.nw_propagation_score);
		}

		if (a.likesCount || b.likesCount) {
			return Number(b.likesCount) - Number(a.likesCount);
		}
	});
};

export const sortFAQData = (arr: Array<IPost>) => {
	arr.sort((a, b) => {
		if (a.nw_propagation_score || b.nw_propagation_score) {
			return Number(b.nw_propagation_score) - Number(a.nw_propagation_score);
		}
	});
};
