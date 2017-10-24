import C from './constants';

function updateLocalState({cells}) {
  return ({
    type: C.BOARD_UPDATED,
    cells,
  });
}

function updateAllGameState({ games }) {
  return ({
    type: C.ALL_GAMES_UPDATED,
    games: games,
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
      dispatch(updateLocalState({cells: game.board.board}));
    });
    channel
      .join()
      .receive('ok', resp => {
        console.log('channel joined:', resp, socket);
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
    const topic = `game:${gameID}`;
    channel
      .push('game:add_step', {x: x, y: y, stone: myStone})
      .receive('ok', _ => dispatch({
        type: 'hand sent',
      }))
  }
}

export function joinAdminChannel() {
  return ({ socket, dispatch }) => {
    const topic = 'admin:monitor';
    const channel = socket.channel(topic, {});
    channel.on('all_game_state', message => {
      dispatch(updateAllGameState({ games: message.games }));
    });
    channel
      .join()
      .receive('ok', resp => {
        console.log('channel joined:', resp, socket);
      })
      .receive('error', ({reason}) => console.log('ws receive error:', reason))
      ;
  }
}