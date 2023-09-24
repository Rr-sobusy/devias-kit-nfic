import { Avatar, Card, CardContent, CardHeader, Divider, Typography, Stack } from "@mui/material";
import React from "react";

const TopCustThisMonth = () => {
  return (
    <Card>
      <CardHeader title="Top performers this month" subheader="Lorem ipsum dolor amet" />
      <Divider />
      <CardContent>
        <Stack spacing={3}>
          <Stack spacing={2} alignItems="center" direction="row">
            <Avatar
              sx={{ height: 52, width: 52, borderRadius: 1, bgcolor: "#FF9B50" }}
              variant="square"
            >
              1
            </Avatar>
            <Stack>
              <Typography variant="h6">KKM</Typography>
              <Typography color="text.secondary" variant="subtitle2">
                w/ total of <span style={{ color: "#3A86FF" }}>240 tons</span> of purchases this
                month
              </Typography>
            </Stack>
          </Stack>
          <Stack spacing={2} alignItems="center" direction="row">
            <Avatar
              sx={{ height: 52, width: 52, borderRadius: 1, bgcolor: "#FF9B50" }}
              variant="square"
            >
              2
            </Avatar>
            <Stack>
              <Typography variant="h6">Noel Africa</Typography>
              <Typography color="text.secondary" variant="subtitle2">
                w/ total of <span style={{ color: "#3A86FF" }}>240 tons</span> of purchases this
                month
              </Typography>
            </Stack>
          </Stack>
          <Stack alignItems="center" direction="row">
            <Avatar
              sx={{ height: 52, width: 52, borderRadius: 1, bgcolor: "#FF9B50" }}
              variant="square"
            >
              3
            </Avatar>
            <Typography variant="subtitle2">rex</Typography>
          </Stack>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default TopCustThisMonth;
