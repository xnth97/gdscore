import React, { Component } from 'react';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Divider from '@material-ui/core/Divider';
import Drawer from '@material-ui/core/Drawer';
import { Link } from 'react-router-dom';
import { Info, Dashboard } from '@material-ui/icons';

class Sidebar extends Component {
  constructor(props) {
    super(props);
    this.state = {
      
    };
  }

  handleClose = () => {
    this.props.handleClose();
  }

  render() {
    return (
      <Drawer
       open={this.props.visible}
       onClose={this.handleClose}
      >
        <div style={{width: 'auto', minWidth: 250}} >
          <Divider />
          <List>
            <ListItem button key='score' component={Link} to='/' onClick={this.handleClose}>
              <ListItemIcon><Dashboard /></ListItemIcon>
              <ListItemText primary='记分' />
            </ListItem>
            {/* <ListItem button key='records' component={Link} to='/records' onClick={this.handleClose}>
              <ListItemText primary='历史记录' />
            </ListItem> */}
          </List>
          <Divider />
          <List>
            <ListItem button key='about' component={Link} to='/about' onClick={this.handleClose}>
              <ListItemIcon><Info /></ListItemIcon>
              <ListItemText primary='关于' />
            </ListItem>
          </List>
        </div>
      </Drawer>
    );
  }
}

export default Sidebar;