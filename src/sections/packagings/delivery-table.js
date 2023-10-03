import { Box, Button, Card, Stack, Table, TableBody, TableCell, TableHead, TableRow } from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";

export const DeliveryTable = (props) => {
    const {packagingDatas = []} = props
  return (
    <Card sx={{ width: "100%" }}>
      <Scrollbar sx={{ minWidth: "350px" }}>
        <Box>
          <Stack marginY={3} justifyContent="flex-end" direction="row">
            <Button variant="contained">Add New</Button>
          </Stack>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Packaging ID</TableCell>
                <TableCell>Packaging Name</TableCell>
                <TableCell>Delivery Date</TableCell>
                <TableCell>Quantity</TableCell>
                <TableCell>Released</TableCell>
                <TableCell>Returned</TableCell>
                <TableCell>Current Stocks</TableCell>
                <TableCell>{""}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {packagingDatas.map((values) => (
                <TableRow>
                  <TableCell>{values.packaging_id}</TableCell>
                  <TableCell>{values.packaging_name}</TableCell>
                  <TableCell>{values.initial_stocks}</TableCell>
                  <TableCell>{values.total_delivered}</TableCell>
                  <TableCell>{values.total_released}</TableCell>
                  <TableCell>{values.total_returned}</TableCell>
                  <TableCell>
                    {values.initial_stocks +
                      values.total_delivered -
                      values.total_released +
                      values.total_returned}
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
