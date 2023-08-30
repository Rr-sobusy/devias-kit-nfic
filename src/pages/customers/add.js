import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import {
  Box,
  Container,
  Typography,
  Stack,
  Card,
  CardHeader,
  CardContent,
  CardActions,
  TextField,
  Button,
} from "@mui/material";
import Head from "next/head";
import { useForm } from "react-hook-form";
import Link from "next/link";

const Page = () => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();
  return (
    <>
      <Head>
        <title>Customers | Add</title>
      </Head>
      <Box
        sx={{
          flexGrow: 1,
          py: 8,
        }}
        component="main"
      >
        <Container maxWidth="xl">
          <Stack>
            <Typography variant="h4">Add Customer</Typography>
          </Stack>
          <Card sx={{ marginTop: 5 }}>
            <CardHeader title="Enter Customer details" />
            <form onSubmit={handleSubmit((data) => console.log(data))}>
              <CardContent>
                <Stack direction="row" gap={3}>
                  <TextField
                    className=""
                    {...register("firstName", { required: true })}
                    sx={{ flexGrow: 1 }}
                    label="First Name"
                  />
                  <TextField {...register("lastName")} sx={{ flexGrow: 1 }} label="Last Name" />
                </Stack>
                <CardActions sx={{ justifyContent: "flex-end", marginTop: 2, gap: 2 }}>
                  <Link href={`/customers`}>
                    <Button>Cancel</Button>
                  </Link>

                  <Button type="submit" variant="contained">
                    Create
                  </Button>
                </CardActions>
              </CardContent>
            </form>
          </Card>
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;
export default Page;
