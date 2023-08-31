import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import { Box, Container, Typography } from "@mui/material";
import Head from "next/head";

const Page = () => {
  return (
    <>
      <Head>
        <title>Sales |</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Typography variant="h4">Sales Stats</Typography>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
