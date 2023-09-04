import sum from "lodash/sum";

export const useOutbounded = (arr) => {
  const data = arr?.map(({ sales_items }) =>
    sum(sales_items.map(({ quantity, packagingSize }) => Number(quantity) * Number(packagingSize)))
  );
   return (sum(data) / 1000).toFixed(2)
};
