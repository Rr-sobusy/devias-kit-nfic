import React, { useState } from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import Head from "next/head";
import Link from "next/link";
import { useRouter } from "next/router";
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
} from "@mui/material";
import { useQueryClient, useMutation } from "@tanstack/react-query";
import { Button as UIButton } from "src/ui-components/ui/button";
import SelectDropdown from "src/components/select";
import { Input } from "src/ui-components/ui/input";
/******* Hero Icons ***** */
import Back from "@heroicons/react/24/solid/ArrowDownLeftIcon";
import Delete from "@heroicons/react/24/solid/TrashIcon";

const initialStates = { id: 1, productId: "", quantity: 0 };

const Page = (props) => {
  // Instantiators
  const router = useRouter();

  // Local states
  const [customerId, setCustomerId] = useState(0);
  const [orderItems, setOrderItems] = useState([initialStates]);

  const queryClient = useQueryClient();

  // Check the orderItems array if the is no values set to zero for validation
  function isNoNulls(arr) {
    let noNulls = true;
    arr.map(({ productId, quantity }) => {
      if (productId === 0 || quantity === 0) {
        return (noNulls = false);
      }
    });
    return noNulls;
  }

  // Add row handler -- Adding new row to filled up
  const addNewRow = () => {
    setOrderItems((prev) => [
      ...prev,
      { id: prev[prev.length - 1].id + 1, productId: 0, quantity: 0 },
    ]);
  };

  // Remove row that corresponds to id of clicked button
  const deleteRow = (id) => {
    const newRow = orderItems.filter((rows) => rows.id !== id);
    if (orderItems.length > 1) {
      setOrderItems(newRow);
    }
  };

  // Event handler for changing the product column and mapped it to exact list
  const productChangeHandler = (event, id) => {
    let arr = [...orderItems];
    const toChange = arr.findIndex((item) => item.id === id);
    const objectToEdit = arr[toChange];
    objectToEdit.productId = event;
    arr[toChange] = objectToEdit;
    setOrderItems(arr);
  };

  // Event handler for changing the quantity column and mapped it to exact list
  const quantityChangeHandler = (event, id) => {
    let arr = [...orderItems];
    const toChange = arr.findIndex((item) => item.id === id);
    const newVale = arr[toChange];
    newVale.quantity = Number(event.target.value);
    arr[toChange] = newVale;
    setOrderItems(arr);
  };

  // Handle the submittion of Orders then navigate to sales route
  const submitHandler = async () => {
    if (isNoNulls(orderItems) === false || customerId === 0) {
      alert("Validate missing fields!");
    } else {
      mutation.mutate();
      router.push("/sales");
    }
  };
  const mutation = useMutation({
    mutationFn: async () => {
      const newOrder = orderItems.map((values) => {
        return {
          product_id: values.productId,
          quantity: values.quantity,
        };
      });
      const result = await fetch(`${process.env.SERVER_ENDPOINT}/sales`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        mode: "cors",
        body: JSON.stringify({ customer_id: customerId, sales_items: newOrder }),
      });
      return result;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["salesData"] });
    },
  });
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
                  onChange={(e) => setCustomerId(e)}
                  placeholder="Select Customer"
                  dropdownValues={props.customerDatas.map(({ customer_id, customer_name }) => {
                    return {
                      label: customer_name,
                      value: customer_id,
                    };
                  })}
                  className="h-[3.25rem] w-full md:w-1/4 lg:w-1/2"
                />
              </Stack>

              {/* *************** Order Items details********************* */}
              <Grid spacing={2} marginTop={3} container>
                <Grid lg={6} md={6} xs={6}>
                  <Typography variant="subtitle2">Product Name</Typography>
                </Grid>
                <Grid lg={6} md={6} xs={6}>
                  <Typography variant="subtitle2">Quantity</Typography>
                </Grid>
              </Grid>
              {orderItems.map((values, index) => (
                <Box key={index}>
                  <Grid spacing={2} container>
                    {/* ***************Product Name ********************/}
                    <Grid lg={6} md={6} xs={6}>
                      <SelectDropdown
                        name="dropDown"
                        onChange={(event) => productChangeHandler(event, values.id)}
                        className="h-[3.25rem]"
                        placeholder="Select Product"
                        dropdownValues={props.productDatas.map(({ product_id, product_name }) => {
                          return {
                            label: product_name,
                            value: product_id,
                          };
                        })}
                      />
                    </Grid>
                    {/* *****************Item quantity ******************* */}
                    <Grid lg={5} md={5} xs={5}>
                      <Input
                        value={orderItems.quantity}
                        onChange={(event) => quantityChangeHandler(event, values.id)}
                        type="number"
                        placeholder="Enter quantity"
                        className="w-full h-[3.25rem]"
                      />
                    </Grid>
                    <Grid lg={1} md={1} xs={1}>
                      <UIButton
                        onClick={() => deleteRow(values.id)}
                        className="h-[3.25rem]"
                        variant="outline"
                      >
                        <SvgIcon>
                          <Delete />
                        </SvgIcon>
                      </UIButton>
                    </Grid>
                  </Grid>
                </Box>
              ))}
              <Box component="div">
                <Stack justifyContent="flex-end" marginTop={4} gap={1} direction="row">
                  <UIButton onClick={addNewRow} variant="outline">
                    Add row
                  </UIButton>
                  <UIButton onClick={submitHandler}>Create Sales</UIButton>
                </Stack>
              </Box>
            </CardContent>
          </Card>
        </Container>
      </Box>
    </>
  );
};

export async function getServerSideProps() {
  // Fetch Product Datas
  const productDatas = await fetch(`${process.env.SERVER_ENDPOINT}/products`).then((res) =>
    res.json()
  );

  // Fetch Customer Datas
  const customerDatas = await fetch(`${process.env.SERVER_ENDPOINT}/customers`).then((res) =>
    res.json()
  );
  return {
    props: {
      productDatas,
      customerDatas,
    },
  };
}

export default Page;

Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;
