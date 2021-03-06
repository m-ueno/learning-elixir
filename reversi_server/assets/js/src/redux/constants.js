export default {
  STONE_WHITE: 'O',
  STONE_BLACK: 'X',
  STONE_SPACE: '_',

  BOARD_UPDATED: 'board_updated',
  CHANNEL_JOIN: 'channel_join',
  CHANNEL_JOINED: 'channel_joined',
  CHANNEL_LEAVE: 'channel_leave',
  CHANNEL_LEFT: 'channel_left',
  ADMIN_CHANNEL_JOIN: 'admin_channel_join',
  ADMIN_CHANNEL_JOINED: 'admin_channel_joined',

  SEND_HAND: 'send_hand',
  ALL_GAMES_UPDATED: 'all_game_state',

  // Event in phoenix channel
  // used only internal socketMiddleware
  EVENT_STATE_UPDATED: 'game:state',
  EVENT_ADD_STEP: 'game:add_step',
  EVENT_START_MONITORING: 'admin:monitor'

};
