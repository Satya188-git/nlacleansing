import { configureStore } from "@reduxjs/toolkit";
import dashboardReducer from "reducers/dashboard-reducer";

export default configureStore({
    reducer: {
        dashboard: dashboardReducer,
    }
})