import React from 'react';

interface AuthenticatorContextType {
	user: any;
}

const AuthenticatorContext = React.createContext<AuthenticatorContextType>({
	user: {},
});
export const AuthenticatorProvider = AuthenticatorContext.Provider;

export default AuthenticatorContext;
