import C from './constants';

function updateLocalState(cells) {
  return ({
    type: C.BOARD_UPDATED,
    cells,
  });
}

function updateRemoteState(x, y, stone) {
  return ({
    type: C.MAKE_STEP,
    x, y, stone,
  });
}

function channelJoined({ gameID }) {
  return ({
    type: C.CHANNEL_JOINED,
    gameID,
  });
}

export function joinChannel({ gameID }) {
  return ({ socket, dispatch }) => {
    const channel = `game:${gameID}`;
    socket
      .channel(channel, {})
      .join()
      .receive('ok', resp => {
        console.log('resp ok:', resp);
        dispatch(channelJoined({ gameID: socket.game_id }));
      })
  }
}