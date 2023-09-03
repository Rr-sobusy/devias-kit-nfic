import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import {
  Box,
  Button,
  Container,
  Unstable_Grid2 as Grid,
  Stack,
  Typography,
  SvgIcon,
} from "@mui/material";
import Head from "next/head";
import WarehouseStocks from "src/sections/stocks/total-warehouse-stocks";
import ProductSearch from "src/sections/stocks/product-search";
import ProductTable from "src/sections/stocks/product-table";
import WithStocks from "src/sections/stocks/product-with-stocks";
import TotalProduced from "src/sections/stocks/total-products-produce";

import PlusIcon from "@heroicons/react/24/solid/PlusIcon";

const Page = () => {
  return (
    <>
      <Head>
        <title>Stocks | NFIC</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container component="main" maxWidth="xl">
          <Stack direction="row" justifyContent="space-between">
            <Typography variant="h4">Warehouse Stats</Typography>
            <Button
              startIcon={
                <SvgIcon>
                  <PlusIcon />
                </SvgIcon>
              }
              variant="contained"
            >
              Add Product
            </Button>
          </Stack>
          <Grid spacing={5} sx={{ flexGrow: 1, marginTop: 3 }} container>
            <Grid xs={12} md={6} lg={3}>
              <WarehouseStocks />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <WithStocks />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <TotalProduced/>
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <WarehouseStocks />
            </Grid>
          </Grid>
          <Stack spacing={3} marginTop={2}>
            <ProductSearch />
            <ProductTable productDatas={[{productId:1,productName:'Doggy Woggy Adult'}]} />
          </Stack>
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;
export default Page;
