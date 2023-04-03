import { CaretDownOutlined, CaretUpOutlined } from '@ant-design/icons';
import { Select, Typography } from 'antd';
import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { setAgentsData } from 'reducers/ccc-reducer';

const AgentSearch = ({ agentList }) => {
    const [open, setOpen] = useState(false);
    const { Option } = Select;
    const { Title } = Typography;
    const dispatch = useDispatch();
    const agentData = useSelector((state: any) => state.ccc.agent);

    const handleChange = (value: string[]) => {
        dispatch(setAgentsData(value));
    };

    const getValue = (item) => item?.agent?.split("(")?.[1]?.split(")")[0];

    return (
        <>
            <Title level={5}>Agent Name</Title>
            <Select
                className='agent-select'
                showSearch
                // mode='multiple'
                allowClear
                value={agentData}
                onChange={handleChange}
                suffixIcon={open ? <CaretUpOutlined /> : <CaretDownOutlined />}
                placeholder='Search and Select from List'
                style={{ width: '100%' }}
                onDropdownVisibleChange={(open) => setOpen(open)}
            >
                {agentList.map((item, i) => {
                    return (
                        <Option key={`${i}${item?.agent}`} value={getValue(item)}>
                            {item?.agent}
                        </Option>
                    );
                })}
            </Select>
        </>
    );
};

export default AgentSearch;
