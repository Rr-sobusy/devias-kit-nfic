import React from "react";
import PropTypes from "prop-types";
import { Avatar, Card, CardContent, CardHeader, Divider, Stack, SvgIcon, Typography } from "@mui/material";

const TopPerformer = (props) => {
  const { value, sx, title, bgColor } = props;
  return (
    <Card sx={sx}>
        <CardHeader></CardHeader>
      <CardContent>
        <Stack alignItems="flex-start" direction="row" justifyContent="space-between" spacing={3}>
          <Stack spacing={1}>
            <Typography color="text.secondary" variant="overline">
              {title ? title : 'Top performing Customer this month'}
            </Typography>
            <Typography variant="h4">{`${value}`}</Typography>
          </Stack>        
        </Stack>
        <Stack marginTop={1} direction="row">
          <Typography>rex</Typography>
        </Stack>
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
