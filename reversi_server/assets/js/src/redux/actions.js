import C from './constants';

function updateLocalState({cells}) {
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

function channelJoined({ gameID, turn, cells, channel }) {
  return ({
    type: C.CHANNEL_JOINED,
    gameID,
    turn,
    cells,
    channel,
  });
}

export function joinChannel({ gameID }) {
  return ({ socket, dispatch }) => {
    const topic = `game:${gameID}`;
    const channel = socket.channel(topic, {});
    channel.on('game:state', game => {

      console.log('Handling event game:state', game);

      dispatch(updateLocalState({cells: game.board.board}));
    });
    channel
      .join()
      .receive('ok', resp => {
        console.log('resp ok:', resp, socket);
        dispatch(channelJoined({
          gameID: resp.id,
          turn: resp.turn,
          cells: resp.board.board,
          channel,
        }));
      })
      .receive('error', ({reason}) => console.log('ws receive error:', reason))
      ;
  }
}

export function sendHandToGameChannel({x, y}) {
  return ({ socket, dispatch, getState }) => {
    const {gameID, myStone, channel} = getState();
    console.log("sendHandToGame:", gameID, myStone, channel);
    const topic = `game:${gameID}`;
    channel
      .push('game:add_step', {x: x, y: y, stone: myStone})
      .receive('ok', _ => dispatch({
        type: 'hand sent',
      }))
  }
}