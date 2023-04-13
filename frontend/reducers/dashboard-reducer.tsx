import { createSlice } from "@reduxjs/toolkit";
import DateUtil from "helpers/DateUtil";
import moment from "moment";

export const lastYearDate = new Date(new Date().setFullYear(new Date().getFullYear() - 1));
export const lastYearStartDate = new Date(lastYearDate.getFullYear(), lastYearDate.getMonth()+1, 1);

export const dashboardSlice = createSlice({
    name: 'dashboard',
    initialState: {
        date: {
            startDate: moment(new Date(new Date(lastYearStartDate).getFullYear(), new Date(lastYearStartDate).getMonth(), 1).toLocaleDateString()).format(DateUtil.DATE_FORMAT),
            endDate: moment(new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0).toLocaleDateString()).format(DateUtil.DATE_FORMAT),
        },
        ivrType: "",
        tag: "",
        allTags: [],
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
        setAllTags: (state, action) => {
            state.allTags = action.payload;
        },
        resetDashboardData: (state) => {
            state.date = {
                startDate: moment(new Date(new Date(lastYearStartDate).getFullYear(), new Date(lastYearStartDate).getMonth(), 1).toLocaleDateString()).format(DateUtil.DATE_FORMAT),
                endDate: moment(new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0).toLocaleDateString()).format(DateUtil.DATE_FORMAT),
            };
            state.ivrType = "";
            state.tag = "";
            state.allTags = [];
        },
    }
})

export const { setDate, setIvrType, setTag, setAllTags, resetDashboardData } = dashboardSlice.actions;

export default dashboardSlice.reducer;