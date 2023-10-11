import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";

const Page = () => {
  return <div>Page</div>;
};
Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;
export default Page;
