import { connect } from 'react-redux';
import PropTypes from 'prop-types';

import { joinChannel } from '../redux/actions';
import PureButton from '../components/Button.jsx';

const mapStateToProps = (state) => ({
  gameID: state.gameID,
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleClick: () => dispatch(joinChannel({gameID: ownProps.gameID})),
});

const JoinButton = connect(mapStateToProps, mapDispatchToProps)(PureButton);
JoinButton.propTypes = {
  gameID: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
}

export default JoinButton;
