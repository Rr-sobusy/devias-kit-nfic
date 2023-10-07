import React, { useState } from "react";
import PropTypes from "prop-types";
import { Calendar as CalendarIcon } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "src/ui-components/ui/dialog";
import { Button } from "src/ui-components/ui/button";
import { Input } from "src/ui-components/ui/input";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import SelectDropdown from "src/components/select";
import { Popover, PopoverContent, PopoverTrigger } from "src/ui-components/ui/popover";
import { Calendar } from "src/ui-components/ui/calendar";
import { Box, Unstable_Grid2 as Grid, Stack } from "@mui/material";
import * as DialogPrimitives from '@radix-ui/react-dialog'

const AddDelivered = ({ children, packagingDatas = [] , handlePost}) => {
  /**
   * * lOCAL STATE
   */
  const [states, setStates] = useState({
    packagingId: 0,
    quantity: 0,
  });

  const [date, setDate] = React.useState();

  const dropDownValues = packagingDatas.map(({ packaging_name, packaging_id }) => {
    return {
      label: packaging_name,
      value: packaging_id,
    };
  });

  return (
    <Dialog>
      <DialogTrigger>{children}</DialogTrigger>
      <DialogContent className="lg:max-w-[800px] -mt-[7rem]">
        <DialogTitle className="leading-10">Receive Packaging</DialogTitle>
        <DialogDescription>
          <Box component="div">
            <Grid spacing={2} container>
              <Grid xs={12} md={6} lg={4}>
                <Popover>
                  <PopoverTrigger>
                    <Button
                      variant={"outline"}
                      className={cn(
                        "text-left font-normal w-full",
                        !date && "text-muted-foreground"
                      )}
                    >
                      <CalendarIcon className="mr-2 h-4 w-4" />
                      {date ? format(date, "PPP") : <span>Select delivered date</span>}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar mode="single" selected={date} onSelect={setDate} initialFocus />
                  </PopoverContent>
                </Popover>
              </Grid>
              <Grid xs={12} md={6} lg={5}>
                <SelectDropdown
                  placeholder="Select Packaging"
                  onChange={(value) => setStates((prev) => ({ ...prev, packagingId: value }))}
                  dropdownValues={dropDownValues}
                />
              </Grid>
              <Grid xs={12} md={6} lg={3}>
                <Input
                  onChange={(event) =>
                    setStates((prev) => ({ ...prev, quantity: event.target.value }))
                  }
                  placeholder="Quantity"
                  type="number"
                />
              </Grid>
            </Grid>
            <Stack direction="row" justifyContent="end" marginTop={2} component="div">
              <DialogPrimitives.Close>
                <Button onClick={() => handlePost(date, states)}>Add</Button>
              </DialogPrimitives.Close>
            </Stack>
          </Box>
        </DialogDescription>
      </DialogContent>
    </Dialog>
  );
};

AddDelivered.propTypes = {
  children: PropTypes.node,
};
export default AddDelivered;
