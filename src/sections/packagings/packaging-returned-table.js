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
import AddReturned from "./add-returned-dialog";
import { useQuery, useQueryClient, useMutation } from "@tanstack/react-query";
import PropTypes from 'prop-types'
import format from "date-fns/format";


const PackagingReturned = ({packagingDatas}) => {
  /**
   * * Fetch datas from API in this component level to reduce the unnecessary rerender of other sibling components
   */
  const queryClient = useQueryClient()
  const { data: returnedPackagingDatas = [] } = useQuery({
    queryKey: ["returnedPackagings"],
    queryFn: async () => {
      const queryResult = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/returned`).then(
        (res) => res.json()
      );
      return queryResult;
    },
  });

  /**
   * TODO: Make mutation for returned packagings
   */
  const mutationFn = useMutation({
      mutationFn: async(body)=>{
          const response = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/addreturned`, {
              method : 'POST',
              headers: {"content-type": "application/json"},
              body : JSON.stringify(body)
          })
          return response
      },
      onSuccess : ()=>{
              queryClient.invalidateQueries({
                queryKey:["returnedPackagings"]
              })
      }
  })


  // * POST HANDLER
  const handlePost = (date,states)=>{
          mutationFn.mutate({
            packaging_id: states.packagingId,
            quantity_returned: states.quantity,
            returned_date: format(date, "yyyy-MM-dd'T'HH:mm:ss.SSSxxx")
          })
  }
  return (
    <Card>
      <Scrollbar>
        <Box>
          <Stack marginY={3} direction="row" justifyContent="flex-end">
            <AddReturned handlePost={handlePost} packagingDatas={packagingDatas}>
              <Button variant="contained">Add Returned</Button>
            </AddReturned>
          </Stack>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Packaging Id</TableCell>
                <TableCell>Packaging Name</TableCell>
                <TableCell>Date Returned</TableCell>
                <TableCell>Quantity Returned</TableCell>
                <TableCell>{""}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {returnedPackagingDatas.map((values) => (
                <TableRow>
                  <TableCell>{values.packaging_id}</TableCell>
                  <TableCell>{values.packaging.packaging_name}</TableCell>
                  <TableCell>{new Date(values.returned_date).toDateString()}</TableCell>
                  <TableCell>{values.quantity_returned}</TableCell>
                  <TableCell>{""}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
};

PackagingReturned.propTypes = {
      packagingDatas: PropTypes.array
}

export default PackagingReturned;
