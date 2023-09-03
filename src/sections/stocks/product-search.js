import { Card, CardContent, Stack, Switch, Typography } from "@mui/material";
import React from "react";
import { Input } from "src/ui-components/ui/input";

const ProductSearch = () => {
  return (
    <Card>
      <CardContent>
        <Stack spacing={2}>
          <Input
            className="h-[3.5rem] md:w-1/2"
            placeholder="Search for product name"
            type="text"
          />
          <Stack alignItems="center" direction="row">
            <Typography>Filter product w/ stocks only</Typography>
            <Switch />
          </Stack>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default ProductSearch;
