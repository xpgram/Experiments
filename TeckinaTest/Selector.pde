// Player Turn
// Field Selector    ::Just needs to remember pos. Use grid.getCell(x,y) to get units.
// Menu              ::Similar selector object. Will need to write menu object.
// Field Selector    ::Same, but now selects other team, or open tiles to move to, etc.
// Menu (Confirm)    ::Just let the player press 'A' twice to avoid mistakes.
// Repeat            ::Other active units?
// End Turn          ::Once all units are inactive.

class Selector {
  Point pos;           // The cursor's current position.
  Point rangeSource;   // If there is a range restriction, this is the origin point.
  int range;           // If there is a range restriction, this is it.
  TargetType target;   // Tells us what kind of tile is a valid selection.
  boolean active;      // Tells us whether the cursor should be drawn/moveable.
  
  int animTimer = 0;
  int animTMax = 30;
  int animState = 0;
  
  // Grid should handle which tiles are selectable, huh? I think that was my
  // original plan.
  // Okay, grid is kind of a state machine. If movement tiles need to be drawn or
  // remembered (they will), then grid knows which ones. Selector, however, is the
  // one that determines whether a tile-select is valid or not.
  // If target == ALLY, selector asks if (grid.getCell().unit != null)
  // If target == ENEMY, same deal but also ask (.unit.team == turnMachine.team)
  // If target == EMPTY, selector asks if .getCell() == null and .wall == false.
  
  
  Selector() {
    pos = new Point();
    rangeSource = new Point();
    active = false;
  }
  
  
  void show() {
    if (active) {
      updateAnim();
      
      stroke(255);
      noFill();
      int border = _stdSize/16 * animState;    // Hamfisted animation step, but makes it look livelier/nicer.
      int x = pos.x * _stdSize + border;
      int y = pos.y * _stdSize + border;
      int len = _stdSize / 4;
      int box = _stdSize - border*2;
      
      line(x, y, x+len, y);  // T-L corner
      line(x, y, x, y+len);
      
      line(x+box, y, x+box-len, y);  // T-R corner
      line(x+box, y, x+box, y+len);
      
      line(x, y+box, x+len, y+box);  // B-L corner
      line(x, y+box, x, y+box-len);
      
      line(x+box, y+box, x+box-len, y+box);  // B-R corner
      line(x+box, y+box, x+box, y+box-len);
    }
  }
  
  
  void updateAnim() {
    animTimer--;
    if (animTimer < 0) {
      animTimer = animTMax;
      if (animState == 0) {
        animState = 1;
      } else {
        animState = 0;
      }
    }
  }
  
  
  void createNew(TargetType t) {
    createNew(this.pos, t, this.rangeSource, -1);
  }
  void createNew(Point newPos, TargetType t) {
    createNew(newPos, t, this.rangeSource, -1);
  }
  void createNew(TargetType t, Point source, int range) {
    createNew(this.pos, t, source, range);
  }
  void createNew(Point newPos, TargetType t, Point source, int range) {
    active = true;
    setPos(newPos);
    setTarget(t);
    setRange(source, range);
  }
  
  void setPos(Point p) {
      this.pos.clone(p);
  }
  
  void setTarget(TargetType t) {
    this.target = t;
  }
  
  void setRange(Point source, int range) {
    this.rangeSource.clone(source);
    this.range = range;
  }
  
  
  void move(int x, int y) {
    if (active) {
      // grid should really be passed in as an object, but Processing doesn't make
      // me do that, so... it's fine, I guess?
      if (pos.x + x >= 0 && pos.x + x < grid.boardWidth)
        pos.x += x;
      if (pos.y + y >= 0 && pos.y + y < grid.boardHeight)
        pos.y += y;
    }
  }
  
  
  boolean checkRange(Point p) {
    if (this.range < 0) return true;
    return (this.rangeSource.taxiCabDistance(p) <= this.range);
  }
  
  
  void checkCell() {
    if (!checkRange(pos))
      return;
      
    Cell cell = grid.getCell(pos);
    boolean targetAllies = (target == TargetType.Ally);
    
    if (target == TargetType.Ally) {
      if (grid.cellOccupied(pos) && cell.unit.team == turnMachine.curTeam) {
        turnMachine.declareCurUnit(cell.unit);    // Ooh, I see a problem. How do we know this is curUnit? TurnMachine should figure that out.
        //turnMachine.declareTargetLoc(this.pos);
      }
      
    } else if (target == TargetType.Enemy) {
      if (grid.cellOccupied(pos) && cell.attackTile == true) {
        turnMachine.declareTargetLoc(this.pos);
      }
      
    } else if (target == TargetType.MoveTile) {
      if (cell.moveTile == true) {
        turnMachine.declareMoveTile(pos);
      }
      
    } else if (target == TargetType.OpenTile) {
      if (grid.cellOpen(pos)) {
        // Replace with grid function, available()? If I add more qualifiers.
        //turnMachine.fieldSelect();
      }
    } else if (target == TargetType.AnyTile) {
      
    } else {
      // ?
      // I mean, in theory, we should never be here. Doing nothing is fine.
    }
  }
  
  
  void keyPressed() {
    if (keyCode == LEFT)  move(-1, 0);
    if (keyCode == RIGHT) move(1, 0);
    if (keyCode == UP)    move(0, -1);
    if (keyCode == DOWN)  move(0, 1);
    
    if (key == ' ') checkCell();
  }
}