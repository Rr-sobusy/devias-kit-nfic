import sum from "lodash/sum";


export const useTotalStocks = (array)=>{
    const stocks = array?.map(
        ({ current_stocks, packaging_size }) => Number(current_stocks) * Number(packaging_size)
      );
      return Math.round(sum(stocks) / 1000);
}