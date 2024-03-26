import React, {useState} from "react";
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
  Skeleton
} from "@mui/material";
import TopPerformer from "src/sections/sales/sales-top-performer";
import Link from "next/link";
import SalesTable from "src/sections/sales/sales-table";
import { useQuery } from "@tanstack/react-query";
import TopCustThisMonth from "src/sections/sales/top-performing-thismonth";


/**** Hero icons****** */

import PlusIcon from "@heroicons/react/24/solid/PlusIcon";

const Page = (props) => {
  const { topCustThisMonth } = props;
  const { data , isFetching} = useQuery({
    queryKey: ['sales'],
    queryFn:  async () => {
     return fetch(`${process.env.SERVER_ENDPOINT}/sales`).then((res) => res.json());
    },
    refetchOnWindowFocus: false
  });

  return (
    <>
      <Head>
        <title>Sales |</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Stack direction="row" justifyContent="space-between">
            <Stack>
              <Typography variant="h4">Sales Statistics</Typography>
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
              <TopPerformer salesDatas={props.topSoldThisMonth} />
            </Grid>
            <Grid xs={12} md={12} lg={4}>
              <TopCustThisMonth topCustomers={topCustThisMonth} />
            </Grid>
          </Grid>
          <Grid marginTop={4}>
            {isFetching ? (
              <Stack justifyContent="center" spacing={1}>
                {/* For other variants, adjust the size with `width` and `height` */}
                <Skeleton variant="circular" width={40} height={40} />
                <Skeleton variant="rectangular" width={210} height={60} />
                <Skeleton variant="rounded" width={210} height={60} />
              </Stack>
            ) : (
              <SalesTable salesDatas={data} />
            )}
          </Grid>
        </Container>
      </Box>
    </>
  );
};

export async function getServerSideProps() {
  const topCustThisMonth = await fetch(`${process.env.SERVER_ENDPOINT}/customers/bestforentiremonth/2024`).then(res=>res.json())
 
  //* Fetch from API the datas for five best product for the entire month
  const topSoldThisMonth = await fetch(`${process.env.SERVER_ENDPOINT}/sales/bestproductthismonth`).then(res=>res.json())
  return {
    props: {
      topCustThisMonth,
      topSoldThisMonth
    },
  };
}

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
