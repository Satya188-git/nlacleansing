import { Card } from 'antd';
import { CardProps } from 'antd/lib/card';
import React from 'react';
import styled from 'styled-components';

const MetadataCard: React.FC<CardProps> = styled(Card)`
	height: 125px;
	width: 250px;
	padding: 10px;
	text-align: center;
	background-color: 'white';
`;

export default MetadataCard;
