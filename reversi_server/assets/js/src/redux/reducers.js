import C from './constants';

const initialState = {
  turn: C.STONE_WHITE,
  cells: Array.from(Array(64)).map(_ => C.STONE_SPACE),
};

export default function reversiClient(state = initialState, action) {

  console.log('reducer head:', state, action);

  switch (action.type) {
    case C.BOARD_UPDATED:
      return({ ...state, cells: action.cells });
    default:
      return state;
  }
}
