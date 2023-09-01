import React from "react";
import Head from "next/head";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import {
  Box,
  Container,
  Typography,
  Unstable_Grid2 as Grid,
  Stack,
  Button,
  SvgIcon,
} from "@mui/material";
import TotalSold from "src/sections/sales/sales-card";

/**** Hero icons****** */

import CurrencyDollarIcon from "@heroicons/react/24/solid/CurrencyDollarIcon";
import PlusIcon from "@heroicons/react/24/solid/PlusIcon";

const Page = () => {
  return (
    <>
      <Head>
        <title>Sales |</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Stack direction="row" justifyContent="space-between">
            <Typography variant="h4">Sales Stats</Typography>
            <Button
              startIcon={
                <SvgIcon>
                  <PlusIcon />
                </SvgIcon>
              }
              variant="contained"
            >
              Add Sales
            </Button>
          </Stack>
          <Grid mt={3} spacing={3} container>
            <Grid xs={12} md={6} lg={3}>
              <TotalSold
                title="Products Sold today"
                iconElement={<CurrencyDollarIcon />}
                value="100"
              />
            </Grid>
          </Grid>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
