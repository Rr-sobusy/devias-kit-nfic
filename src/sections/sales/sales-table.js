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
  Typography,
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
import { Button } from "src/ui-components/ui/button";
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
                          <DialogContent className="xl:min-w-auto">
                            <DialogHeader>
                              <DialogTitle>
                                Are you sure absolutely sure to delete transaction?
                              </DialogTitle>
                              <DialogDescription>
                                <div className="mt-5">
                                  <Stack spacing={1} direction="row">
                                    <Typography variant="subtitle2" color="text.secondary">
                                      Customer Name:
                                    </Typography>
                                    <Typography variant="subtitle">
                                      {values.customer_name}
                                    </Typography>
                                  </Stack>
                                  <Stack spacing={1} direction="row">
                                    <Typography variant="subtitle2" color="text.secondary">
                                      Outbound Date:
                                    </Typography>
                                    <Typography variant="subtitle">
                                      {new Date(values.createdAt).toDateString()}
                                    </Typography>
                                  </Stack>
                                  <Stack spacing={1} marginTop={2}>
                                    <Typography variant="subtitle2" color="text.secondary">
                                      Items:
                                    </Typography>
                                    <Table>
                                      <TableHead>
                                        <TableRow>
                                          <TableCell>Product Name</TableCell>
                                          <TableCell>Quantity</TableCell>
                                        </TableRow>
                                      </TableHead>
                                      <TableBody>
                                        {values.sales_items?.map(({ product_name, quantity }) => (
                                          <TableRow>
                                            <TableCell>{product_name}</TableCell>
                                            <TableCell>{quantity}</TableCell>
                                          </TableRow>
                                        ))}
                                      </TableBody>
                                    </Table>
                                  </Stack>
                                  <Stack spacing={1} justifyContent="flex-end" direction="row" marginTop={2}>
                                    <Button variant="outline">Back</Button>
                                    <Button className="bg-red-500 hover:bg-red-600">
                                      Delete
                                    </Button>
                                  </Stack>
                                </div>
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
