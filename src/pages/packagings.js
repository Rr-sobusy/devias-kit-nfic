import { Box, Button, Container, Stack, Typography, Tabs, Tab, Divider } from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import { useQuery } from "@tanstack/react-query";
import PropTypes from "prop-types";
import { PackagingStocks } from "src/sections/packagings/packaging-stocks";
import { DeliveryTable } from "src/sections/packagings/packaging-delivery-table";
import PackagingReleased from "src/sections/packagings/packaging-released-table";
import PackagingReturned from "src/sections/packagings/packaging-returned-table";

function CustomTabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

CustomTabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
}

const Page = () => {
  /**
   * * Fetch the datas coming from API - Current Stocks of packaging
   */
  const { data: packagingDatas } = useQuery({
    queryKey: ["packagings"],
    queryFn: async () => {
      const queryResult = await fetch(`${process.env.SERVER_ENDPOINT}/packaging`).then((res) =>
        res.json()
      );
      return queryResult;
    },
  });

  /**
   * * Local states associated of handling the controls of mui tab
   */

  const [value, setValue] = React.useState(0);

  const handleChange = (_, newValue) => {
    setValue(newValue);
  };

  return (
    <>
      <Head>
        <title>Packagings Section</title>
      </Head>
      <Box sx={{ flexGrow: 1, py: 8 }}>
        <Container component="main" maxWidth="xl">
          <Stack>
            <Typography variant="h4">Packagings</Typography>
          </Stack>
          <Box>
            <Box marginTop={2} sx={{ borderBottom: 1, borderColor: "divider" }}>
              <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                <Tab label="Stocks" {...a11yProps(0)} />
                <Tab label="Deliveries" {...a11yProps(1)} />
                <Tab label="Released" {...a11yProps(2)} />
                <Tab label="Returned" {...a11yProps(3)} />
                <Tab label="Adjustments" {...a11yProps(4)} />
              </Tabs>
            </Box>
            <CustomTabPanel value={value} index={0}>
              <PackagingStocks packagingDatas={packagingDatas} />
            </CustomTabPanel>
            <CustomTabPanel value={value} index={1}>
              <DeliveryTable packagingDatas={packagingDatas} />
            </CustomTabPanel>
            <CustomTabPanel value={value} index={2}>
              <PackagingReleased packagingDatas={packagingDatas} />
            </CustomTabPanel>
            <CustomTabPanel value={value} index={3}>
              <PackagingReturned packagingDatas={packagingDatas} />
            </CustomTabPanel>
            <CustomTabPanel value={value} index={4}>
              Item five
            </CustomTabPanel>
            <Divider />
          </Box>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (props) => <DashboardLayout>{props}</DashboardLayout>;

export default Page;
