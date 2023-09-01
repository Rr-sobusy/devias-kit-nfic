import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import { Box, Container, Unstable_Grid2 as Grid } from "@mui/material";
import Head from "next/head";
import WarehouseStocks from "src/sections/stocks/total-warehouse-stocks";

const Page = () => {
  return (
    <>
      <Head>
        <title>Stocks | NFIC</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container component="main" maxWidth="xl">
          <Grid>
            <WarehouseStocks />
          </Grid>
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;
export default Page;
