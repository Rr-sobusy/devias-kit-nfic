import PropTypes from 'prop-types';
import Cart from '@heroicons/react/24/solid/ShoppingCartIcon'
import UsersIcon from '@heroicons/react/24/solid/UsersIcon';
import { Avatar, Card, CardContent, Stack, SvgIcon, Typography, Box } from '@mui/material';

export const OverviewTotalProducts = (props) => {
  const { difference, positive = false, sx, value } = props;

  return (
    <Card sx={{ height: "100%" }}>
      <CardContent>
        <Stack alignItems="flex-start" direction="row" justifyContent="space-between" spacing={3}>
          <Stack spacing={1}>
            <Typography color="text.secondary" variant="overline">
              Total Products
            </Typography>
            <Typography variant="h4">15</Typography>
          </Stack>
          <Avatar
            sx={{
              backgroundColor: "#3DA5D9",
              height: 56,
              width: 56,
            }}
          >
            <SvgIcon>
              <Cart />
            </SvgIcon>
          </Avatar>
        </Stack>
        <Box marginTop={3} component="div">
          <Typography sx={{ display: "flex", gap: 0.5 }} variant="subtitle2" color="text.secondary">
            2 item/s without stocks
          </Typography>
        </Box>
      </CardContent>
    </Card>
  );
};

OverviewTotalProducts.propTypes = {
  difference: PropTypes.number,
  positive: PropTypes.bool,
  value: PropTypes.string.isRequired,
  sx: PropTypes.object
};

