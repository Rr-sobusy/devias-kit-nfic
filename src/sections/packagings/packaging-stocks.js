import { Box, Button, Card, Stack, Table, TableBody, TableCell, TableHead, TableRow } from "@mui/material";
import React from "react";
import { Scrollbar } from "src/components/scrollbar";

export const PackagingStocks = () => {
  return <Card sx={{ width: "100%" }}>
    <Scrollbar sx={{minWidth : '350px'}} >
        <Box>
            <Stack marginBottom={3} justifyContent="flex-end" direction="row">
                    <Button variant="contained">Add New</Button>                
            </Stack>
            <Table>
                <TableHead>
                    <TableRow>
                        <TableCell>Packaging ID</TableCell>
                        <TableCell>Packaging Name</TableCell>
                        <TableCell>Initial Stocks</TableCell>
                        <TableCell>Delivered</TableCell>
                        <TableCell>Released</TableCell>
                        <TableCell>Returned</TableCell>
                        <TableCell>Current Stocks</TableCell>
                        <TableCell>{""}</TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    
                </TableBody>
            </Table>
        </Box>
    </Scrollbar>
  </Card>;
};
