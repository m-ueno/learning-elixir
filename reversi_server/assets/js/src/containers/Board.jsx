import { connect } from 'react-redux'

import {sendHandToGameChannel} from '../redux/actions';
import PureBoard from '../components/Board.jsx';

const mapDispatchToState = (dispatch) => ({
  handleCellClick: ({x, y}) => {
    dispatch(sendHandToGameChannel({x, y}))
  },
});

const mapStateToProps = (state) => ({
  cells: state.cells,
});

const Board = connect(mapStateToProps, mapDispatchToState)(PureBoard);
export default Board;
