import React from 'react';
import PropTypes from 'prop-types';

import C from '../redux/constants.js';

const Cell = ({stone, handleClick}) => {
  const size = '50px'
  const styles = {
    base: {
      width: size,
      height: size,
      lineHeight: size,

      fontSize: '80px',
      margin: '5px',
      textAlign: 'center',
      padding: '0px 0',

      backgroundColor: '#fee',

      backgroundRepeat: 'no-repeat',
      backgroundAttachment: 'contain',
      backgroundPosition: 'center',
      backgroundSize: 'contain',
    },
    [C.STONE_WHITE]: {
      color: '#5bc0de',
      // backgroundImage: 'url(https://pbs.twimg.com/profile_images/759427015967584256/Mf9no0pv.jpg)',
    },
    [C.STONE_BLACK]: {
      color: '#d9534f',
    },
  };

  const style = Object.assign({}, styles.base, styles[stone]);
  const char = (stone === C.STONE_SPACE ? null : "●");

  return <div style={style} onClick={handleClick}>{char}</div>;
}
Cell.propTypes = {
  handleClick: PropTypes.func.isRequired,
  stone: PropTypes.any.isRequired,
  x: PropTypes.number.isRequired,
  y: PropTypes.number.isRequired,
};

export default Cell;