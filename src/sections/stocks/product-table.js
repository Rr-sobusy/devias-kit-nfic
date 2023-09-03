import { Box, Table, TableCell, TableHead, TableRow, Card, TableBody } from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";

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
                <TableCell>Initial Stocks</TableCell>
                <TableCell>In</TableCell>
                <TableCell>Out</TableCell>
                <TableCell>Repro</TableCell>
                <TableCell>Current Stocks</TableCell>
                <TableCell>Stocks in kls</TableCell>
                <TableCell>Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {productDatas.map((values) => (
                <TableRow key={values.productId}>
                  <TableCell>{values.productId}</TableCell>
                  <TableCell>{values.productName}</TableCell>
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
