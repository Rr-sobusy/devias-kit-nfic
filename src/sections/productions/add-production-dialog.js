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
import { format } from "date-fns"
import SelectDropdown from "src/components/select";
import { Popover, PopoverContent, PopoverTrigger } from "src/ui-components/ui/popover";
import { Calendar } from "src/ui-components/ui/calendar";
import { Divider, Stack, Typography, Unstable_Grid2 as Grid } from "@mui/material";

const AddProduction = ({ children }) => {
  const [date, setDate] = React.useState();
  return (
    <Dialog>
      <DialogTrigger>{children}</DialogTrigger>
      <DialogContent className="lg:max-w-[800px]">
        <DialogHeader>
          <DialogTitle className="leading-10">Inbound Goods from Production Dept.</DialogTitle>
          <DialogDescription>
            <Grid spacing={2} container>
              <Grid xs={12} md={6} lg={3}>
                <Typography variant="subtitle2" color="text.secondary">
                  Production Date
                </Typography>
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
                      {date ? format(date, "PPP") : <span>Pick a date</span>}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar mode="single" selected={date} onSelect={setDate} initialFocus />
                  </PopoverContent>
                </Popover>
              </Grid>
              <Grid xs={12} md={6} lg={5}>
                <Typography variant="subtitle2" color="text.secondary">
                  Product Name
                </Typography>
                <SelectDropdown className="w-full" dropdownValues={[{ label: "rex", value: 0 }]} />
              </Grid>
              <Grid xs={12} md={6} lg={2}>
                <Typography variant="subtitle2" color="text.secondary">
                  Quantity
                </Typography>
                <Input type="number" />
              </Grid>
              <Grid xs={12} md={6} lg={2}>
                <Typography variant="subtitle2" color="text.secondary">
                  Dmg Pckng
                </Typography>
                <Input type="number" />
              </Grid>
            </Grid>
            <div className="mt-6 h-[2rem] flex justify-end ">
              <Button>Proceed</Button>
            </div>
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
};

AddProduction.propTypes = {
  children: PropTypes.node,
};

export default AddProduction;
