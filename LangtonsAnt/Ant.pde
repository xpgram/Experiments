
class Ant {
  Point loc;
  int dir;
  
  public Ant() {
    this.loc = new Point(_startLoc.x, _startLoc.y);
    this.dir = ANTLEFT;
  }
  
  public void update() {
    color state;
    int pix;
    
    // If the user has paused, don't change anything at all.
    if (_pause) return;
    
    for (int i = 0; i < _stepsPerCycle; i++) {
      pix = loc.x + loc.y * map.width;
      state = map.pixels[pix];
      
      // Flip colors
      if (state == color(WHITE)) {
        turnRight();
        map.set(this.loc.x, this.loc.y, color(BLACK));
      } else if (state == color(BLACK)) {
        turnLeft();
        map.set(this.loc.x, this.loc.y, color(WHITE));
      }
      
      // Move
      advance();
    }
  }
  
  public void turnRight() {
    this.dir += 1;
    if (this.dir > 3) this.dir = 0;
  }
  
  public void turnLeft() {
    this.dir -= 1;
    if (this.dir < 0) this.dir = 3;
  }
  
  public void advance() {
    // Move one square in a direction
    switch (dir) {
      case ANTUP:
        this.loc.y--;
        break;
      case ANTRIGHT:
        this.loc.x++;
        break;
      case ANTDOWN:
        this.loc.y++;
        break;
      case ANTLEFT:
        this.loc.x--;
        break;
    }
    
    // Loop edges, Pacman-style
    if (this.loc.x > width-1) this.loc.x = 0;
    if (this.loc.x < 0) this.loc.x = width-1;
    if (this.loc.y > height-1) this.loc.y = 0;
    if (this.loc.y < 0) this.loc.y = height-1;
    
    // Shift all path points one index over, and add the new loc to the beginning.
    for (int i = _pathMax-1; i > 0; i--) {
      path[i].clone(path[i-1]);
    }
    path[0].clone(this.loc);
  }
}