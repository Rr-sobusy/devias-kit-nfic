import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import React from "react";
import HomeICon from "@heroicons/react/24/solid/HomeIcon";
import Proptypes from 'prop-types'

const WarehouseStocks = ({sx,value,currentDate}) => {
  return (
    <Card sx={{height: '100%'}} >
      <CardContent>
        <Stack alignItems="flex-start" spacing={3} direction="row" justifyContent="space-between">
          <Stack spacing={2}>
            <Typography color="text.secondary" variant="overline">
              Total W.H Stocks
            </Typography>
            <Typography variant="h4">{`${value} T`}</Typography>
            <Typography sx={{ textTransform: "revert" }} variant="caption" color="text.secondary">
              As of {currentDate}
            </Typography>
          </Stack>
          <Avatar sx={{ bgcolor: "#45FFCA", height: 56, width: 56 }}>
            <SvgIcon>
              <HomeICon />
            </SvgIcon>
          </Avatar>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default WarehouseStocks;

WarehouseStocks.propTypes = {
        value: Proptypes.number,
        sx: Proptypes.string,
        currentDate: Proptypes.string
}


