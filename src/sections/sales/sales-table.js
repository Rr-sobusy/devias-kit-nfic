import {
  Box,
  Table,
  TableCell,
  TableHead,
  TableRow,
  Card,
  TableBody,
  Stack,
  SvgIcon,
  TablePagination,
} from "@mui/material";
import React, { useState } from "react";
import { Scrollbar } from "src/components/scrollbar";
import PropTypes from "prop-types";

/**********************Hero Icons*********** */
import More from "@heroicons/react/24/outline/EllipsisHorizontalIcon";
const SalesTable = (props) => {
  const { salesDatas = [] } = props;

  // Table pagination

  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [page, setPage] = useState(0);

  // Slicing salesData array depends to page and number of rows per page
  const displayedDatas = salesDatas.slice(page * rowsPerPage, (page * rowsPerPage )+ rowsPerPage);

  const onPageChange = (_, value) => {
    setPage(value);
  };

  const onRowsPerPageChange = (event) => {
    setRowsPerPage(event.target.value);
  };
  return (
    <Card>
      <Scrollbar>
        <Box sx={{ minWidth: 800 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Sales Id</TableCell>
                <TableCell>Customer Name</TableCell>
                <TableCell>Outbound Date</TableCell>
                <TableCell>Product Name</TableCell>
                <TableCell>Quantity</TableCell>
                <TableCell>{""}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {displayedDatas.map((values, index) => (
                <TableRow key={index}>
                  <TableCell>{values.sales_id}</TableCell>
                  <TableCell>{values.customer_name}</TableCell>
                  <TableCell>{values && new Date(values.createdAt).toLocaleDateString()}</TableCell>
                  <TableCell>
                    {values.sales_items?.map((salesItems, index) => (
                      <Stack key={index}>
                        <p>{salesItems.product_name}</p>
                      </Stack>
                    ))}
                  </TableCell>
                  <TableCell>
                    {values.sales_items?.map((salesItems, index) => (
                      <Stack key={index}>
                        <p>{salesItems.quantity}</p>
                      </Stack>
                    ))}
                  </TableCell>
                  <TableCell>
                    <SvgIcon className="cursor-pointer">
                      <More />
                    </SvgIcon>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          <TablePagination
            page={page}
            onPageChange={onPageChange}
            count={salesDatas.length}
            onRowsPerPageChange={onRowsPerPageChange}
            rowsPerPage={rowsPerPage}
            rowsPerPageOptions={[10, 15, 20]}
          />
        </Box>
      </Scrollbar>
    </Card>
  );
};

export default SalesTable;

SalesTable.propTypes = {
  salesDatas: PropTypes.array,
};
