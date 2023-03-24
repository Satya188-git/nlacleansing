import { useSLDataContext } from 'context/SLDataContext';
import 'd3-transition';
import React from 'react';
import ReactWordcloud from 'react-wordcloud';
import styled from 'styled-components';
import 'tippy.js/animations/scale.css';
import 'tippy.js/dist/tippy.css';
import { numFormatter } from '../helpers/NumberUtil';

interface IWordCloud {
	text: string;
	value: number;
}

const WordCloudContainer = styled.div`
	display: flex;
	align-items: center;
	justify-content: center;
	margin: auto;
	height: 200px;
`;

const options = {
	colors: ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b'],
	enableTooltip: true,
	deterministic: false,
	fontFamily: 'impact',
	fontStyle: 'normal',
	fontWeight: 'normal',
	transitionDuration: 1000,
};

const callbacks = {
	getWordTooltip: (word) =>
		`The word "${word.text}" was mentioned ${numFormatter(word.value, 1)} times.`,
};

const WordCloud: React.FC = () => {
	const {
		data: { keywords_and_topics },
	} = useSLDataContext();
	const words: Array<IWordCloud> = [];
	keywords_and_topics.forEach((item) => {
		words.push({
			text: item.keyword_name,
			value: item.metrics[0].metric_count,
		});
	});
	return (
		<WordCloudContainer>
			<ReactWordcloud options={options} callbacks={callbacks} words={words} />
		</WordCloudContainer>
	);
};

export default WordCloud;
