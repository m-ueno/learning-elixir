import C from './constants';

export function updateLocalState({cells}) {
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

export const channelJoined = ({ gameID, turn, cells, channel }) => ({
  type: C.CHANNEL_JOINED,
  gameID,
  turn,
  cells,
  channel,
});

export const channelLeft = () => ({
  type: C.CHANNEL_LEFT
});

export const joinChannel = ({ gameID }) => ({
  type: C.CHANNEL_JOIN,
  gameID,
});

export function joinChannelOld({ gameID }) {
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

export const sendHandToGameChannel = ({ x, y }) => ({
  type: C.SEND_HAND, x, y,
});

export function sendHandToGameChannelOLD({x, y}) {
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