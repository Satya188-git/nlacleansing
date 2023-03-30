import { configureStore } from "@reduxjs/toolkit";
import cccReducer from "reducers/ccc-reducer";
import dashboardReducer from "reducers/dashboard-reducer";

export default configureStore({
    reducer: {
        dashboard: dashboardReducer,
        ccc: cccReducer,
    }
})