import { Card, CardContent, CardHeader, Typography } from "@mui/material";
import React from "react";
import { Button } from "src/ui-components/ui/button";
import { Calendar } from "src/ui-components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "src/ui-components/ui/popover";
import { cn } from "@/lib/utils";

const SalesFilter = () => {
  const [date, setDate] = React.useState(new Date());
  return (
    <Card>
      <CardHeader title="Filterable" />
      <CardContent>
        <Popover>
          <PopoverTrigger asChild>
            <Button
              variant={"outline"}
              className={cn(
                "w-[280px] justify-start text-left font-normal",
                !date && "text-muted-foreground"
              )}
            ></Button>
          </PopoverTrigger>
          <PopoverContent className="w-auto p-0">
            <Calendar
              mode="single"
              selected={date}
              onSelect={(selectedDate) => {
                setDate(selectedDate);
              }}
              initialFocus
            />
          </PopoverContent>
        </Popover>
      </CardContent>
    </Card>
  );
};

export default SalesFilter;
