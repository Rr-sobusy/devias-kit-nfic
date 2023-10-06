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

const AddDelivered = ({ children }) => {
  return (
    <Dialog>
      <DialogTrigger>{children}</DialogTrigger>
      <DialogContent>
      <DialogTitle className="leading-10">New Delivered Packaging</DialogTitle>
      </DialogContent>
    </Dialog>
  );
};

AddDelivered.propTypes = {
  children: PropTypes.node,
};
export default AddDelivered;