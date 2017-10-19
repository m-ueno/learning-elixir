import React, {Component} from 'react';
import Board from './containers/Board.jsx';
import JoinButton from './containers/JoinButton.jsx';

class App extends Component {
  render() {
    return (<div>
      <JoinButton />
      <Board />
    </div>);
  }
}
export default App;
