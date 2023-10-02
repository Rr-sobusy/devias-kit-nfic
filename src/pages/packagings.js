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
              <PackagingStocks />
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
