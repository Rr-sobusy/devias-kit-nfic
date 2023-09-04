import React from "react";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import {
  Box,
  Button,
  Container,
  Unstable_Grid2 as Grid,
  Stack,
  Typography,
  SvgIcon,
} from "@mui/material";
import Head from "next/head";
import WarehouseStocks from "src/sections/stocks/total-warehouse-stocks";
import ProductSearch from "src/sections/stocks/product-search";
import ProductTable from "src/sections/stocks/product-table";
import WithStocks from "src/sections/stocks/product-with-stocks";
import TotalProduced from "src/sections/stocks/total-products-produce";
import TotalOutbounded from "src/sections/stocks/total-products-outbounded";

import PlusIcon from "@heroicons/react/24/solid/PlusIcon";

import { useTotalStocks } from "src/hooks/use-total-stocks";
import { useWithStocks } from "src/hooks/use-with-stocks";
import { useProduced } from "src/hooks/use-total-produced";
import { useOutbounded } from "src/hooks/use-total-outbounded";

const Page = (props) => {
const [filterWithStocks,setFilterWithStocks] = React.useState(false)

  // Custom hook
  const totalStocks = useTotalStocks(props.productDatas)
  const withStocks = useWithStocks(props.productDatas)
  const totalProduced = useProduced(props.productionDatas)
  const totalOutbounded = useOutbounded(props.salesDatas)

  // 
  const currentDate = new Date().toLocaleDateString()

  return (
    <>
      <Head>
        <title>Stocks | NFIC</title>
      </Head>
      <Box sx={{ py: 8, flexGrow: 1 }}>
        <Container component="main" maxWidth="xl">
          <Stack direction="row" justifyContent="space-between">
            <Typography variant="h4">Warehouse Statistics</Typography>
            <Button
              onClick={() => alert("ok")}
              startIcon={
                <SvgIcon>
                  <PlusIcon />
                </SvgIcon>
              }
              variant="contained"
            >
              Add Product
            </Button>
          </Stack>
          <Grid spacing={3} sx={{ flexGrow: 1, marginTop: 3 }} container>
            <Grid xs={12} md={6} lg={3}>
              <WarehouseStocks currentDate={currentDate} value={totalStocks} />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <WithStocks currentDate={currentDate} value={withStocks.length} />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <TotalProduced value={totalProduced} beginningDate={props.productionDatas[0].production_date} />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <TotalOutbounded value={totalOutbounded} beginningDate={props.salesDatas[props.salesDatas.length - 1].createdAt} />
            </Grid>
          </Grid>
          <Stack spacing={3} marginTop={2}>
            <ProductSearch />
            <ProductTable productDatas={props.productDatas} />
          </Stack>
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;
export default Page;

export async function getServerSideProps() {
  const datas = await fetch("http://192.168.1.100:3003/api/getproducts");
  const productDatas = await datas.json();

  const productionData = await fetch('http://192.168.1.100:3003/api/getproductiondatas')
  const productionDatas  = await productionData.json()

  const salesData = await fetch('http://192.168.1.100:3003/api/getsales')
  const salesDatas = await salesData.json()
  return {
    props: { productDatas, productionDatas , salesDatas},
  };
}
