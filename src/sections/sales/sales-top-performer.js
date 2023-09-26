import React from "react";
import PropTypes from "prop-types";
import { Avatar, Card, CardContent, Divider, Typography } from "@mui/material";
import { Chart } from "src/components/chart";

const TopPerformer = (props) => {
  const { value, sx, title, bgColor } = props;

  const chartOptions = {
    chart: {
      height: 350,
      type: "area",
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "smooth",
    },
    xaxis: {
      type: "string",
      categories: [
        "April",
        "April",
        "April",
        "April",
      ],
    },
    tooltip: {
      x: {
        format: "string",
      },
    },
  };

  return (
    <Card sx={sx}>
      <CardContent>
        <Typography color="text.secondary" variant="overline">
          Last 7-day best moved
        </Typography>
        <Chart
          height={302}
          type="area"
          series={[
            {
              name: "series1",
              data: [31, 40, 28, 51],
            },
            {
              name: "series2",
              data: [11, 32, 45, 32],
            },
            {
              name: "series2",
              data: [130, 45, 70, 120],
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
