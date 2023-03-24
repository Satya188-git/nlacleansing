import { numFormatter } from 'helpers/NumberUtil';
import React from 'react';
import { IPost } from 'types';

const PostDescription: React.FC<IPost> = ({
	date,
	predicted_sentiment,
	nw_propagation_score,
	predicted_score,
	followersCount,
	likeCount,
	likesCount,
}) => {
	return (
		<>
			({`${date}`})
			<br />
			{nw_propagation_score &&
				`Net Propagation Score: ${numFormatter(nw_propagation_score, 1)} | `}
			{predicted_score && `${Math.round(Number(predicted_score) * 100)}% confidence - `}
			{`${
				predicted_sentiment.toUpperCase() === 'NEU'
					? 'NEUTRAL'
					: predicted_sentiment.toUpperCase()
			} sentiment | Like Count: ${numFormatter(likeCount | likesCount, 1)}`}
			{followersCount && ` | Followers Count: ${numFormatter(followersCount, 1)}`}
		</>
	);
};

export default PostDescription;
