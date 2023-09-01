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
  Divider,
} from "@mui/material";
import Head from "next/head"
import { Input } from "src/ui-components/ui/input";
import { Button as Button2 } from "src/ui-components/ui/button";
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
            <CardHeader subheader="Input the customer name details" title="Customer details" />
            <Divider />
            <form onSubmit={handleSubmit(() => console.log(errors))}>
              <CardContent>
                <Stack direction="row" gap={3}>
                  <Stack flexGrow={1}>
                    <Input
                      {...register("firstName",{required: true})}
                      type="text"
                      placeholder="First Name"
                      className={`h-[3.5rem]`}
                    />
                    {errors.firstName && <p className="mx-1 mt-2 text-red-400">First Name required !</p>}
                  </Stack>
                  <Stack flexGrow={1}>
                  <Input
                      {...register("lastName",{required: false})}
                      type="text"
                      placeholder="First Name"
                      className={`h-[3.5rem]`}
                    />
                  </Stack>
                </Stack>
                <CardActions sx={{ justifyContent: "flex-end", marginTop: 6, gap: 2 }}>
                  <Link href={`/customers`}>
                    <Button2 variant="outline">Cancel</Button2>
                  </Link>
                  <Button2 type="submit">Create</Button2>
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
