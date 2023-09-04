import React from "react";
import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import Truck from "@heroicons/react/24/solid/TruckIcon";
import Proptypes from "prop-types";

const TotalOutbounded = ({ value, beginningDate }) => {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack spacing={3} direction="row" justifyContent="space-between">
          <Stack spacing={2}>
            <Typography color="text.secondary" variant="overline">
              Products Outbounded
            </Typography>
            <Typography variant="h4">{value} KT</Typography>
            <Typography variant="caption" color="text.secondary">
              Since {beginningDate}
            </Typography>
          </Stack>
          <Avatar sx={{ bgcolor: "#FFA1F5", height: 56, width: 56 }}>
            <SvgIcon>
              <Truck />
            </SvgIcon>
          </Avatar>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default TotalOutbounded;
TotalOutbounded.propTypes = {
  beginningDate: Proptypes.string,
  value: Proptypes.number,
};
