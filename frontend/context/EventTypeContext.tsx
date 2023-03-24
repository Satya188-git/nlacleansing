import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';

export interface IEventTypeProviderProps {
	children?: React.ReactNode;
}

export interface EventTypeState {
	type: string;
}

export interface EventTypeContextValue {
	event: EventTypeState;
	setEvent: Dispatch<SetStateAction<EventTypeState>>;
}

const eventTypeDefaultValue: EventTypeContextValue = {
	event: { type: '' },
	setEvent: (state: EventTypeState) => {},
};

export const EventTypeContext = React.createContext<EventTypeContextValue>(null);
export const useEventTypeContext = () => useContext(EventTypeContext);

export const EventTypeProvider: React.FC<IEventTypeProviderProps> = ({ children }) => {
	const [event, setEvent] = useState(eventTypeDefaultValue.event);
	const providerValue = useMemo(() => ({ event, setEvent }), [event, setEvent]);

	return <EventTypeContext.Provider value={providerValue}>{children}</EventTypeContext.Provider>;
};
