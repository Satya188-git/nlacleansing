import IEventMetric from './eventmetric';

export default interface IEvent {
	event_type?: string;
	event_name: string | undefined;
	event_location: string;
	event_lat_long: string;
	event_start_date: string;
	event_end_date: string;
	event_metrics: IEventMetric[];
	event_keyword?: string;
	datestamp?: string;
	timestamp?: string;
	net_score?: number;
	impression_count?: number;
	engagement_count?: number;
	pos_count?: number;
	neg_count?: number;
	neu_count?: number;
}
