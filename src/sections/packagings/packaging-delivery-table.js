import { Box, Button, Card, Stack, Table, TableBody, TableCell, TableHead, TableRow } from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";
import AddDelivered from "./add-delivery-dialog";

export const DeliveryTable = (props) => {
    const {deliveryDatas = []} = props
  return (
    <Card sx={{ width: "100%" }}>
      <Scrollbar sx={{ minWidth: "350px" }}>
        <Box>
          <Stack marginY={3} justifyContent="flex-end" direction="row">
            <AddDelivered>
              <Button variant="contained">Add Delivered</Button>
            </AddDelivered>
          </Stack>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Packaging ID</TableCell>
                <TableCell>Packaging Name</TableCell>
                <TableCell>Delivery Date</TableCell>
                <TableCell>Quantity Delivered</TableCell>
                <TableCell>{""}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {deliveryDatas.map((values) => (
                <TableRow>
                  <TableCell>{values.packaging_id}</TableCell>
                  <TableCell>{values.packaging.packaging_name}</TableCell>
                  <TableCell>{new Date(values.date_delivered).toDateString()}</TableCell>
                  <TableCell>{values.delivered_quantity}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
};
