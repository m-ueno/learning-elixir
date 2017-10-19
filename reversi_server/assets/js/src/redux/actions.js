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

function channelJoined({ gameID, turn, cells }) {
  return ({
    type: C.CHANNEL_JOINED,
    gameID,
    turn,
    cells
  });
}

export function joinChannel({ gameID }) {
  return ({ socket, dispatch }) => {
    const topic = `game:${gameID}`;
    const channel = socket.channel(topic, {});
    channel.on('game:state', board => {

      console.log('Handling event game:state', board);

      dispatch(updateLocalState({cells: board.board}));
    });
    channel
      .join()
      .receive('ok', resp => {
        console.log('resp ok:', resp, socket);
        dispatch(channelJoined({
          gameID: resp.id,
          turn: resp.turn,
          cells: resp.board.board,
        }));
      })
      .receive('error', ({reason}) => console.log('ws receive error:', reason))
      ;
  }
}

export function sendHandToGameChannel({gameID, x, y, stone}) {
  return ({ socket, dispatch }) => {
    const topic = `game:${gameID}`;
    const channel = socket.channel(topic, {});
    channel
      .push('add_step', {})
      .receive('ok', _ => dispatch({
        type: 'hand sent',
      }))
  }
}