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
import TopPerformer from "src/sections/sales/sales-top-performer";
import Link from "next/link";
import SalesTable from "src/sections/sales/sales-table";
import SalesFilter from "src/sections/sales/sales-filter";
import TopCustThisMonth from "src/sections/sales/top-performing-thismonth";

/**** Hero icons****** */

import PlusIcon from "@heroicons/react/24/solid/PlusIcon";

const Page = (props) => {
  const { salesDatas } = props;
  return (
    <>
      <Head>
        <title>Sales |</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Stack direction="row" justifyContent="space-between">
            <Stack>
              <Typography variant="h4">Sales Stats</Typography>
            </Stack>
            <Link href="sales/add">
              <Button
                onClick={() => console.log(process.env.SERVER_ENDPOINT)}
                startIcon={
                  <SvgIcon>
                    <PlusIcon />
                  </SvgIcon>
                }
                variant="contained"
              >
                Add Sales
              </Button>
            </Link>
          </Stack>
          <Grid mt={3} spacing={3} container>
            <Grid xs={12} md={12} lg={8}>
              <TopPerformer />
            </Grid>
            <Grid xs={12} md={12} lg={4}>
              <TopCustThisMonth />
            </Grid>
          </Grid>
         <Grid marginTop={4}>
         <SalesTable salesDatas={salesDatas} />
         </Grid>
        </Container>
      </Box>
    </>
  );
};

export async function getServerSideProps() {
  const salesDatas = await fetch(`${process.env.SERVER_ENDPOINT}/sales`).then((res) => res.json());
  return {
    props: {
      salesDatas,
    },
  };
}

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
