// Rewrites again!
// I want to make this class my first example of a singleton. I only ever need one instance anyway.
// I also want to make it a little more self-dependent.
//   - Any time buildMoveTiles() is called, it should call buildNew() itself.
//   - For similar functions, it should do the same. Ideally, I shouldn't need to call buildNew() outside of this file.
//   - Currently, generateWalls() adds them to a list and then adds the list to the board.
//         I no longer erase them every clean() call, so having the list is probably silly now.
// This will not be the only singleton; all my global, single instance classes will follow grid's lead.
// To avoid interlocking confusion (I've experience some already), they should all follow this pattern:
//   - Construct, creating all variables so they're all referenceable, etc. This ~will not~ depend on anything outside of this class.
//   - Initialize, so they're actually useable. This is allowed to depend on other things outside of this class.
//   - Maybe an isInitialized() method for my own benefit (so I can catch interlocking-confusions before they happen).

class Grid {
  private Grid grid;      // This will be my singleton.
                          // There are three major steps to making this work:
                          //   - Constructor is private so no one else can create one
                          //   - This private, static variable is the only instance
                          //   - There is a public method which returns (or builds, if 1st time)
                          //         the static class when called.
  
  int cellSize = _stdSize;
  int boardWidth = width/cellSize;
  int boardHeight = height/cellSize;
  Cell[][] board;
  
  EntitiesList entitiesList;
  Point[] wallsList;  // Like, uninhabitable tiles.
  //Other entity lists? What else appears on the map?
  
