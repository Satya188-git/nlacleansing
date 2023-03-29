import colorLib from '@kurkle/color';
import { valueOrDefault } from 'chart.js/helpers';
import {
	Chart,
	ArcElement,
	LineElement,
	BarElement,
	PointElement,
	BarController,
	BubbleController,
	DoughnutController,
	LineController,
	PieController,
	PolarAreaController,
	RadarController,
	ScatterController,
	CategoryScale,
	LinearScale,
	LogarithmicScale,
	RadialLinearScale,
	TimeScale,
	TimeSeriesScale,
	Decimation,
	Filler,
	Legend,
	Title,
	Tooltip,
	SubTitle,
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';

Chart.register(
	ArcElement,
	LineElement,
	BarElement,
	PointElement,
	BarController,
	BubbleController,
	DoughnutController,
	LineController,
	PieController,
	PolarAreaController,
	RadarController,
	ScatterController,
	CategoryScale,
	LinearScale,
	LogarithmicScale,
	RadialLinearScale,
	TimeScale,
	TimeSeriesScale,
	Decimation,
	Filler,
	Legend,
	Title,
	Tooltip,
	SubTitle,
	ChartDataLabels
);

const DATE_FORMAT = 'YYYY-MM-DD';

function getDatesInBetween(start, end) {
	var startDate = start.clone(),
		dates = [];

	while (startDate.isSameOrBefore(end)) {
		dates.push(startDate.format(DATE_FORMAT));
		startDate.add(1, 'days');
	}
	return dates;
}

// Adapted from http://indiegamr.com/generate-repeatable-random-numbers-in-js/
let _seed = Date.now();

function srand(seed) {
	_seed = seed;
}

function rand(min, max) {
	min = valueOrDefault(min, 0);
	max = valueOrDefault(max, 0);
	_seed = (_seed * 9301 + 49297) % 233280;
	return min + (_seed / 233280) * (max - min);
}

function numbers(config) {
	var cfg = config || {};
	var min = valueOrDefault(cfg.min, 0);
	var max = valueOrDefault(cfg.max, 100);
	var from = valueOrDefault(cfg.from, []);
	var count = valueOrDefault(cfg.count, 8);
	var decimals = valueOrDefault(cfg.decimals, 8);
	var continuity = valueOrDefault(cfg.continuity, 1);
	var dfactor = Math.pow(10, decimals) || 0;
	var data = [];
	var i, value;

	for (i = 0; i < count; ++i) {
		value = (from[i] || 0) + this.rand(min, max);
		if (this.rand() <= continuity) {
			data.push(Math.round(dfactor * value) / dfactor);
		} else {
			data.push(null);
		}
	}

	return data;
}

function points(config) {
	const xs = this.numbers(config);
	const ys = this.numbers(config);
	return xs.map((x, i) => ({ x, y: ys[i] }));
}

function labels(config) {
	var cfg = config || {};
	var min = cfg.min || 0;
	var max = cfg.max || 100;
	var count = cfg.count || 8;
	var step = (max - min) / count;
	var decimals = cfg.decimals || 8;
	var dfactor = Math.pow(10, decimals) || 0;
	var prefix = cfg.prefix || '';
	var values = [];
	var i;
	for (i = min; i < max; i += step) {
		values.push(prefix + Math.round(dfactor * i) / dfactor);
	}
	return values;
}

const MONTHS = [
	'January',
	'February',
	'March',
	'April',
	'May',
	'June',
	'July',
	'August',
	'September',
	'October',
	'November',
	'December',
];

function months(config) {
	var cfg = config || {};
	var count = cfg.count || 12;
	var section = cfg.section;
	var values = [];
	var i, value;
	for (i = 0; i < count; ++i) {
		value = MONTHS[Math.ceil(i) % 12];
		values.push(value.substring(0, section));
	}
	return values;
}
const COLORS = [
	'#4dc9f6',
	'#f67019',
	'#f53794',
	'#537bc4',
	'#acc236',
	'#166a8f',
	'#00a950',
	'#58595b',
	'#8549ba',
];

function color(index) {
	return COLORS[index % COLORS.length];
}

function transparentize(value, opacity) {
	var alpha = opacity === undefined ? 0.5 : 1 - opacity;
	return colorLib(value).alpha(alpha).rgbString();
}

const CHART_COLORS = {
	red: 'rgb(255, 99, 132)',
	orange: 'rgb(255, 159, 64)',
	yellow: 'rgb(255, 205, 86)',
	green: 'rgb(75, 192, 192)',
	blue: 'rgb(54, 162, 235)',
	purple: 'rgb(153, 102, 255)',
	grey: 'rgb(201, 203, 207)',
};

const NAMED_COLORS = [
	CHART_COLORS.red,
	CHART_COLORS.orange,
	CHART_COLORS.yellow,
	CHART_COLORS.green,
	CHART_COLORS.blue,
	CHART_COLORS.purple,
	CHART_COLORS.grey,
];

const _CHART_COLORS = ["#40A9FF", "#0C75DF", "#4ACCD4", "#AADD6D", "#088856"];

function namedColor(index) {
	return _CHART_COLORS[index % _CHART_COLORS.length];
}

const customFormat = (value) => {
	let date: string[] | string = "";
	if (value) {
		date = new Date(value).toString().split(" ");
		date = `${date[1]} ${date[2]}, ${date[3]}`;
	}
	return date;
}

const customMonthFormat = (value) => {
	let date: string[] | string = "";
	if (value) {
		date = new Date(value).toString().split(" ");
		date = `${date[1]}, ${date[3]}`;
	}
	return date;
}

const monthDiff = (d1, d2) => {
	let months;
	months = (new Date(d2).getFullYear() - new Date(d1).getFullYear()) * 12;
	months -= new Date(d1).getMonth();
	months += new Date(d2).getMonth();
	return months <= 0 ? 0 : months;
}

export default {
	srand,
	rand,
	numbers,
	points,
	labels,
	MONTHS,
	months,
	COLORS,
	color,
	transparentize,
	CHART_COLORS,
	NAMED_COLORS,
	namedColor,
	DATE_FORMAT,
	getDatesInBetween,
	customFormat,
	customMonthFormat,
	monthDiff,
};
