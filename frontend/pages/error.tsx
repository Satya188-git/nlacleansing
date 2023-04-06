import { Button, Result } from 'antd';
import { useRouter } from 'next/router';
import React from 'react';
import styled from 'styled-components';

const CenterContainer = styled.div`
	display: flex;
	flex: 1;
	flex-direction: column;
	justify-content: center;
`;

const ErrorPage = () => {
	const router = useRouter();
	return (
		<CenterContainer>
			<Result
				status='404'
				title='Hmm...'
				subTitle='Something went wrong please try again.'
				extra={
					<Button type='primary' onClick={() => router.back()}>
						Go Back
					</Button>
				}
			/>
		</CenterContainer>
	);
};

export default ErrorPage;
