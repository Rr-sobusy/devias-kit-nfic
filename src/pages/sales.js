import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import { Box, Container, Typography, Stack, Button , Unstable_Grid2 as Grid} from "@mui/material";
import PlusIcon from "@heroicons/react/24/solid/PlusIcon";
import { SvgIcon } from "@mui/material";
import Head from "next/head";

const Page = () => {
  return (
    <>
      <Head>
        <title>Sales |</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Stack justifyContent="space-between" direction="row">
            <Typography variant="h4">Sales Statistics</Typography>
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
          <Grid marginTop={3} container>
                <Typography>rex</Typography>
          </Grid>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
