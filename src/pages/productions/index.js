import { Box, Button, Container, Stack, Typography } from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";

const Page = () => {
  return <>
  <Head>
    <title>Production ||</title>
  </Head>
  <Box sx={{flexGrow: 1, py: 8}}>
    <Container component="main" maxWidth="xl">
     <Stack direction="row" justifyContent="space-between">
      <Typography variant="h4">Production Stats</Typography>
      <Button variant="contained">Add proudctions</Button>
     </Stack>
    </Container>
  </Box>
  </>
};

Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;

export default Page;
