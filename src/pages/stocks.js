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
  const [filterWithStocks, setFilterWithStocks] = React.useState(false);
  const [searchString, setSearchString] = React.useState("");

  // Custom hook
  const totalStocks = useTotalStocks(props.productDatas);
  const withStocks = useWithStocks(props.productDatas);
  const totalProduced = useProduced(props.productionDatas);
  const totalOutbounded = useOutbounded(props.salesDatas);

  //
  const currentDate = new Date().toLocaleDateString();
  const filteredProductByStocks = props.productDatas?.filter(
    ({ current_stocks }) => current_stocks !== "0"
  );
  const filteredProductByName = props.productDatas?.filter(
    ({ product_name }) => product_name === searchString
  );
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
              <TotalProduced
                value={totalProduced}
                beginningDate={new Date(
                  props.productionDatas[0].production_date
                ).toLocaleDateString()}
              />
            </Grid>
            <Grid xs={12} md={6} lg={3}>
              <TotalOutbounded
                value={totalOutbounded}
                beginningDate={new Date(
                  props.salesDatas[props.salesDatas.length - 1].createdAt
                ).toLocaleDateString()}
              />
            </Grid>
          </Grid>
          <Stack spacing={3} marginTop={2}>
            <ProductSearch
              searchHandler={(params) => setSearchString(params)}
              toggleHandler={() => setFilterWithStocks((prev) => !prev)}
            />
            <ProductTable
              productDatas={filterWithStocks ? filteredProductByStocks : props.productDatas}
            />
          </Stack>
        </Container>
      </Box>
    </>
  );
};
Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;
export default Page;

export async function getServerSideProps() {
  try {
    // Fetch product datas coming from API
    const productDatas = await fetch(`${process.env.SERVER_ENDPOINT}/products`).then((res) =>
      res.json()
    );
    // Fetch production datas coming from API
    const productionDatas = await fetch(`${process.env.SERVER_ENDPOINT}/products/productiondatas`).then(
      (res) => res.json()
    );
    // Fetch sales datas coming from API
    const salesDatas = await fetch(`${process.env.SERVER_ENDPOINT}/sales`).then((res) => res.json());
    return {
      props: { productDatas, productionDatas, salesDatas },
    };
  } catch (err) {
    console.error(err);
  }
}