        // Instead of passing it, maybe I should just reference it like I do all the other globals.
        // At least it would be consistent.    All globals should construct first before any initialize.
  Grid(EntitiesList list) {
    entitiesList = list;
    
    init();
    generateWalls(20);
  }
  
  
  void init() {
    board = new Cell[boardWidth][boardHeight];
    for (int i = 0; i < boardWidth; i++) {
      for (int j = 0; j < boardHeight; j++) {
        board[i][j] = new Cell();
      }
    }
  }
  
  
  void show() {
    Point p = new Point();
    Cell cell;
    
    for (p.x = 0; p.x < boardWidth; p.x++) {
      for (p.y = 0; p.y < boardHeight; p.y++) {
        cell = board[p.x][p.y];
        if (cell.wall) drawWall(p);
        if (cell.dangerTile) drawDangerTile(p);
        if (cell.moveTile) drawMoveTile(p);
        if (cell.attackTile) drawAttackTile(p);
        if (cell.aidTile) drawAidTile(p);
        drawCellLines(p);
      }
    }
  }
  
  
  void drawCellLines(Point p) {
    stroke(63);
    noFill();
    rect(p.x*cellSize, p.y*cellSize, cellSize, cellSize);
  }
  
  
  void drawColorTile(Point p, int r, int g, int b) {
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    fill(r, g, b);
    noStroke();
    rect(p.x*cellSize, p.y*cellSize, cellSize, cellSize);
  }
  
  
  void drawMoveTile(Point p) {
    drawColorTile(p, 15, 30, 60);
  }
  
  
  void drawAttackTile(Point p) {
    drawColorTile(p, 60, 0, 0);
  }
  
  
  void drawDangerTile(Point p) {
    drawColorTile(p, 60, 60, 0);
  }
  
  
  void drawAidTile(Point p) {
    drawColorTile(p, 0, 60, 0);
  }
  
  
  void drawWall(Point p) {
    drawColorTile(p, 255, 255, 255);
  }
  
  
  int getGridRow(int y) {
    return y / cellSize;
  }
  
  
  int getGridCol(int x) {
    return x / cellSize;
  }
  
  
  boolean cellOpen(Point p) {
    Cell cell = board[p.x][p.y];
    if (cell.wall == false)
      if (cell.unit == null)
      return true;
    
    // Else
    return false;
  }
  
  
  boolean cellOccupied(Point p) {
    return (board[p.x][p.y].unit != null);
  }
  
  
  Cell getCell(Point p) {
    return board[p.x][p.y];
  }
  
  
  Unit getUnit(Point p) {
    return board[p.x][p.y].unit;
  }
  
  
  void clean() {
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        board[i][j].resetNonStaticFields();
      }
    }
  }
  
  
  void buildNew() {
    clean();
    
    // Add all character objects to the map. 
    for (int i = 0; i < entitiesList.units.length; i++) {
      if (validPoint(entitiesList.units[i].pos))
        board[entitiesList.units[i].pos.x][entitiesList.units[i].pos.y].unit = entitiesList.units[i];
    }
  }
  
  
  void generateMoveTiles(Point source, int range) {
    buildNew();    // Update our snapshot.
    
    getCell(source).moveTile = true;    // Source unit can always wait at their current location.
    getCell(source).holdValue = range;
    
    generateMoveTilesH(source.move(-1, 0), range);
    generateMoveTilesH(source.move(1, 0), range);
    generateMoveTilesH(source.move(0, -1), range);
    generateMoveTilesH(source.move(0, 1), range);
  }
  
  
  private void generateMoveTilesH(Point source, int range) {
    if (range < 0) return;                                      // Halt if out of range.
    
    if (!validPoint(source)) return;                            // Stay inside grid[][] bounds.
    
    if (getCell(source).holdValue >= range) return;             // Halt if we've already fully explored this location's possibilities.
    if (getCell(source).wall == true) return;                   // Halt if wall encountered.
    
    if (getUnit(source) != null &&                              // Halt if tile is not empty and
        turnMachine.curTeam != getUnit(source).team) return;    // non-empty tile contains an enemy.           [grid.passable(Point p) ?]
    
    if (getUnit(source) == null) {                              // Only enable tile if tile is inhabitable.    [grid.inhabitable(Point p) ?]
      getCell(source).moveTile = true;    // This method should be adapted to also generate an enemy's danger range tiles.
      getCell(source).holdValue = range;
    }
    
    generateMoveTilesH(source.move(-1, 0), range - 1);
    generateMoveTilesH(source.move(1, 0), range - 1);
    generateMoveTilesH(source.move(0, -1), range - 1);
    generateMoveTilesH(source.move(0, 1), range - 1);
  }
  
  
  void generateActionTiles(Point source, ActionData action) {
    buildNew();    // Update our snapshot.
    
    int x = 0;
    int y = -action.Range;
    int xdist = 1;
    Point p = new Point();
    Cell cell;
    boolean targetAny = (action.targetType == TargetType.AnyTile);
    boolean targetAllies = (action.targetType == TargetType.Ally);
    boolean sameTeam;
    
    for (y = -action.Range; y <= action.Range; y++) {
      xdist = action.Range - abs(y);
      for (x = -xdist; x <= xdist; x++) {
        p.x = source.x + x;
        p.y = source.y + y;
        
        // Skip points off the board
        if (!validPoint(p)) continue;
        
        cell = getCell(p);
        
        // Omit walls
        if (cell.wall == true) continue;
        
        // Omit null range
        if (source.taxiCabDistance(p) <= action.nullRange) continue;
        
        // Omit invalid units
        if (cell.unit != null && !targetAny) {
          sameTeam = (cell.unit.team == turnMachine.curTeam);
          if (targetAllies != sameTeam) {
            continue;
          }
        }
        
        
        // Light up the tile properly
        if (targetAllies) {
          cell.aidTile = true;
        } else {
          cell.attackTile = true;
        }
        
      }
    }
  }
  
  
  void eraseMoveTiles() {
    for (int x = 0; x < boardWidth; x++) {
      for (int y = 0; y < boardHeight; y++) {
        getCell(new Point(x, y)).moveTile = false;
      }
    }
  }
  
  
  void eraseActionTiles() {
    Cell cell;
    for (int x = 0; x < boardWidth; x++) {
      for (int y = 0; y < boardHeight; y++) {
        cell = getCell(new Point(x, y));
        cell.attackTile = false;
        cell.aidTile = false;
      }
    }
  }
  
  
  boolean validPoint(Point source) {
    if (source.x < 0 || source.x > boardWidth - 1 ||
        source.y < 0 || source.y > boardHeight - 1)
      return false;
      
    return true;
  }
  
  
  void generateWalls(int n) {
    wallsList = new Point[n];
    Point p;
    
    for (int i = 0; i < n; i++) {
      p = new Point();
      
      do {
        p.x = floor(random(boardWidth));
        p.y = floor(random(boardHeight));
      } while (board[p.x][p.y].wall == true);
      
      wallsList[i] = p;
    }
    
    // Add all walls
    for (int i = 0; i < wallsList.length; i++) {
      board[wallsList[i].x][wallsList[i].y].wall = true;
    }
  }
}