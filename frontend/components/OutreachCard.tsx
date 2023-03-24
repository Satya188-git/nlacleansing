import { Card } from 'antd';
import React from 'react';
import { IOutreach } from '../types';
import { useDateContext } from '../context/DateContext';
import CardTitle from './atoms/CardTitle';

const OutreachCard: React.FC<IOutreach> = (data) => {
	const { date } = useDateContext();
	return (
		<>
			<CardTitle title='Active Campaigns' linkButtonTitle='View All' />
			<Card hoverable bordered={false}>
				<div>{date ? `Active Campaign from ${date.start} - ${date.end}` : 'no date'}</div>
			</Card>
		</>
	);
};

export default OutreachCard;
