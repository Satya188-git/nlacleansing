import { CaretDownOutlined, CaretUpOutlined } from "@ant-design/icons";
import { Select } from "antd";
import { useState } from "react";
import { useDispatch } from "react-redux";
import { setTag } from "reducers/dashboard-reducer";

const TagFilter = ({ tags }) => {
    const { Option } = Select;
    const [open, setOpen] = useState(false);
    const dispatch = useDispatch();

    return (
        <Select
            placeholder="Select a Tag"
            bordered={false}
            suffixIcon={open ? <CaretUpOutlined /> : <CaretDownOutlined />}
            onChange={(val) => dispatch(setTag(val))}
            onDropdownVisibleChange={(open) => setOpen(open)}
            disabled={!tags || tags.length === 0}
        >
            <Option value=""> </Option>
            {
                tags?.map(i => (
                    <Option key={i} value={i}>
                        {i}
                    </Option>
                ))
            }
        </Select>
    )
}

export default TagFilter;