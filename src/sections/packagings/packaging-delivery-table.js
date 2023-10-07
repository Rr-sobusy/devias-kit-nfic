import {
  Box,
  Button,
  Card,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";
import AddDelivered from "./add-delivery-dialog";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import format from "date-fns/format";

export const DeliveryTable = (props) => {
  const {packagingDatas} = props
  /**
   * * Fetch the delivered packagings at this component level to prevent unnecessary rerender of sibling components
   */
  const { data: deliveryDatas = [] } = useQuery({
    queryKey: ["deliveredPackagings"],
    queryFn: async () => {
      const queryResult = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/delivered`).then(
        (res) => res.json()
      );
      return queryResult;
    },
  });

  /**
   * TODO : Mutate the packaging delivery table
   */
  const queryClient = useQueryClient();
  const mutationFn = useMutation({
    mutationFn: async (body) => {
      const response = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/adddelivered`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(body),
      });
      return response;
    },
    onSuccess: () => {
        queryClient.invalidateQueries({queryKey:["deliveredPackagings"]})
    },
  });
  const handlePost = (date, states) => {
    mutationFn.mutate({
        packaging_id: states.packagingId,
        delivered_quantity:  states.quantity,
        date_delivered : format(date, "yyyy-MM-dd'T'HH:mm:ss.SSSxxx")
    })

  };
  return (
    <Card sx={{ width: "100%" }}>
      <Scrollbar sx={{ minWidth: "350px" }}>
        <Box>
          <Stack marginY={3} justifyContent="flex-end" direction="row">
            <AddDelivered packagingDatas={packagingDatas} handlePost={handlePost}>
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
