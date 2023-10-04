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
import { useQuery } from "@tanstack/react-query";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import * as Dcustom from "@radix-ui/react-dialog";
import { Unstable_Grid2 as Grid } from "@mui/material";

const AddProduction = ({ children }) => {
  const queryClient = useQueryClient();
  const [date, setDate] = React.useState();

  const [states, setStates] = useState({
    productId: 0,
    quantity: 0,
    damagedPackaging: 0,
  });
  /**
   * * Fetch datas coming from - Done it with fetching it to the
   * * lower component tree to prevent the unnecessary rerender of other components
   */
  const { data } = useQuery({
    queryKey: ["productDatas"],
    queryFn: async () => {
      const queryResult = await fetch(`${process.env.SERVER_ENDPOINT}/products`).then((res) =>
        res.json()
      );
      return queryResult;
    },
  });

  const productDatas = data?.map(({ product_id, product_name }) => {
    return {
      label: product_name,
      value: product_id,
    };
  });

  //* Mutations
  const mutation = useMutation({
    mutationFn: () => {
      return fetch(`${process.env.SERVER_ENDPOINT}/products/productionoutputs`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          product_id: states.productId,
          production_date: date,
          output_quantity: states.quantity,
          damaged_packaging: states.damagedPackaging,
        }),
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["productionDatas"] });
    },
  });

  return (
    <Dialog>
      <DialogTrigger>{children}</DialogTrigger>
      <DialogContent className="lg:max-w-[800px] -mt-[7rem]">
        <DialogHeader>
          <DialogTitle className="leading-10">Inbound Goods from Production Dept.</DialogTitle>
          <DialogDescription>
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
                      {date ? format(date, "PPP") : <span>Select production date</span>}
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
                  placeholder="Select Product"
                  className="w-full"
                  dropdownValues={productDatas}
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
                    setStates((prev) => ({ ...prev, damagedPackaging: event.target.value }))
                  }
                  placeholder="dmg pckgng"
                  type="number"
                />
              </Grid>
            </Grid>
            <div className="mt-6 h-[2rem] flex justify-end ">
              <Dcustom.Close>
                <Button onClick={() => console.log(states)} className="bg-black hover:bg-slate-700">
                  Proceed
                </Button>
              </Dcustom.Close>
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
