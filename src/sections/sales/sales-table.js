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
} from "@mui/material";
import React,{memo} from "react";
import { Scrollbar } from "src/components/scrollbar";
import PropTypes from "prop-types";

/**********************Hero Icons*********** */
import Delete from "@heroicons/react/24/outline/BackspaceIcon";
import More from "@heroicons/react/24/outline/EllipsisHorizontalIcon";
const SalesTable = (props) => {
  const { salesDatas = [{ sales_id: 1 }] } = props;
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
              {salesDatas.map((values, index) => (
                <TableRow key={index}>
                  <TableCell>{values.sales_id}</TableCell>
                  <TableCell>{values.customer_name}</TableCell>
                  <TableCell>{new Date(values.createdAt).toLocaleDateString()}</TableCell>
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
        </Box>
      </Scrollbar>
    </Card>
  );
};

export default SalesTable;

SalesTable.propTypes = {
  salesDatas: PropTypes.array,
};
