import { Select, Typography } from 'antd';
import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { setAgentsData } from 'reducers/ccc-reducer';

const AgentSearch = () => {
    const [agents, setAgents] = useState([]);
    const { Option } = Select;
    const uniqueAgents = new Set<string>();
    const { Title } = Typography;
	const dispatch = useDispatch();
	const agentsData = useSelector((state: any) => state.ccc.agents);
	const callInsights = useSelector((state: any) => state.ccc.callInsights);

    useEffect(() => {
        if (callInsights && callInsights?.length > 0) {
            callInsights.forEach((item) => {
                if (item.agentFullName) {
                    uniqueAgents.add(item.agentFullName);
                }
            });
            setAgents(Array.from(uniqueAgents).sort());
        }
    }, [callInsights]);

    const handleChange = (value: string[]) => {
        dispatch(setAgentsData(value));
    };

    return (
        <>
            <Title level={5}>Agent Name</Title>
            <Select
                className='agent-select'
                showSearch
                // mode='multiple'
                allowClear
                value={agentsData}
                onChange={handleChange}
                placeholder='Search and Select from List'
				style={{ width: '100%' }}
            >
                {agents.map((item, i) => {
                    return (
                        <Option key={`${i}${item}`} value={item}>
                            {item}
                        </Option>
                    );
                })}
            </Select>
        </>
    );
};

export default AgentSearch;
