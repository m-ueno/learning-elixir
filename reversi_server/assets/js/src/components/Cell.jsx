import React from 'react';

const Cell = ({children = undefined}) => {
  const style = {
    width: 100,
    height: 100,
    backgroundColor: "#171",
    color: "#222",
  };
  return <div style={style}>{children}</div>
}

export default Cell;