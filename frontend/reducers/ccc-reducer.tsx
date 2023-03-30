import { createSlice } from "@reduxjs/toolkit";
import DateUtil from "helpers/DateUtil";
import moment from "moment";

export const lastYearDate = new Date(new Date().setFullYear(new Date().getFullYear() - 1));

export const cccSlice = createSlice({
    name: 'ccc',
    initialState: {
        date: {
            startDate: moment(new Date(lastYearDate)).format(DateUtil.DATE_FORMAT),
            endDate: moment(new Date()).format(DateUtil.DATE_FORMAT),
        },
        tags: [],
        agents: [],
        callDuration: "",
        callID: "",
        callInsights: [],
        selectedCallLevelData: null,
        callTimelineSelectData: {},
    },
    reducers: {
        setDate: (state, action) => {
            state.date = action.payload;
        },
        setTags: (state, action) => {
            state.tags = action.payload;
        },
        setAgentsData: (state, action) => {
            state.agents = action.payload;
        },
        setCallDuration: (state, action) => {
            state.callDuration = action.payload;
        },
        setCallID: (state, action) => {
            state.callID = action.payload;
        },
        setCallInsights: (state, action) => {
            state.callInsights = action.payload;
        },
        setSelectedCallLevelData: (state, action) => {
            state.selectedCallLevelData = action.payload;
        },
        setCallTimelineSelectData: (state, action) => {
            state.callTimelineSelectData = action.payload;
        },
        resetData: (state) => {
            state.date = {
                startDate: moment(new Date(lastYearDate)).format(DateUtil.DATE_FORMAT),
                endDate: moment(new Date()).format(DateUtil.DATE_FORMAT),
            };
            state.tags = [];
            state.agents = [];
            state.callDuration = "";
        },
        resetAll: (state) => {
            state.date = {
                startDate: moment(new Date(lastYearDate)).format(DateUtil.DATE_FORMAT),
                endDate: moment(new Date()).format(DateUtil.DATE_FORMAT),
            };
            state.tags = [];
            state.agents = [];
            state.callDuration = "";
            state.callID = "";
        },
    }
})

export const {
    setDate, setTags, setAgentsData, setCallDuration,
    setCallID, setCallInsights, setSelectedCallLevelData,
    setCallTimelineSelectData, resetData, resetAll } = cccSlice.actions;

export default cccSlice.reducer;