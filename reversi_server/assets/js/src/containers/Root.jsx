import React from 'react';
import PropTypes from 'prop-types';
import { Provider } from 'react-redux';
import { BrowserRouter as Router } from 'react-router-dom';
// import invariant from 'invariant';
import configRoutes from '../routes';
import Layout from '../layouts';

const Root = ({ store }) => (
  <Provider store={store}>
    <Router>
      <Layout>
        {configRoutes()}
      </Layout>
    </Router>
  </Provider>
);
Root.propTypes = {
  store: PropTypes.object.isRequired,
};

export default Root;
