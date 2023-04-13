import { Card } from 'antd';
import { CardProps } from 'antd/lib/card';
import React from 'react';
import styled from 'styled-components';

const CardWrapContainer: React.FC<CardProps> = styled(Card)`
	padding: 0 10px;
	word-wrap: break-word;
`;

export default CardWrapContainer;
