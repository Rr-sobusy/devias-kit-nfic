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
import { Popover, PopoverContent, PopoverTrigger } from "src/ui-components/ui/popover";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "src/ui-components/ui/dialog";

/**********************Hero Icons*********** */
import More from "@heroicons/react/24/outline/EllipsisHorizontalIcon";
const SalesTable = (props) => {
  const { salesDatas = [] } = props;

  // Table pagination

  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [page, setPage] = useState(0);

  // Slicing salesData array depends to page and number of rows per page
  const displayedDatas = salesDatas.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage);

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
                    <Popover>
                      <PopoverTrigger>
                        <SvgIcon>
                          <More />
                        </SvgIcon>
                      </PopoverTrigger>
                      <PopoverContent className="w-[7rem] px-2">
                      <p className="leading-7 px-2 cursor-pointer  hover:bg-slate-100">Edit</p>
                        <Dialog>
                          <DialogTrigger className="w-full text-start">
                            <p className="leading-7 px-2 cursor-pointer  hover:bg-slate-100">
                              Delete
                            </p>
                          </DialogTrigger>
                          <DialogContent>
                            <DialogHeader>
                              <DialogTitle>Are you sure absolutely sure?</DialogTitle>
                              <DialogDescription>
                                This action cannot be undone. This will permanently delete your
                                account and remove your data from our servers.
                              </DialogDescription>
                            </DialogHeader>
                          </DialogContent>
                        </Dialog>
                    
                      </PopoverContent>
                    </Popover>
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
