import axios from 'axios';
import React, { Dispatch, SetStateAction, useContext, useEffect, useMemo, useState } from 'react';
import {
	IEngagement,
	IFAQs,
	IInfluencer,
	IMedia,
	IOutreach,
	IPost,
	ITimeline,
	ITopic,
} from 'types';
import { Partner } from '../constants/partner';
import { usePartnerContext } from './PartnerContext';

export interface IDataProviderProps {
	children?: React.ReactNode;
}

export interface DataState {
	timeline: Array<ITimeline>;
	current_outreach: Array<IOutreach>;
	engagement_by_platform: Array<IEngagement>;
	keywords_and_topics: Array<ITopic>;
	key_influencers: Array<IInfluencer>;
	local_media_coverage: Array<IMedia>;
	faqs: Array<IFAQs>;
	posts: Array<IPost>;
}

export interface SLDataContextValue {
	data: DataState;
	setData: Dispatch<SetStateAction<DataState>>;
}

const dataDefaultValue: SLDataContextValue = {
	data: {
		timeline: [],
		current_outreach: [],
		engagement_by_platform: [],
		keywords_and_topics: [],
		key_influencers: [],
		local_media_coverage: [],
		faqs: [],
		posts: [],
	},
	setData: (state: DataState) => {},
};

export const SLDataContext = React.createContext<SLDataContextValue>(null);
export const useSLDataContext = () => useContext(SLDataContext);

export const SLDataProvider: React.FC<IDataProviderProps> = ({ children }) => {
	const [data, setData] = useState<DataState>(dataDefaultValue.data);
	const { partner } = usePartnerContext();

	const providerValue = useMemo(() => ({ data, setData }), [data, setData]);

	const url =
		partner.name === Partner.SCG
			? `${process.env.NEXT_PUBLIC_API_GATEWAY}/data/socalgas`
			: `${process.env.NEXT_PUBLIC_API_GATEWAY}/data/sdge`;

	useEffect(() => {
		// Fetch data here
		axios.get(url).then((response) => {
			const newData = response.data as DataState;
			setData(newData);
		});
	}, [url]);

	return <SLDataContext.Provider value={providerValue}>{children}</SLDataContext.Provider>;
};
