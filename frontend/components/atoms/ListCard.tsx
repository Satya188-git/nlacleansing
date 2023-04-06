import { Card } from 'antd';
import { CardProps } from 'antd/lib/card';
import React from 'react';
import styled from 'styled-components';

const ListCard: React.FC<CardProps> = styled(Card)`
	height: 400px;
	overflow: auto;
	padding: 0 10px;
`;

export default ListCard;
