import React, { Component } from 'react';

import Board from '../../containers/Board.jsx';
import JoinButton from '../../containers/JoinButton.jsx';

class HomeIndexView extends Component {
  render() {
    return (<div>
      <JoinButton value="Join 'room1'" gameID="1" />
      <JoinButton value="Join 'room2'" gameID="2" />
      <JoinButton value="Join 'room3'" gameID="3" />
      <Board />
    </div>);
  }
}
export default HomeIndexView;
