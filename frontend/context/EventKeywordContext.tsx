import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';

export interface IEventKeywordProviderProps {
	children?: React.ReactNode;
}

export interface EventKeywordState {
	name: string;
}

export interface EventKeywordContextValue {
	keyword: EventKeywordState;
	setKeyword: Dispatch<SetStateAction<EventKeywordState>>;
}

const eventKeywordDefaultValue: EventKeywordContextValue = {
	keyword: { name: '' },
	setKeyword: (state: EventKeywordState) => {},
};

export const EventKeywordContext = React.createContext<EventKeywordContextValue>(null);
export const useEventKeywordContext = () => useContext(EventKeywordContext);

export const EventKeywordProvider: React.FC<IEventKeywordProviderProps> = ({ children }) => {
	const [keyword, setKeyword] = useState(eventKeywordDefaultValue.keyword);
	const providerValue = useMemo(() => ({ keyword, setKeyword }), [keyword, setKeyword]);

	return (
		<EventKeywordContext.Provider value={providerValue}>
			{children}
		</EventKeywordContext.Provider>
	);
};
