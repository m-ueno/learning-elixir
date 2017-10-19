import React from 'react';
import PropTypes from 'prop-types';

const JoinButton = ({ handleClick }) => {
  return (<input type="button" value="Join game" onClick={handleClick} />);
};
JoinButton.propTypes = {
  handleClick: PropTypes.func.isRequired,
};

export default JoinButton;
