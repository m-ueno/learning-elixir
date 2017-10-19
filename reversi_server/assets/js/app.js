// Application entrypoint.

// Render the top-level React component
import React from 'react';
import ReactDOM from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import createSocketMiddleware from 'redux-ws';

import reducer from './src/redux/reducers';
import App from './src/App.jsx';

const store = createStore(
  reducer,
  // applyMiddleware(createSocketMiddleware)
);

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('react-root')
);
