import Metric from './metric';

export default interface IInfluencer {
	platform: string;
	username: string;
	profile_img_url: string;
	metrics: Metric[];
}
