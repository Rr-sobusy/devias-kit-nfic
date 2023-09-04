import {
  Box,
  Table,
  TableCell,
  TableHead,
  TableRow,
  Card,
  TableBody,
  Stack,
  Typography,
  SvgIcon,
} from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";
import { Button as UIButton } from "src/ui-components/ui/button";

/**********************Hero Icons*********** */
import Delete from "@heroicons/react/24/outline/BackspaceIcon";
import More from "@heroicons/react/24/outline/EllipsisHorizontalIcon";
const ProductTable = (props) => {
  const { productDatas = [] } = props;
  return (
    <Card>
      <Scrollbar>
        <Box sx={{ minWidth: 800 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Product ID</TableCell>
                <TableCell>Product Name</TableCell>
                <TableCell>Packaging Size</TableCell>
                <TableCell>Current Stocks</TableCell>
                <TableCell>Stocks in kls</TableCell>
                <TableCell>Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {productDatas.map((values) => (
                <TableRow hover key={values.product_id}>
                  <TableCell>{values.product_id}</TableCell>
                  <Typography variant="subtitle2">
                    <TableCell>{values.product_name}</TableCell>
                  </Typography>
                  <TableCell>{values.packaging_size}</TableCell>
                  <TableCell>{values.current_stocks}</TableCell>
                  <TableCell>
                    {Number(values.packaging_size) * Number(values.current_stocks)}
                  </TableCell>
                  <TableCell>
                    <Stack direction="row" alignItems="center" spacing={1}>
                      <SvgIcon>
                        <More />
                      </SvgIcon>
                      <SvgIcon>
                        <Delete />
                      </SvgIcon>
                    </Stack>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
};

export default ProductTable;
