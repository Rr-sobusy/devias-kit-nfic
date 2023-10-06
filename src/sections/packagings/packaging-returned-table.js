import { Box, Button, Card, Stack, Table, TableBody, TableCell, TableHead, TableRow } from '@mui/material'
import React from 'react'
import { Scrollbar } from 'src/components/scrollbar'

const PackagingReturned = () => {
  return (
    <Card>
      <Scrollbar>
        <Box>
          <Stack marginY={3} direction="row" justifyContent="flex-end">
            <Button variant="contained">Add Returned</Button>
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
                
            </TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
}

export default PackagingReturned