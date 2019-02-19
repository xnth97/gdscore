import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';
import Sidebar from './sidebar';
import Scoreboard from './scoreboard';
import AboutPage from './about';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      drawerVisible: false,
      selectedIndex: 0,
    };
  }

  openDrawer = () => {
    this.setState({
      drawerVisible: true,
    })
  }

  closeDrawer = () => {
    this.setState({
      drawerVisible: false,
    })
  }

  render() {
    return (
      <div>
        <Sidebar
         visible={this.state.drawerVisible}
         handleClose={this.closeDrawer}
        />
        <div>
          <Switch>
            <Route 
              exact path='/' 
              render={(props) => <Scoreboard {...props} handleOpen={this.openDrawer} />} 
            />
            <Route 
              path='/about'
              render={(props) => <AboutPage {...props} handleOpen={this.openDrawer} />} 
            />
          </Switch>
        </div>
      </div>
    );
  }
}

export default App;
