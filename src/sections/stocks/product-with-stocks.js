import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import React from "react";
import Bag from "@heroicons/react/24/solid/ShoppingBagIcon";
import Proptypes from "prop-types";
const WithStocks = ({ value, currentDate }) => {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack spacing={3} direction="row" justifyContent="space-between">
          <Stack spacing={2}>
            <Typography color="text.secondary" variant="overline">
              Products with stocks
            </Typography>
            <Typography variant="h4">{value}</Typography>
            <Typography variant="caption" color="text.secondary">
              As of {currentDate}
            </Typography>
          </Stack>
          <Avatar sx={{ bgcolor: "#EF9595", height: 56, width: 56 }}>
            <SvgIcon>
              <Bag />
            </SvgIcon>
          </Avatar>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default WithStocks;

WithStocks.propTypes = {
  value: Proptypes.number,
  currentDate: Proptypes.string,
};
