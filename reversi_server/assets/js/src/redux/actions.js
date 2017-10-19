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
