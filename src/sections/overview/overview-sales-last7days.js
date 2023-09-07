import React from "react";
import { Card, CardContent, CardHeader } from "@mui/material";
import { Chart } from "src/components/chart";
import PropTypes from "prop-types";

const SalesThisWeek = (props) => {
  const { chartSeries, categories } = props;
  const options = {
    chart: {
      id: "basic-line",
      toolbar: false,
    },
    xaxis: {
      categories: categories,
    },
    labels: {
      style: {
        colors: "#247BA0",
      },
    },
  };
  return (
    <Card sx={{ height: "100%" }}>
      <CardHeader title="Sales this week" />
      <CardContent>
        <Chart series={chartSeries} height={350} options={options} type="line" width="100%" />
      </CardContent>
    </Card>
  );
};

export default SalesThisWeek;

SalesThisWeek.propTypes = {
  chartSeries: PropTypes.array,
  categories: PropTypes.array,
};
