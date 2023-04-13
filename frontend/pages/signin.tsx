import { Button, Space, Typography } from 'antd';
import { Auth, Hub } from 'aws-amplify';
import { Route } from 'constants/routes';
import { useCurrentUser } from 'hooks/useCurrentUser';
import { useRouter } from 'next/router';
import { useEffect } from 'react';

const Signin = () => {
	const { currentUser } = useCurrentUser();
	const router = useRouter();
	useEffect(() => {
		if (currentUser) {
			console.log('Signin Page - getting currentUser: ');
			router.push(Route.DASHBOARD);
		}
	}, [currentUser]);

	const { Title } = Typography;
	Hub.listen('auth', (data) => {
		const { payload } = data;
		console.log('A new auth event has happened: ', data);
		if (payload.event === 'signIn') {
			console.log('a user has signed in!');
		}
		if (payload.event === 'signOut') {
			console.log('a user has signed out!');
		}
		if (payload.event === 'signIn_failure') {
			console.log('a user failed to sign in');
		}
	});

	return (
		<Space direction='vertical'>
			<Title level={1}>Hello 👋</Title>
			<Button
				size='large'
				type='primary'
				onClick={() => router.push(Route.DASHBOARD)}
			>
				Sign In
			</Button>
		</Space>
	);
};

export default Signin;
