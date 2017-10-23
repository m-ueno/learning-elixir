import React, { Component } from 'react';
import Board from '../../containers/Board.jsx';
import JoinButton from '../../containers/JoinButton.jsx';
import AdminButton from '../../containers/AdminButton.jsx';
import BoardGrid from '../../containers/BoardGrid.jsx';

class HomeIndexView extends Component {
  render() {
    return (<div>
      <JoinButton value="Join 'room1'" gameID="1" />
      <JoinButton value="Join 'room2'" gameID="2" />
      <JoinButton value="Join 'room3'" gameID="3" />
      <Board />
      <details>
        <summary>Admin zone</summary>
        <AdminButton />
        <BoardGrid />
      </details>
    </div>);
  }
}
export default HomeIndexView;
