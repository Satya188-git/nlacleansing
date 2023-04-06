import { Auth } from 'aws-amplify';
import { useState, useEffect } from 'react';

export const useCurrentUser = () => {
	const [currentUser, setCurrentUser] = useState();
	useEffect(() => {
		(async () => {
			try {
				const user = await Auth.currentAuthenticatedUser();
				setCurrentUser(user);
			} catch (e) {
				return Promise.reject(e);
			}
		})();
	}, []);
	return { currentUser, setCurrentUser };
};
