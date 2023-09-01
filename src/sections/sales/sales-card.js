import React from "react";
import PropTypes from "prop-types";
import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";

const TotalSold = (props) => {
  const { value, sx , title , iconElement} = props;
  return (
    <Card sx={sx}>
      <CardContent>
        <Stack alignItems="flex-start" direction="row" justifyContent="space-between" spacing={3}>
          <Stack spacing={1}>
            <Typography color="text.secondary" variant="overline">
             {title}
            </Typography>
            <Typography variant="h4">{`${value} T`}</Typography>
          </Stack>
          <Avatar
            sx={{
              backgroundColor: "primary.main",
              height: 56,
              width: 56,
            }}
          >
            <SvgIcon>
              {iconElement}
            </SvgIcon>
          </Avatar>
        </Stack>
      </CardContent>
    </Card>
  );
};

TotalSold.propTypes = {
  value: PropTypes.string,
  title : PropTypes.string,
  iconElement: PropTypes.node
};

export default TotalSold;
