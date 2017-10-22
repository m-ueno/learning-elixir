import React from 'react';
import PropTypes from 'prop-types';

const GameInfo = ({gameID, player1, player2, turn, steps}) => (
  <div>
    <p>Game {gameID}</p>
    <p>{player1} vs {player2}</p>
  </div>
);

export default GameInfo;
