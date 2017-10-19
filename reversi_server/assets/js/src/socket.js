import { Socket } from 'phoenix';

const socket = new Socket('/socket', { params: { token: window.userToken, player_id: window.player_id } });
socket.connect();

export default socket;