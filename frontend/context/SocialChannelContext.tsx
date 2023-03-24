import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';

export interface ISocialChannelProviderProps {
	children?: React.ReactNode;
}

export interface SocialChannelState {
	name: string;
}

export interface SocialChannelContextValue {
	channel: SocialChannelState;
	setChannel: Dispatch<SetStateAction<SocialChannelState>>;
}

const socialChannelDefaultValue: SocialChannelContextValue = {
	channel: { name: 'all' },
	setChannel: (state: SocialChannelState) => {},
};

export const SocialChannelContext = React.createContext<SocialChannelContextValue>(null);
export const useSocialChannelContext = () => useContext(SocialChannelContext);

export const SocialChannelProvider: React.FC<ISocialChannelProviderProps> = ({ children }) => {
	const [channel, setChannel] = useState(socialChannelDefaultValue.channel);
	const providerValue = useMemo(() => ({ channel, setChannel }), [channel, setChannel]);

	return (
		<SocialChannelContext.Provider value={providerValue}>
			{children}
		</SocialChannelContext.Provider>
	);
};
