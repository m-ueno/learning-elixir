import C from './constants';

const initialState = {
  gameID: 0,
  turn: C.STONE_WHITE,
  myStone: C.STONE_WHITE,
  cells: Array.from(Array(64)).map(_ => C.STONE_SPACE),
  channel: undefined, // Socket.channel
};

export default function reversiClient(state = initialState, action) {

  console.log('Reducing action:', state, action);

  switch (action.type) {
    case C.CHANNEL_JOINED:
      const { gameID, turn, cells, channel } = action;
      return { ...state, gameID, turn, cells, channel };
    case C.BOARD_UPDATED:
      return ({ ...state, cells: action.cells });
    default:
      return state;
  }
}
