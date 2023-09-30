import {
  Box,
  Card,
  Tab,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  SvgIcon,
  TablePagination,
} from "@mui/material";
import React, { useState } from "react";
import { Scrollbar } from "src/components/scrollbar";
import PropTypes from "prop-types";
import More from "@heroicons/react/24/outline/EllipsisHorizontalIcon";
import { Popover, PopoverContent, PopoverTrigger } from "src/ui-components/ui/popover";

const tableHeader = [
  "Production Id",
  "Production Date",
  "Product Id",
  "Product Name",
  "Output quantity",
  "output in kls.",
  "Damaged Packaging",
  "",
];

const ProductionTable = (props) => {
  const { productionDatas = [] } = props;
  const [page, setPage] = useState(0);
  const [rowNumbers, setRowNumbers] = useState(10);



  // Table Pagination
  const onRowsPerPageChange = (event) => {
    setRowNumbers(event.target.value);
  };

  const changePage = (_, value) => {
    setPage(value);
  };

  const paginatedDatas = productionDatas.slice(page * rowNumbers, page * rowNumbers + rowNumbers);
  return (
    <Card>
      <Scrollbar>
        <Box sx={{ minWidth: "800px" }}>
          <Table>
            <TableHead>
              <TableRow>
                {tableHeader.map((value) => (
                  <TableCell>{value}</TableCell>
                ))}
              </TableRow>
            </TableHead>
            <TableBody>
              {paginatedDatas.map((value) => (
                <TableRow>
                  <TableCell>{value.production_id}</TableCell>
                  <TableCell>{new Date(value.production_date).toLocaleDateString()}</TableCell>
                  <TableCell>{value.product_id}</TableCell>
                  <TableCell>{value.product.product_name}</TableCell>
                  <TableCell>{value.output_quantity}</TableCell>
                  <TableCell>
                    {Number(value.output_quantity) * Number(value.product.packaging_size)}
                  </TableCell>
                  <TableCell>{value.damaged_packaging}</TableCell>
                  <TableCell>
                    <Popover>
                      <PopoverTrigger>
                        <SvgIcon>
                          <More />
                        </SvgIcon>
                      </PopoverTrigger>
                      <PopoverContent className="w-[7rem] px-2">
                        <p className="leading-7 px-2  hover:bg-slate-100">Edit</p>
                        <p className="leading-7 px-2  hover:bg-slate-100">Delete</p>
                      </PopoverContent>
                    </Popover>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          <TablePagination
            page={page}
            onRowsPerPageChange={onRowsPerPageChange}
            onPageChange={changePage}
            count={productionDatas.length}
            rowsPerPage={rowNumbers}
            rowsPerPageOptions={[10, 15, 20]}
          />
        </Box>
      </Scrollbar>
    </Card>
  );
};

ProductionTable.propTypes = {
  productionDatas: PropTypes.array,
};

export default ProductionTable;
