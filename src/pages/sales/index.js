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

/**** Hero icons****** */

import CurrencyDollarIcon from "@heroicons/react/24/solid/CurrencyDollarIcon";
import PlusIcon from "@heroicons/react/24/solid/PlusIcon";
import { LucideUnlink } from "lucide-react";

const Page = () => {
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
              {" "}
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
            <Grid xs={12} md={6} lg={6}>
              <TopPerformer />
            </Grid>
          </Grid>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;
