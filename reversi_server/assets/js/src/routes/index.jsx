import React from 'react';
import { Switch, Route } from 'react-router-dom';

import HomeIndexView from '../views/home';

export default function configRoutes() {
  return (
    <Switch>
      <Route path="/" component={HomeIndexView} />
      {/* <Route path="/game/:id" component={GameShowView} />
      <Route path="/not_found" component={NotFoundView} />
      <Route path="/game_error" component={GameErrorView} />
      <Route path="*" component={NotFoundView} /> */}
    </Switch>
  );
}
