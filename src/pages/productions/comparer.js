import { Box, Container } from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";

const Page = () => {
  return (
    <>
      <Head>
        <title>Used Packaging Comparer</title>
      </Head>
      <Box sx={{ flexGrow: 1, py: 2 }}>
        <Container component="main" maxWidth="xl">
          
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;
export default Page;
