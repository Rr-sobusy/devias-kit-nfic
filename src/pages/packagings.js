import { Box, Button, Container, Stack, Typography, Tabs, Tab, Divider } from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import PropTypes from "prop-types";
import { PackagingStocks } from "src/sections/packagings/packaging-stocks";

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

const packagingDatas = [
  {
      "packaging_id": "13",
      "packaging_name": "DWA LINER SACKS",
      "initial_stocks": 151,
      "total_delivered": 0,
      "total_released": 0,
      "total_returned": 0
  },
  {
      "packaging_id": "9",
      "packaging_name": "DWP LINER SACKS",
      "initial_stocks": 5963,
      "total_delivered": 0,
      "total_released": 0,
      "total_returned": 0
  },
  {
      "packaging_id": "14",
      "packaging_name": "PIGLET BOOSTER",
      "initial_stocks": 3114,
      "total_delivered": 0,
      "total_released": 0,
      "total_returned": 0
  },
  {
      "packaging_id": "12",
      "packaging_name": "PLASTIC 18.5  x 28",
      "initial_stocks": 10812,
      "total_delivered": 0,
      "total_released": 869,
      "total_returned": 0
  },
  {
      "packaging_id": "8",
      "packaging_name": "PLASTIC 22 x 33",
      "initial_stocks": 7916,
      "total_delivered": 0,
      "total_released": 0,
      "total_returned": 0
  },
  {
      "packaging_id": "10",
      "packaging_name": "PLASTIC 24 x 36 (FLEXI)",
      "initial_stocks": 3239,
      "total_delivered": 0,
      "total_released": 2039,
      "total_returned": 0
  },
  {
      "packaging_id": "11",
      "packaging_name": "PLASTIC 24 x 36 (LABO)",
      "initial_stocks": 1179,
      "total_delivered": 0,
      "total_released": 0,
      "total_returned": 0
  }
]

const Page = () => {
  const [value, setValue] = React.useState(0);

  const handleChange = (event, newValue) => {
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
              </Tabs>
            </Box>
            <CustomTabPanel value={value} index={0}>
              <PackagingStocks packagingDatas={packagingDatas} />
            </CustomTabPanel>
            <CustomTabPanel value={value} index={1}>
              Item Two
            </CustomTabPanel>
            <CustomTabPanel value={value} index={2}>
              Item Three
            </CustomTabPanel>
            <CustomTabPanel value={value} index={3}>
              Item four
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
