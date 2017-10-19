import { connect } from 'react-redux'

import PureBoard from '../components/Board.jsx';

const mapStateToProps = (state) => ({cells: state.cells});

const Board = connect(mapStateToProps)(PureBoard);
export default Board;
