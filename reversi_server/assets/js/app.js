// Application entrypoint.

// Render the top-level React component
import React from 'react';
import ReactDOM from 'react-dom';
import { compose, createStore, applyMiddleware } from 'redux';
import createSocketMiddleware from 'redux-ws';
import thunk from 'redux-thunk';

import reducer from './src/redux/reducers';
import Root from './src/containers/Root.jsx';
import socket from './src/socket';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const socketMiddleware = createSocketMiddleware(socket);
const store = createStore(
  reducer,
  composeEnhancers(applyMiddleware(socketMiddleware, thunk))
);

ReactDOM.render(
  <Root store={store} />,
  document.getElementById('react-root')
);
