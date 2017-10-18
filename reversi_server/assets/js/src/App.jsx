import React, {Component} from 'react';
import Board from './components/Board.jsx';

class App extends Component {
  render() {
    return (<div>
      <h1>Hello React :)</h1>
      <Board cells={[]} />
    </div>);
  }
}
export default App;
