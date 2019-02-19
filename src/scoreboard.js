import React, { Component } from 'react';
import Grid from '@material-ui/core/Grid';
import './scoreboard.css';
import GDScore from './guandan';
import { Button, Dialog, DialogActions, DialogTitle, DialogContent, DialogContentText, AppBar, Toolbar, Typography, IconButton, Menu, MenuItem } from '@material-ui/core';
import MenuIcon from '@material-ui/icons/Menu';
import MoreVertIcon from '@material-ui/icons/MoreVert';

class Scoreboard extends Component {
  constructor(props) {
    super(props);
    this.scoreboard = new GDScore();
    this.state = {
      leftCurrent: this.scoreboard.leftScoreString(),
      rightCurrent: this.scoreboard.rightScoreString(),
      winModalVisible: false,
      anchorEl: null,
    };
  }

  updateLeftScore = (rank1, rank2) => {
    this.updateScore('l', rank1, rank2);
  }

  updateRightScore = (rank1, rank2) => {
    this.updateScore('r', rank1, rank2);
  }

  updateScore = (team, rank1, rank2) => {
    this.scoreboard.updateScore(team, rank1, rank2);
    if (this.scoreboard.winner !== null) {
      this.setState({
        winModalVisible: true,
      })
    }
    this.setState({
      leftCurrent: this.scoreboard.leftScoreString(),
      rightCurrent: this.scoreboard.rightScoreString(),
    });
  }

  closeModal = () => {
    this.setState({
      winModalVisible: false,
    });
  }

  openMenu = (event) => {
    this.setState({
      anchorEl: event.currentTarget,
    });
  }

  closeMenu = () => {
    this.setState({
      anchorEl: null,
    });
  }

  newGame = () => {
    this.scoreboard.newGame();
    this.setState({
      winModalVisible: false,
      leftCurrent: this.scoreboard.leftScoreString(),
      rightCurrent: this.scoreboard.rightScoreString(),
    });
  }

  resetGame = () => {
    this.scoreboard.reset();
    this.setState({
      winModalVisible: false,
      leftCurrent: this.scoreboard.leftScoreString(),
      rightCurrent: this.scoreboard.rightScoreString(),
    });
  }

  render() {
    return (
      <div style={{margin: 32}}>
        <AppBar position='fixed'>
          <Toolbar>
            <IconButton color='inherit' style={{marginRight: 16}} onClick={this.props.handleOpen}>
              <MenuIcon />
            </IconButton>
            <Typography variant='h6' color='inherit' style={{flexGrow: 1}}>
              记分
            </Typography>
            <IconButton color='inherit' onClick={this.openMenu}>
              <MoreVertIcon />
            </IconButton>
          </Toolbar>
        </AppBar>
        <Menu
          id='more-menu' 
          anchorEl={this.state.anchorEl} 
          open={Boolean(this.state.anchorEl)} 
          onClose={this.closeMenu}
        >
          <MenuItem onClick={() => {
            this.closeMenu();
            this.newGame();
          }}>重设本局比分</MenuItem>
          <MenuItem onClick={() => {
            this.closeMenu();
            this.resetGame();
          }}>重设总比分</MenuItem>
        </Menu>
        <Grid container spacing={32} style={{marginBottom: '16pt', marginTop: 64}}>
          <Grid item xs container direction='column' justify='center' alignItems='stretch' spacing={16}>
            <Grid item>
              <div className='current' style={{color: this.scoreboard.currentPlay === 'l' ? '#4055B2' : 'black'}}>
                {this.state.leftCurrent}
              </div>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateLeftScore(1, 2);
              }}>双上</Button>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateLeftScore(1, 3);
              }}>一三名</Button>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateLeftScore(1, 4);
              }}>一四名</Button>
            </Grid>
          </Grid>
          <Grid item xs container direction='column' justify='center' alignItems='stretch' spacing={16}>
            <Grid item>
              <div className='current' style={{color: this.scoreboard.currentPlay === 'r' ? '#4055B2' : 'black'}}>
                {this.state.rightCurrent}
              </div>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateRightScore(1, 2);
              }}>双上</Button>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateRightScore(1, 3);
              }}>一三名</Button>
            </Grid>
            <Grid item>
              <Button variant='contained' size='large' color='primary' fullWidth={true} onClick={() => {
                this.updateRightScore(1, 4);
              }}>一四名</Button>
            </Grid>
          </Grid>
        </Grid>
        <Grid container xs direction='column'>
          <Grid item xs>
            <span style={{fontWeight: 'bold'}}>总比分</span>
          </Grid>
          <Grid item xs container direction='row' justify='center'>
            <Grid item xs>
              <div className='totalScore'>{this.scoreboard.leftTotal}</div>
            </Grid>
            <Grid item xs>
              <div className='totalScore'>{this.scoreboard.rightTotal}</div>
            </Grid>
          </Grid>
        </Grid>
        <Dialog
          open={this.state.winModalVisible}>
          <DialogTitle>恭喜</DialogTitle>
          <DialogContent>
            <DialogContentText>
              {`${this.scoreboard.winner === 'l' ? '左' : '右'}边队伍获胜！点击新比赛开始重新记分。点击重设将清零总比分。`}
            </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Button onClick={this.resetGame} color='secondary'>重设</Button>
            <Button onClick={this.newGame} color='primary'>新比赛</Button>
          </DialogActions>
        </Dialog>
      </div>
    )
  };
}

export default Scoreboard;