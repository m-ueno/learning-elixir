import { Socket } from 'phoenix';

const socket = new Socket('/socket', { params: { token: window.userToken, player_id: window.player_id } });
// const socket = new Socket('/socket');
// const socket = {};
socket.connect();

export default socket;