import Head from "next/head";
import { Box, Container, Unstable_Grid2 as Grid } from "@mui/material";
import { Layout as DashboardLayout } from "src/layouts/dashboard/layout";
import { TopCustomers } from "src/sections/overview/overview-best-customer";
import SalesThisWeek from "src/sections/overview/overview-sales-last7days";
import { OverviewSales } from "src/sections/overview/overview-sales";
import { OverviewTasksProgress } from "src/sections/overview/overview-tasks-progress";
import { OverviewTotalCustomers } from "src/sections/overview/overview-total-customers";
import { OverviewTotalProfit } from "src/sections/overview/overview-total-profit";
import { OverviewTotalProducts } from "src/sections/overview/overview-total-products";
import { BestMovedProduct } from "src/sections/overview/overview-best-moved-product";

const now = new Date();

const Page = (props) => {
  const sortedSalesThisWeek = props.salesThisWeek
    .map((values, index) => ({ ...values, index }))
    .sort((a, b) => b.index - a.index);

  return (
    <>
      <Head>
        <title>Overview | Devias Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth="xl">
          <Grid container spacing={3}>
            <Grid xs={12} sm={6} lg={3}>
              <OverviewTotalCustomers
                difference={16}
                positive={false}
                sx={{ height: "100%" }}
                value={props.customerStats.length}
              />
            </Grid>
            <Grid xs={12} sm={6} lg={3}>
              <OverviewTotalProducts
                noStocks={
                  props.productDatas.filter(({ current_stocks }) => current_stocks === "0").length
                }
                value={props.productDatas.length}
              />
            </Grid>
            <Grid xs={12} sm={6} lg={3}>
              <OverviewTasksProgress sx={{ height: "100%" }} value={75.5} />
            </Grid>
            <Grid xs={12} sm={6} lg={3}>
              <OverviewTotalProfit sx={{ height: "100%" }} value="__" />
            </Grid>
            <Grid xs={12} lg={8}>
              <OverviewSales
                // categories={salesPerMonth.map(({ month }) => month)}
                categories={props.salesPerMonth.map(({ month }) => month)}
                chartSeries={[
                  {
                    name: "Sales this month",
                    data: props.salesPerMonth.map(
                      ({ total_outbounded }) => Number(total_outbounded) / 1000
                    ),
                  },
                ]}
                sx={{ height: "100%" }}
              />
            </Grid>
            <Grid xs={12} md={6} lg={4}>
              <BestMovedProduct
                chartSeries={props.salesData.map(({ total_sold }) => Number(total_sold) / 1000)}
                labels={props.salesData.map(({ product_name }) => product_name)}
                sx={{ height: "100%", placeItems: "center" }}
              />
            </Grid>
            <Grid xs={12} md={6} lg={4}>
              <SalesThisWeek
                categories={sortedSalesThisWeek.map(({ sales_date }) => sales_date)}
                chartSeries={[
                  {
                    name: "Sales this day",
                    data: sortedSalesThisWeek.map(({ sum }) => sum),
                  },
                ]}
              />
            </Grid>
            <Grid xs={12} md={12} lg={8}>
              <TopCustomers
                categories={props.customerStats?.map(({ customer_name }) => customer_name)}
                chartSeries={[
                  {
                    name: "Volume purchased",
                    data: props.customerStats.map(
                      ({ total_bought }) => Number(total_bought) / 1000
                    ),
                  },
                ]}
                sx={{ height: "100%" }}
              />
            </Grid>
          </Grid>
        </Container>
      </Box>
    </>
  );
};

Page.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default Page;

/**
 * * Fetch though server side
 */

export async function getServerSideProps() {
  try {
    // Fetch Product datas
    const productDatas = await fetch(`${process.env.SERVER_ENDPOINT}/products`).then((res) =>
      res.json()
    );

    // Fetch sales datas coming from API
    const salesData = await fetch(`${process.env.SERVER_ENDPOINT}/products/topsoldproduct`).then(
      (res) => res.json()
    );

    // Fetch sales per month data from API
    const salesPerMonth = await fetch(
      `${process.env.SERVER_ENDPOINT}/sales/salesthisyear/2023`
    ).then((res) => res.json());

    // Fetch customer stats and their volumes per month
    const customerStats = await fetch(
      `${process.env.SERVER_ENDPOINT}/customers/totalvolumebought`
    ).then((res) => res.json());

    const salesThisWeek = await fetch(`${process.env.SERVER_ENDPOINT}/sales/salesthisweek`).then(
      (res) => res.json()
    );
    return {
      props: {
        salesData,
        salesPerMonth,
        customerStats,
        salesThisWeek,
        productDatas,
      },
    };
  } catch (err) {
    console.error(err);
  }
}
