import React, { Component } from 'react';
import { Grid, AppBar, Toolbar, Typography, IconButton } from '@material-ui/core';
import MenuIcon from '@material-ui/icons/Menu';

class AboutPage extends Component {
  render() {
    return (
      <div style={{marginLeft: '36pt', marginRight: '36pt', marginTop: '40%'}}>
        <AppBar position='fixed'>
          <Toolbar>
            <IconButton color='inherit' style={{marginRight: 16}} onClick={this.props.handleOpen}>
              <MenuIcon />
            </IconButton>
            <Typography variant='h6' color='inherit'>
              关于
            </Typography>
          </Toolbar>
        </AppBar>
        <Grid container justify='center'>
          <Grid item>
            <div style={{textAlign: 'center'}}>
            gdscore v1.0 <br/><br/>
            <b>gdscore</b> 是一个自娱自乐的简易掼蛋记分工具。
            </div>
          </Grid>
        </Grid>
      </div>
    )
  };
}

export default AboutPage;