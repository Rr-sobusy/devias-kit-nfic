import { Box, Card, Tab, Table, TableBody, TableCell, TableHead, TableRow } from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";
import PropTypes from "prop-types";
import format from "date-fns/format";

const tableHeader = [
  "Production Id",
  "Production Date",
  "Product Id",
  " Product Name",
  "  Output quantity",
  "output in kls.",
  "Damaged Packaging",
  "",
];

const ProductionTable = (props) => {
  const { productionDatas = [] } = props;
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
              {productionDatas.map((value) => (
                <TableRow>
                  <TableCell>{value.production_id}</TableCell>
                  <TableCell>{new Date(value.production_date).toLocaleDateString()}</TableCell>
                  <TableCell>{value.product_id}</TableCell>
                  <TableCell>{value.product.product_name}</TableCell>
                  <TableCell>{value.output_quantity}</TableCell>
                  <TableCell>{Number(value.output_quantity) * Number(value.product.packaging_size)}</TableCell>
                  <TableCell>{value.damaged_packaging}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
};

ProductionTable.propTypes = {
  productionDatas: PropTypes.array,
};

export default ProductionTable;
