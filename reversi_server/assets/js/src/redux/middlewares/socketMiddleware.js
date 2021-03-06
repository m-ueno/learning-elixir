import { Socket } from 'phoenix';

import C from '../constants';
import { channelJoined, updateLocalState, updateAllGameState, adminChannelJoined } from '../actions';

const socketMiddleware = (function () {
  let socket = null;  // should be persist once initialized
  let channel = null; // may be terminated, rejoin. Each client should be in a room at the same time.
  let adminChannel = null;

  const connect = () => {
    socket = new Socket('/socket', { params: { token: window.userToken, player_id: window.player_id } });

    socket.connect();

    // Socket hooks
    socket.onError = () => console.log('onSocketError');
    socket.onClose = onSocketClose();
  }

  const connectIfNotConnected = () => {
    if (!socket) {
      connect();
    }
  }

  const onSocketClose = () => {
    console.log('onSocketClose');
    // socket = null;
    // channel = null;
    // adminChannel = null;
    // const onSocketClose = (ws, store) => evt => {
    //Tell the store we've disconnected
    // store.dispatch(actions.disconnected());
  }

  return store => next => action => {

    switch (action.type) {

      //The user wants us to connect
      case C.CHANNEL_JOIN: {
        const { gameID } = action;
        const topic = `game:${gameID}`;

        //Send an action that shows a "connecting..." status for now
        // store.dispatch(actions.connecting());

        //Attempt to connect (we could send a 'failed' action on error)
        connectIfNotConnected();

        channel = socket.channel(topic, {});

        // Channel hooks
        channel.onError(() => console.log('channel onError'));
        channel.onClose(() => console.log('channel onClose - the channel has gone away gracefully'));
        channel.on(C.EVENT_STATE_UPDATED, game => {
          store.dispatch(updateLocalState({ cells: game.board.board }));
        });

        // Attempt to join channel
        // async action creator
        // pass action creator function, instead of action (=object)
        next(dispatch => {
          channel
            .join()
            .receive('ok', game => {
              dispatch(channelJoined({
                gameID: game.id,
                turn: game.turn,
                cells: game.board.board,
                channel,
              }));
            })
            .receive('error', ({ reason }) => console.log('channel.join receive error:', reason))
            ;
        });

        break;
      }
      //The user wants us to disconnect
      case C.CHANNEL_LEAVE:
        if (socket != null) {
          socket.close();
        }
        socket = null;

        //Set our state to disconnected
        // store.dispatch(actions.disconnected());
        break;

      // User wants to send hand
      case C.SEND_HAND: {
        const { x, y } = action;
        const stone = store.getState().myStone;

        // async action creator
        next(dispatch =>
          channel
            .push(C.EVENT_ADD_STEP, { x, y, stone })
            .receive('ok', _ => dispatch({
              type: 'hand sent',
            }))
        );
        break;
      }

      // User wants to join admin channel
      case C.ADMIN_CHANNEL_JOIN: {

        if (adminChannel) {
          break;
        }

        // async action creator
        next(dispatch => {
          connectIfNotConnected();
          const topic = C.EVENT_START_MONITORING;
          adminChannel = socket.channel(topic, {});

          // listen
          adminChannel.on(C.ALL_GAMES_UPDATED, message => {
            dispatch(updateAllGameState({ games: message.games }));
          });

          adminChannel
            .join()
            .receive('ok', _resp => dispatch(adminChannelJoined())) // meaningless action
            .receive('error', ({reason}) => console.log('ws receive error:', reason));
        });
        break;
      }
      //This action is irrelevant to us, pass it on to the next middleware
      default:
        return next(action);
    }
  }
})();

export default socketMiddleware;
