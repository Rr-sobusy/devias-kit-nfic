import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import React from "react";
import HomeICon from "@heroicons/react/24/solid/HomeIcon";

const WithStocks = () => {
  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack spacing={3} direction="row" justifyContent="space-between">
          <Stack spacing={2}>
            <Typography color="text.secondary" variant="overline">
              Products with stocks
            </Typography>
            <Typography variant="h4">10</Typography>
            <Typography variant="caption" color="text.secondary">
              As of 08/23/2023{" "}
            </Typography>
          </Stack>
          <Avatar sx={{ bgcolor: "#EF9595", height: 56, width: 56 }}>
            <SvgIcon>
              <HomeICon />
            </SvgIcon>
          </Avatar>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default WithStocks;
