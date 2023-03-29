import { createSlice } from "@reduxjs/toolkit";
import DateUtil from "helpers/DateUtil";
import moment from "moment";

export const currentYear = new Date("2022-05-20").getFullYear();

export const dashboardSlice = createSlice({
    name: 'dashboard',
    initialState: {
        date: {
            startDate: moment(new Date(currentYear, 0, 1)).format(DateUtil.DATE_FORMAT),
            endDate: moment(new Date(currentYear, 11, 31)).format(DateUtil.DATE_FORMAT),
        },
        ivrType: "",
        tag: "",
    },
    reducers: {
        setDate: (state, action) => {
            state.date = action.payload;
        },
        setIvrType: (state, action) => {
            state.ivrType = action.payload;
        },
        setTag: (state, action) => {
            state.tag = action.payload;
        },
    }
})

export const { setDate, setIvrType, setTag } = dashboardSlice.actions;

export default dashboardSlice.reducer;