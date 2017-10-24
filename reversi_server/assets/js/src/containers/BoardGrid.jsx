import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import Board from '../components/Board.jsx';
import GameInfo from '../components/GameInfo.jsx';

const BoardGrid = ({ games }) => {
  const nx = 3;
  const ny = 3;
  const range = (n) => [...Array(n).keys()];

  const rows = range(ny).map(y =>
    <tr key={`row${y}`}>{
      range(nx).map(x => {
        const idx = ny * y + x;
        if (idx > games.length - 1) {
          return null;
        }
        const game = games[idx];
        return (<td key={`col${x}`}>
          <GameInfo
            gameID={game.id}
            player1={game.player1.name}
            player2={game.player2.name}
          />
          <Board cells={game.board.board} />
        </td>);
      })
    }</tr>
  );

  return (
    <table border="1"><tbody>
      {rows}
    </tbody></table>
  );
};
BoardGrid.propTypes = {
  games: PropTypes.arrayOf(PropTypes.object).isRequired,
}

const mapStateToProps = (state) => ({
  games: state.games,
});

const mapDispatchToState = null;

export default connect(mapStateToProps, mapDispatchToState)(BoardGrid);
