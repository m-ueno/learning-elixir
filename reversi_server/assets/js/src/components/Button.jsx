import React from 'react';
import PropTypes from 'prop-types';

const Button = ({ value, handleClick }) => (
  <input type="button" value={value} onClick={handleClick} />
);
Button.propTypes = {
  handleClick: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired,
};

export default Button;
