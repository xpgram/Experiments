
/* Manages a team of units
 */

class BattleParty {
  Unit[] units;
  Team team;      // Reference to, and specifically for use by, TurnMachine.
  
  BattleParty(Team t, int size) {
    Unit unit;
    UnitStats stats;
    Point point;
    
    this.team = t;
    this.units = new Unit[size];
    
    //if (this.team == Team.Enemies) {      // Eventually useful for scripting randoms or loading allies from a file.
    
    for (int i = 0; i < size; i++) {
      stats = new UnitStats();
      point = new Point(0, 0);    // Puts them off screen, no one cares about them.
      unit = new Unit(point, this.team, stats);
      this.units[i] = unit;
    }
  }
  
  
  void spawnAllUnits() {
    Point p;
    for (int i = 0; i < units.length; i++) { 
      p = chooseSpawnPoint();
      units[i].setPos(p);
      units[i].activate();
    }
  }
  
  
  Point chooseSpawnPoint() {
    Point p = new Point();
    grid.buildNew();
    
    int side = (team == Team.Allies) ? 0 : 1;
    int horBounds = grid.boardWidth / 3;
    int verBounds = grid.boardHeight / 2;
    
    do {
      p.x = floor(random(0, horBounds));
      p.y = floor(random(0, verBounds));
      p.x += horBounds*2 * side;  // Changes sides of the field depending on which team we are.  | Bandaid solutions
      p.y += verBounds / 2;       // Just centers it vertically                                  | somewhat
    } while (!grid.cellOpen(p));
    
    return p;
  }
  
  // Checks each unit's HP and if one still has 1HP the team remains undefeated.
  boolean defeated() { return false; }
}