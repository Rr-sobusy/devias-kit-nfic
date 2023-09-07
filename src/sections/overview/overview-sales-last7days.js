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
    yaxis:{
        labels: {
            formatter: (value) => (value > 0 ? `${(value / 1000).toFixed(2)} Tons` : `${value}`),
            offsetX: -10,
          },
    }
    ,
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
