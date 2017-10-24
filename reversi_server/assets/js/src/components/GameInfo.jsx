import React from 'react';
import PropTypes from 'prop-types';

const GameInfo = ({ gameID, player1, player2, turn, steps }) => (
  <div>
    <p>Game {gameID}</p>
    <p>{player1} vs {player2}</p>
  </div>
);
GameInfo.propTypes = {
  gameID: PropTypes.string.isRequired,
  player1: PropTypes.string.isRequired,
  player2: PropTypes.string.isRequired,
  turn: PropTypes.any,
  steps: PropTypes.array,
}

export default GameInfo;
