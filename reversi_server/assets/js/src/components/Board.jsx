import React from 'react';
import PropTypes from 'prop-types';

import Cell from './Cell.jsx';

const Board = ({cells, handleCellClick}) => {
  const range = Array.from({length: 8}, (v, k) => k);
  const xy = range.map(y =>
    <tr key={y}>
    {range.map(x =>
      <td key={y*8+x}>
        <Cell
          x={x}
          y={y}
          stone={cells[y * 8 + x]}
          handleClick={() => handleCellClick({x: x, y: y})}
        />
      </td>
    )}
    </tr>
  );

  return (<div>
    <h2>Board</h2>
    <table><tbody>{xy}</tbody></table>
  </div>);
}
Board.propTypes = {
  cells: PropTypes.array.isRequired,
  handleCellClick: PropTypes.func.isRequired,
}

export default Board;