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
import AddReleased from "./add-released-dialog";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import PropTypes from "prop-types";
import format from "date-fns/format";

const PackagingReleased = ({ packagingDatas }) => {

/**
 * * Fetch packaging delivery datas in this component level to prevent unnecessary rerender of other sibling component
 */
const { data: releasedPackagingDatas = [] } = useQuery({
  queryKey: ["releasedPackaging"],
  queryFn: async () => {
    const queryResult = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/released`).then(
      (res) => res.json()
    );
    return queryResult;
  },
});

  /**
   * TODO: Make mutation for released packagings
   */
  const queryClient = useQueryClient();
  const mutation = useMutation({
    mutationFn: async (body) => {
      const response = await fetch(`${process.env.SERVER_ENDPOINT}/packaging/addreleased`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(body),
      });
      return response;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({queryKey : ["releasedPackaging"]})
    },
  });
  const handlePost = (date, states) => {
    mutation.mutate({
      packaging_id: states.packagingId,
      quantity_released: states.quantity,
      date_released: format(date, "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"),
      released_for: states.releasedFor,
    });
  };
  return (
    <Card>
      <Scrollbar>
        <Box>
          <Stack marginY={3} direction="row" justifyContent="flex-end">
            <AddReleased handlePost={handlePost} packagingDatas={packagingDatas}>
              <Button variant="contained">Add Released</Button>
            </AddReleased>
          </Stack>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Packaging Id</TableCell>
                <TableCell>Packaging Name</TableCell>
                <TableCell>Date Released</TableCell>
                <TableCell>Quantity Released</TableCell>
                <TableCell>Released For</TableCell>
                <TableCell>{""}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {releasedPackagingDatas.map((values) => (
                <TableRow key={values.id}>
                  <TableCell>{values.packaging_id}</TableCell>
                  <TableCell>{values.packaging.packaging_name}</TableCell>
                  <TableCell>{values.date_released}</TableCell>
                  <TableCell>{values.quantity_released}</TableCell>
                  <TableCell>{values.released_for}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
};

PackagingReleased.propTypes = {
  packagingDatas: PropTypes.array,
};

export default PackagingReleased;
