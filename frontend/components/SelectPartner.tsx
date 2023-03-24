import React from 'react';
import { Select } from 'antd';
import { usePartnerContext } from '../context/PartnerContext';
import { Partner } from '../constants/partner';

const SelectPartner: React.FC = () => {
	const { partner, setPartner } = usePartnerContext();
	const { Option } = Select;

	const handleChange = (value: string) => {
		setPartner({ name: value });
	};

	return (
		<Select
			defaultValue={partner.name}
			style={{ width: 120 }}
			size='large'
			onChange={handleChange}
		>
			<Option value={`${Partner.SCG}`}>SoCalGas</Option>
			<Option value={`${Partner.SDGE}`}>SDG&amp;E</Option>
		</Select>
	);
};

export default SelectPartner;
