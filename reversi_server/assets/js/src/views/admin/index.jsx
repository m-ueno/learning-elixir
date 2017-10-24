import React, { Component } from 'react';

import AdminButton from '../../containers/AdminButton.jsx';
import BoardGrid from '../../containers/BoardGrid.jsx';

class AdminIndexView extends Component {
  render() {
    return (<div>
      <AdminButton />
      <BoardGrid />
    </div>);
  }
}
export default AdminIndexView;
