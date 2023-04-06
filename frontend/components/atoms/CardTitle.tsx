import { Typography } from 'antd';
import React from 'react';
import styled from 'styled-components';

export interface CardTitleProps {
	title: string;
	linkButtonTitle?: string;
}

const CardTitleStyle = styled.div`
	padding: 1.3rem 0;
	display: flex;
	flex: 1;
	flex-direction: column;
`;

const LinkButtonStyle = styled.div`
	justify-content: center;
	align-items: center;
	color: white;
`;

const { Title } = Typography;

const CardTitle: React.FC<CardTitleProps> = ({ title }) => {
	return (
		<CardTitleStyle>
			<Title style={{ color: 'white' }} level={4}>
				{title}
			</Title>
		</CardTitleStyle>
	);
};

export default CardTitle;
