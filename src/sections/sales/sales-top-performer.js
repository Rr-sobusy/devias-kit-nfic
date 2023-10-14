import React from "react";
import PropTypes from "prop-types";
import { Avatar, Card, CardContent, Divider, Typography } from "@mui/material";
import { useTheme } from "@mui/material";
import { Chart } from "src/components/chart";

const TopPerformer = (props) => {
  const { value, sx, title, bgColor } = props;
  const theme = useTheme();

  const chartOptions = {
    chart: {
      height: 350,
      stacked: false,
      background:"transparent"
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
    colors: [theme.palette.primary.main],
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "smooth",
    },
    xaxis: {
      type: "string",
    },
    yaxis: {
      labels: {
        formatter: (value) => (value > 0 ? `${(value / 1000).toFixed(2)} Tons` : `${value}`),
        offsetX: -10,
      },
    },
    tooltip: {
      x: {
        format: "string",
      },
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
              data: [31, 40, 28, 51, 60],
            },
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
};

export default TopPerformer;
