import React from 'react';
import { connect } from 'react-redux';

import Board from '../../containers/Board.jsx';
import JoinButton from '../../containers/JoinButton.jsx';

const HomeIndexView = ({ isInLobby }) => {
  const buttons = [1, 2, 3].map(n =>
    <JoinButton key={n} value={`Join ROOM${n}`} gameID={`${n}`} />
  );
  return (
      isInLobby
        ? buttons
        : [
            <JoinButton key="leave" value="Leave room" gameID="0" />,
            <Board key="board" />
          ]
  );
}

const mapStateToProps = state => ({
  isInLobby: state.gameID == '0',
});

export default connect(mapStateToProps)(HomeIndexView);
