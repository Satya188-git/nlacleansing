import DateUtil from 'helpers/DateUtil';
import moment from 'moment';
import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';

export interface IDateProviderProps {
	children?: React.ReactNode;
}

export interface DateState {
	start: string;
	end: string;
	click: string;
}

export interface DateContextValue {
	date: DateState;
	setDate: Dispatch<SetStateAction<DateState>>;
}

const today = new Date().toISOString().slice(0, 10);

const dateDefaultValue: DateContextValue = {
	date: {
		start: '2022-01-01',
		end: '2022-12-31',
		click: '',
	},
	setDate: (state: DateState) => {},
};

export const DateContext = React.createContext<DateContextValue>(null);
export const useDateContext = () => useContext(DateContext);

export const DateProvider: React.FC<IDateProviderProps> = ({ children }) => {
	const [date, setDate] = useState(dateDefaultValue.date);
	const providerValue = useMemo(() => ({ date, setDate }), [date, setDate]);

	return <DateContext.Provider value={providerValue}>{children}</DateContext.Provider>;
};
