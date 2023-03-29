import { Authenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import { Layout } from 'antd';
import { Content } from 'antd/lib/layout/layout';
import { Amplify, Auth } from 'aws-amplify';
import { configureAxios } from 'axiosConfig';
import { Navbar } from 'components';
import { AuthenticatorProvider } from 'context/AuthenticatorContext';
import { CallFilterProvider } from 'context/CallFilterContext';
import { CallSelectDataProvider } from 'context/CallSelectContext';
import { CallTimelineSelectDataProvider } from 'context/CallTimelineSelectContext';
import { CCCDataProvider } from 'context/CCCDataContext';
import { EventKeywordProvider } from 'context/EventKeywordContext';
import { EventTypeProvider } from 'context/EventTypeContext';
import { SLDataProvider } from 'context/SLDataContext';
import { useCurrentUser } from 'hooks/useCurrentUser';
import Head from 'next/head';
import { useEffect, useState } from 'react';
import awsconfig from '../aws-exports';
import { DateProvider } from '../context/DateContext';
import { PartnerProvider } from '../context/PartnerContext';
import { SocialChannelProvider } from '../context/SocialChannelContext';
import '../styles/globals.css';
import '../styles/custom-antd.css';
import '../styles/dashboard.css';
import { Provider } from 'react-redux';
import store from '../app/store';

configureAxios();

Amplify.configure({
	Auth: {
		identityPoolId: awsconfig.AWS_COGNITO_IDENTITY_POOL_ID,
		region: awsconfig.AWS_REGION,
		userPoolId: awsconfig.AWS_COGNITO_USER_POOL_ID,
		userPoolWebClientId: awsconfig.AWS_COGNITO_CLIENT_ID,
		oauth: {
			domain: awsconfig.AWS_COGNITO_CLIENT_DOMAIN_NAME,
			scope: awsconfig.AWS_COGNITO_IDP_OAUTH_CLAIMS,
			redirectSignIn: awsconfig.AWS_COGNITO_IDP_SIGNIN_URL,
			redirectSignOut: awsconfig.AWS_COGNITO_IDP_SIGNOUT_URL,
			responseType: awsconfig.AWS_COGNITO_IDP_GRANT_FLOW,
		},
	},
});

Amplify.register(Auth);
// const urlAuth = `https://${awsconfig.AWS_COGNITO_CLIENT_DOMAIN_NAME}/oauth2/authorize?identity_provider=${awsconfig.AWS_COGNITO_IDP_NAME}&redirect_uri=${awsconfig.AWS_COGNITO_IDP_SIGNIN_URL}&response_type=${awsconfig.AWS_COGNITO_IDP_GRANT_FLOW}&client_id=${awsconfig.AWS_COGNITO_CLIENT_ID}`;

const App = ({ Component, pageProps }) => {
	const { currentUser } = useCurrentUser();
	useEffect(() => {
		console.log('Main App - currentUser:', currentUser);
	}, [currentUser]);

	return (
		// Uncomment Authenticator block to use for LocalHost testing & development
		// <Authenticator>
		// 	{({ user, signOut }) => (
		// <AuthenticatorProvider value={{ user: currentUser }}>
		<Provider store={store}>
			<PartnerProvider>
				<SLDataProvider>
					<CCCDataProvider>
						<Layout style={{ minHeight: '100vh' }}>
							<Head>
								<title>Social Listening Dashboard</title>
								<meta
									name='description'
									content='Social Insights on Emergency Outreach and Operations'
								/>
								<link rel='icon' href='/favicon.ico' />
							</Head>
							<Navbar />
							<Content
								className='site-layout'
								style={{
									padding: '0 1.5rem',
									marginTop: '1.5rem',
									height: '95vh',
									overflowY: "auto",
								}}
							>
								<DateProvider>
									<SocialChannelProvider>
										<EventKeywordProvider>
											<EventTypeProvider>
												<CallFilterProvider>
													<CallSelectDataProvider>
														<CallTimelineSelectDataProvider>
															<Component {...pageProps} />
														</CallTimelineSelectDataProvider>
													</CallSelectDataProvider>
												</CallFilterProvider>
											</EventTypeProvider>
										</EventKeywordProvider>
									</SocialChannelProvider>
								</DateProvider>
							</Content>
						</Layout>
					</CCCDataProvider>
				</SLDataProvider>
			</PartnerProvider>
		</Provider>
		// </AuthenticatorProvider>
		// 	)}
		// </Authenticator>
	);
};

export default App;
