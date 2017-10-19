import React from 'react';
import PropTypes from 'prop-types';

const Cell = ({children = undefined, handleClick}) => {
  const style = {
    width: 100,
    height: 100,
    backgroundColor: "#171",
    color: "#222",
  };
  return <div style={style} onClick={handleClick}>{children}</div>
}
Cell.propTypes = {
  handleClick: PropTypes.func.isRequired,
  x: PropTypes.number.isRequired,
  y: PropTypes.number.isRequired,
};

export default Cell;