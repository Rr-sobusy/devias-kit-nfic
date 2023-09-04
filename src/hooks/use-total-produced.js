import sum from "lodash/sum";

export const useProduced = (arr) => {
  const datas = arr?.map(
    ({ output_quantity, product }) => Number(output_quantity) * Number(product.packaging_size)
  );
  return (sum(datas) / 1000).toFixed(2);
};
