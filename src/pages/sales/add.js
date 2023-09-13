import React, { useState } from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import Head from "next/head";
import Link from "next/link";
import {
  Box,
  Container,
  Typography,
  SvgIcon,
  Card,
  CardHeader,
  Divider,
  CardContent,
  Stack,
  Unstable_Grid2 as Grid,
  CardActionArea,
} from "@mui/material";
import { Button as UIButton } from "src/ui-components/ui/button";
import SelectDropdown from "src/components/select";
import { Input } from "src/ui-components/ui/input";
/******* Hero Icons ***** */
import Back from "@heroicons/react/24/solid/ArrowDownLeftIcon";

const initialStates = { id: 1, productName: "", quantity: 0 };
const Page = () => {
  const [orderItems, setOrderItems] = useState([initialStates]);

  const changeHandler = (e)=>{
        alert(e)
  }
  return (
    <>
      <Head>
        <title>Sales | Add</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container maxWidth="xl" component="main">
          <Stack spacing={2} alignItems="center" direction="row">
            <Typography variant="h4">Add New Sales</Typography>
            <Link href="/sales">
              <UIButton variant="outline">
                <span>
                  <SvgIcon sx={{ height: 15, width: 15, marginRight: 1 }}>
                    <Back />
                  </SvgIcon>
                  Back to sales
                </span>
              </UIButton>
            </Link>
          </Stack>
          <Card sx={{ marginTop: 4 }}>
            <CardHeader
              title="Order Details"
              subheader="Input order details such as customer name, product name and quantity"
            />
            <Divider />
            <CardContent>
              {/***** Customer Name Dropdown ******* */}
              <Stack spacing={0.5}>
                <Typography className="pl-1 mb-3" variant="subtitle2">
                  Customer Name
                </Typography>
                <SelectDropdown
                  dropdownValues={[{ label: "noel africa", value: "noel africa" }]}
                  className="h-[3.25rem] w-full md:w-1/4 lg:w-1/2"
                />
              </Stack>

              {/* *************** Order Items details********************* */}
              <Grid marginTop={4} container>
                <Grid lg={6} md={6} xs={6}>
                  <Typography variant="subtitle2">Product Name</Typography>
                </Grid>
                <Grid lg={6} md={6} xs={6}>
                  <Typography variant="subtitle2">Quantityi</Typography>
                </Grid>
              </Grid>
              {orderItems.map((values, index) => (
                <Box>
                  <Grid spacing={1} container>
                    {/* ***************Product Name ********************/}
                    <Grid lg={6} md={6} xs={6}>
                      <SelectDropdown
                        onChange={()=>changeHandler(index)}
                        className="h-[3.25rem]"
                        placeholder="Select Product"
                        dropdownValues={[
                          { label: "rex", value: "rex" },
                          {
                            label: "randy",
                            value: "hernandez",
                          },
                        ]}
                      />
                    </Grid>
                    {/* *****************Item quantity ******************* */}
                    <Grid lg={6} md={6} xs={6}>
                      <Input
                        type="number"
                        placeholder="Enter quantity"
                        className="w-full h-[3.25rem]"
                      />
                    </Grid>
                  </Grid>
                </Box>
              ))}
              <Box component="div">
                <Stack justifyContent="flex-end" marginTop={4} gap={1} direction="row">
                  <UIButton
                    onClick={() =>
                      setOrderItems((prev) => [...prev, { productName: "", quantity: 0 }])
                    }
                    variant="outline"
                  >
                    Add row
                  </UIButton>
                  <UIButton>Create Sales</UIButton>
                </Stack>
              </Box>
            </CardContent>
          </Card>
        </Container>
      </Box>
    </>
  );
};

export default Page;

Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;
