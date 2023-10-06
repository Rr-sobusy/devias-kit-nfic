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

const AddReleased = ({ children, packagingDatas }) => {
  /**
   * * lOCAL STATE
   */
  const [states, setStates] = useState({
    productId: 0,
    quantity: 0,
    releasedFor: "",
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
        <DialogTitle className="leading-10">Release Packaging</DialogTitle>
        <DialogDescription>
          <Box component="div">
            <Grid spacing={2} container>
              <Grid xs={12} md={6} lg={3}>
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
                      {date ? format(date, "PPP") : <span>Select released date</span>}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar mode="single" selected={date} onSelect={setDate} initialFocus />
                  </PopoverContent>
                </Popover>
              </Grid>
              <Grid xs={12} md={6} lg={5}>
                <SelectDropdown
                  onChange={(value) => setStates((prev) => ({ ...prev, productId: value }))}
                  dropdownValues={dropDownValues}
                />
              </Grid>
              <Grid xs={12} md={6} lg={2}>
                <Input
                  onChange={(event) =>
                    setStates((prev) => ({ ...prev, quantity: event.target.value }))
                  }
                  placeholder="Quantity"
                  type="number"
                />
              </Grid>
              <Grid xs={12} md={6} lg={2}>
                <Input
                  onChange={(event) =>
                    setStates((prev) => ({ ...prev, releasedFor: event.target.value }))
                  }
                  placeholder="Use for"
                  type="text"
                />
              </Grid>
            </Grid>
            <Stack direction="row" justifyContent="end" marginTop={2} component="div">
              <Button onClick={() => console.log(states, date)}>Add</Button>
            </Stack>
          </Box>
        </DialogDescription>
      </DialogContent>
    </Dialog>
  );
};

AddReleased.propTypes = {
  children: PropTypes.node,
};
export default AddReleased;
