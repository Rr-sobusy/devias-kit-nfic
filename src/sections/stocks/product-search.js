import { Card, CardContent, Portal, Stack, Switch, Typography } from "@mui/material";
import React from "react";
import { Input } from "src/ui-components/ui/input";
import PropTypes from "prop-types";

const ProductSearch = (props) => {
  const { toggleHandler, searchHandler } = props;
  return (
    <Card>
      <CardContent>
        <Stack spacing={2}>
          <Input
            className="h-[3.5rem] md:w-1/2"
            placeholder="Search for product name"
            type="text"
            onChange={(e) => searchHandler(e.target.value)}
          />
          <Stack alignItems="center" direction="row">
            <Typography>Filter product w/ stocks only</Typography>
            <Switch onChange={toggleHandler} />
          </Stack>
        </Stack>
      </CardContent>
    </Card>
  );
};

export default ProductSearch;

ProductSearch.propTypes = {
  toggleHandler: PropTypes.func,
  searchHandler: PropTypes.func,
};
