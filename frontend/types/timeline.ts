import Metric from './metric';
import IEvent from './event';
import IWeather from './weather';

export default interface ITimeline {
	datestamp: string;
	metrics: Metric[];
	events: IEvent[];
	weather: IWeather;
}
