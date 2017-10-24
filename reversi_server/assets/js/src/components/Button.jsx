import React from 'react';
import PropTypes from 'prop-types';

const Button = ({ value, handleClick }) => (
  <input type="button" className="btn btn-default" value={value} onClick={handleClick} />
);
Button.propTypes = {
  handleClick: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired,
};

export default Button;
