import React from "react";
import PropTypes from "prop-types";
import { Avatar, Card, CardContent, Divider, Typography } from "@mui/material";
import { useTheme } from "@mui/material";
import { Chart } from "src/components/chart";

const TopPerformer = (props) => {
  const { value, sx, title, bgColor, salesDatas = [] } = props;
  const theme = useTheme();

  const chartOptions = {
    chart: {
      height: 350,
      stacked: false,
      background: "transparent",
    },
    grid: {
      borderColor: theme.palette.divider,
      strokeDashArray: 2,
      xaxis: {
        lines: {
          show: false,
        },
      },
      yaxis: {
        lines: {
          show: true,
        },
      },
    },
    colors: ["#06D6A0"],
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "smooth",
    },
    xaxis: {
      type: "string",
      categories: salesDatas.map(({ product_name }) => product_name),
    },
    yaxis: {
      labels: {
        formatter: (value) => (value > 0 ? `${value} Tons` : `${value}`),
        offsetX: -10,
        style: {
          colors: theme.palette.text.secondary,
        },
      },
    },
    tooltip: {
    y: {
    formatter: function(value, { series, seriesIndex, dataPointIndex, w }) {
      return value
    }
  }
    },
    labels: {
      style: {
        colors: "#247BA0",
      },
    },
  };

  return (
    <Card sx={sx}>
      <CardContent>
        <Typography color="text.secondary" variant="overline">
          Trend Products for entire month
        </Typography>
        <Chart
          height={302}
          type="bar"
          series={[
            {
              name: "Outbounded this month",
              data: salesDatas.map(({summed})=>Number(summed) / 1000),
            }
          ]}
          options={chartOptions}
          width="100%"
        />
      </CardContent>
      <Divider />
    </Card>
  );
};

TopPerformer.propTypes = {
  value: PropTypes.string,
  title: PropTypes.string,
  bgColor: PropTypes.string,
  salesDatas: PropTypes.array
};

export default TopPerformer;
