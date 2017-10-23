import React from 'react';
import PropTypes from 'prop-types';
import { Provider } from 'react-redux';
import { BrowserRouter as Router } from 'react-router-dom';
// import invariant from 'invariant';
import configRoutes from '../routes';

const Root = ({ store }) => (
  <Provider store={store}>
    <Router>
      {configRoutes()}
    </Router>
  </Provider>
);
Root.propTypes = {
  store: PropTypes.object.isRequired,
};

export default Root;
