import React from 'react';
import { NavLink } from 'react-router-dom';

const style = {
  display: 'inline',
  margin: '5px',
}
const ListItem = ({ to, text }) => (
  <li style={style}><NavLink to={to} activeClassName="active">{text}</NavLink></li>
);

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

export default RootLayout;
