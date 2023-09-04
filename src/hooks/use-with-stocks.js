import Proptypes from "prop-types";
export const useWithStocks = (arr) => {
  const withStocks = arr?.filter(({current_stocks})=> current_stocks !== '0')
  return withStocks
};

useWithStocks.propTypes = {
  arr: Proptypes.array,
};
