import { connect } from 'react-redux';

import { joinChannel } from '../redux/actions';
import PureButton from '../components/Button.jsx';

const mapStateToProps = (state) => ({
  gameID: state.gameID,
})

const mapDispatchToProps = (dispatch, _ownProps) => ({
  handleClick: () => dispatch(joinChannel({gameID: 0})),
});

const JoinButton = connect(mapStateToProps, mapDispatchToProps)(PureButton);

export default JoinButton;
