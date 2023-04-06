import { Partner } from 'constants/partner';
import React, { Dispatch, SetStateAction, useContext, useMemo, useState } from 'react';

export interface IPartnerProviderProps {
	children?: React.ReactNode;
}

export interface PartnerState {
	name: string;
}

export interface PartnerContextValue {
	partner: PartnerState;
	setPartner: Dispatch<SetStateAction<PartnerState>>;
}

const partnerDefaultValue: PartnerContextValue = {
	partner: { name: Partner.SDGE },
	setPartner: (state: PartnerState) => {},
};

export const PartnerContext = React.createContext<PartnerContextValue>(null);
export const usePartnerContext = () => useContext(PartnerContext);

export const PartnerProvider: React.FC<IPartnerProviderProps> = ({ children }) => {
	const [partner, setPartner] = useState(partnerDefaultValue.partner);
	const providerValue = useMemo(() => ({ partner, setPartner }), [partner, setPartner]);

	return <PartnerContext.Provider value={providerValue}>{children}</PartnerContext.Provider>;
};
