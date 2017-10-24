import { connect } from 'react-redux';

import { joinAdminChannel } from '../redux/actions';
import Button from '../components/Button.jsx';

const mapDispatchToProps = (dispatch, _ownProps) => ({
  handleClick: () => dispatch(joinAdminChannel()),
  value: 'Join Admin channel',
});

const AdminButton = connect(null, mapDispatchToProps)(Button);

export default AdminButton;
