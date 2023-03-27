import { createSlice } from "@reduxjs/toolkit";
import DateUtil from "helpers/DateUtil";
import moment from "moment";

export const currentYear = new Date().getFullYear();

export const dashboardSlice = createSlice({
    name: 'dashboard',
    initialState: {
        date: {
            startDate: moment(new Date(currentYear, 0, 1)).format(DateUtil.DATE_FORMAT),
            endDate: moment(new Date(currentYear, 11, 31)).format(DateUtil.DATE_FORMAT),
        },
        ivrType: "",
    },
    reducers: {
        setDate: (state, action) => {
            state.date = action.payload;
        },
        setIvrType: (state, action) => {
            state.ivrType = action.payload;
        },
    }
})

export const { setDate, setIvrType } = dashboardSlice.actions;

export default dashboardSlice.reducer;