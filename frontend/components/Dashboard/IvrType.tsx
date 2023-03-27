import { CaretDownOutlined, CaretUpOutlined } from "@ant-design/icons";
import { Select } from "antd";
import { Types } from "constants/ivrTypes";
import { useState } from "react";
import { useDispatch } from "react-redux";
import { setIvrType } from "reducers/dashboard-reducer";

const IvrTypes = () => {
    const { Option } = Select;
    const [open, setOpen] = useState(false);
    const dispatch = useDispatch();

    return (
        <Select
            placeholder="Filter By IVR Type"
            bordered={false}
            suffixIcon={open ? <CaretUpOutlined /> : <CaretDownOutlined />}
            onChange={(val) => dispatch(setIvrType(val))}
            onDropdownVisibleChange={(open) => setOpen(open)}
        >
            <Option value=""> </Option>
            {
                Types?.map(i => (
                    <Option key={i} value={i}>
                        {i}
                    </Option>
                ))
            }
        </Select>
    )
}

export default IvrTypes;