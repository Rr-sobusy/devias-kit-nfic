import React from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "src/ui-components/ui/select";
import PropTypes from 'prop-types'

const SelectDropdown = (props) => {
    const {placeholder, className, dropdownValues, onChange , ...rest} = props
  return (
    <Select {...rest} onValueChange={onChange}>
      <SelectTrigger className={className}>
        <SelectValue placeholder={placeholder} />
      </SelectTrigger>
      <SelectContent className="max-h-[400px]">
        {dropdownValues.map((props, key) => (
          <SelectItem className="h-[2.75rem]" value={props.value} key={key}>
            {props.label}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
};

export default SelectDropdown;

SelectDropdown.propTypes = {
    placeholder: PropTypes.string,
    className:PropTypes.string,
    dropdownValues:PropTypes.array,
    onChange:PropTypes.func
}

SelectDropdown.defaultProps = {
    placeholder: ''
}
