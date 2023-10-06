import { Box, Button, Card, Stack, Table, TableBody, TableCell, TableHead, TableRow } from '@mui/material'
import React from 'react'
import { Scrollbar } from 'src/components/scrollbar'
import AddReleased from './add-released-dialog'
import { useQuery, useMutation } from '@tanstack/react-query'
import PropTypes from 'prop-types'

const PackagingReleased = ({packagingDatas}) => {
  return (
    <Card>
      <Scrollbar>
        <Box>
          <Stack marginY={3} direction="row" justifyContent="flex-end">
            <AddReleased packagingDatas={packagingDatas}>
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
            <TableBody></TableBody>
          </Table>
        </Box>
      </Scrollbar>
    </Card>
  );
}

PackagingReleased.propTypes = {
      packagingDatas : PropTypes.array
}

export default PackagingReleased