import {
  Box,
  Button,
  Container,
  Stack,
  Typography,
  Unstable_Grid2 as Grid,
  Tabs,
  Tab,
  Divider,
} from "@mui/material";
import Head from "next/head";
import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import ProductionTable from "src/sections/productions/production-table";
import { useQuery } from "@tanstack/react-query";
import PropTypes from "prop-types";

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
  const { data: productionDatas } = useQuery({
    queryKey: ["productionDatas"],
    queryFn: async () => {
      const queryResult = await fetch(
        `${process.env.SERVER_ENDPOINT}/products/productiondatas`
      ).then((res) => res.json());
      return queryResult;
    },
  });
  return (
    <>
      <Head>
        <title>Production ||</title>
      </Head>
      <Box sx={{ flexGrow: 1, py: 2 }}>
        <Container component="main" maxWidth="xl">
          <Box>
            <Box marginTop={2} sx={{ borderBottom: 1, borderColor: "divider" }}>
              <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                <Tab label="Production" {...a11yProps(0)} />
                <Tab label="Repros" {...a11yProps(1)} />
              </Tabs>
            </Box>
            <CustomTabPanel value={value} index={0}>
              <Stack direction="row" justifyContent="space-between">
                <Typography variant="h4">Production Stats</Typography>
                <Stack gap={1} direction="row">
                  <Button variant="outlined">Mock used packaging</Button>
                  <Button variant="contained">Add proudctions</Button>
                </Stack>
              </Stack>
              <Grid marginTop={5} container>
                <Grid lg={12}>
                  <ProductionTable productionDatas={productionDatas} />
                </Grid>
              </Grid>
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
