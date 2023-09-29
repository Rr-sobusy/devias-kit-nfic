import { Box, Button, Container, Stack, Typography, Unstable_Grid2 as Grid } from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import ProductionTable from "src/sections/productions/production-table";
import { useQuery } from "@tanstack/react-query";

const Page = () => {
  const { data: productionDatas } = useQuery({
    queryKey: ["productionDatas"],
    queryFn: async () => {
      const queryResult = await fetch(
        `${process.env.SERVER_ENDPOINT}/products/productiondatas`
      ).then((res) => res.json());
      return queryResult;
    },
  });
  return (
    <>
      <Head>
        <title>Production ||</title>
      </Head>
      <Box sx={{ flexGrow: 1, py: 8 }}>
        <Container component="main" maxWidth="xl">
          <Stack direction="row" justifyContent="space-between">
            <Typography variant="h4">Production Stats</Typography>
            <Button variant="contained">Add proudctions</Button>
          </Stack>
          <Grid marginTop={5} container>
            <Grid lg={12}>
              <ProductionTable productionDatas={productionDatas} />
            </Grid>
          </Grid>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;

export default Page;
