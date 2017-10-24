import React from 'react';
import PropTypes from 'prop-types';
import { NavLink } from 'react-router-dom';

const style = {
  display: 'inline',
  margin: '5px',
};

const ListItem = ({ to, text }) => (
  <li style={style}><NavLink to={to} activeClassName="active">{text}</NavLink></li>
);
ListItem.propTypes = {
  to: PropTypes.string.isRequired,
  text: PropTypes.string.isRequired,
};

const RootLayout = ({ children }) => (
  <div>
    <nav>
      <ul>
        <ListItem to="/" text="Home" />
        <ListItem to="/admin" text="Admin" />
      </ul>
    </nav>
    <hr />
    <main>
      {children}
    </main>
  </div>
);
RootLayout.propTypes = {
  children: PropTypes.object.isRequired,
};

export default RootLayout;
