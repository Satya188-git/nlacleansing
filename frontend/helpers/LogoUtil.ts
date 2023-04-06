import { SocialMediaChannel } from 'constants/social';
import { AWS_URL } from 'constants/url';

export const socialLogoSwitch = (src: string): string => {
	switch (src) {
		case SocialMediaChannel.FACEBOOK:
			return '/facebook.png' || `${AWS_URL.S3}facebook.png`;
		case SocialMediaChannel.TWITTER:
			return '/twitter.png' || `${AWS_URL.S3}twitter.png`;
		case SocialMediaChannel.REDDIT:
			return '/reddit.png' || `${AWS_URL.S3}reddit.png`;
		case SocialMediaChannel.YOUTUBE:
			return '/youtube.png' || `${AWS_URL.S3}youtube.png`;
	}
};

export const newsLogoSwitch = (src: string) => {
	const logo = src.toLowerCase();
	if (logo.includes('abc')) {
		return '/abclogo.png';
	}
	if (logo.includes('cbs')) {
		return '/cbslogo.png';
	}
	if (logo.includes('fox')) {
		return '/foxlogo.png';
	}
	if (logo.includes('nbc')) {
		return '/nbclogo.png';
	}
	if (logo.includes('kcal')) {
		return '/kcallogo.png';
	}
	return '/defaultMediaLogo.png';
};
