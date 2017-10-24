import React from 'react';
import { Redirect, Route, Switch } from 'react-router-dom';

import HomeIndexView from '../views/home';
import AdminIndexView from '../views/admin';

export default function configRoutes() {
  return (
    <Switch>
      <Route exact path="/" component={HomeIndexView} />
      <Route exact path="/admin" component={AdminIndexView} />
      <Redirect from="*" to="/" />
      {/* <Route path="/game/:id" component={GameShowView} />
      <Route path="/not_found" component={NotFoundView} />
      <Route path="/game_error" component={GameErrorView} />
      <Route path="*" component={NotFoundView} /> */}
    </Switch>
  );
}
