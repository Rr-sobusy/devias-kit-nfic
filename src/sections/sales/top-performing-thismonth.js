import { Avatar, Card, CardContent, CardHeader, Divider, Typography, Stack } from "@mui/material";
import React from "react";

const TopCustThisMonth = ({ topCustomers = [] }) => {
  return (
    <Card sx={{ height: "100%" }}>
      <CardHeader title="Top performers this month" subheader="Lorem ipsum dolor sit amet" />
      <Divider />
      <CardContent>
        <Stack spacing={3}>
          {topCustomers.map(({ customer_id, customer_name, total_bought }, index) => (
            <Stack key={customer_id} spacing={2} alignItems="center" direction="row">
              <Avatar
                sx={{ height: 52, width: 52, borderRadius: 1, bgcolor: "#FF9B50" }}
                variant="square"
              >
                {index + 1}
              </Avatar>
              <Stack>
                <Typography variant="h6">{customer_name}</Typography>
                <Typography color="text.secondary" variant="subtitle2">
                  w/ total of{" "}
                  <span style={{ color: "#3A86FF" }}>{(Number(total_bought) / 1000).toFixed(2)} tons</span> of
                  purchases this month
                </Typography>
              </Stack>
            </Stack>
          ))}
        </Stack>
      </CardContent>
    </Card>
  );
};

export default TopCustThisMonth;
