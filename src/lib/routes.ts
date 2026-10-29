export const pageRoutes={home:'/',explore:'/explore-issues/',resolved:'/resolved-issues/',about:'/about/',map:'/karnataka-map/',watch:'/development-watch/',help:'/help/',my:'/my-reports/',saved:'/supported-issues/'} as const;
export type View=keyof typeof pageRoutes;
