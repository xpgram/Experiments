
/* This is an information container, essentially.
 * For an individual tile on the map, keeps track of map data, inhabitants, iteration data, 
 */

class Cell {
  boolean wall = false;        // If true, tile is uninhabitable.
  boolean spawnPoint = false;  // Used to determine valid spawn-points.
  Team spawnTeam;              // Used to specify which team is allowed to spawn at this spawnPoint.
  Unit unit;                   // Reference to inhabiting unit.
  //Treasure treasure;           // Reference to inhabiting treasure object.  [A little beyond this stage of development]
  
  boolean moveTile = false;    // Used to highlight movement ranges.
  boolean attackTile = false;  // Used to highlight AoE or effective attack range.
  boolean aidTile = false;     // Used to highlight ally-targeting effective range.
  boolean dangerTile = false;  // Used to highlight enemy ranges.
  
  int holdValue = 0;           // Used when iterating over the grid (e.g. = Leftover MOV range in grid.generateMoveTiles() ).
  
  
  Cell() {
    unit = null;
  }
  
  
  // Cleans out anything temporary.
  // I may eventually want a version that doesn't get rid of dangerTiles.
  //void resetVisibilityFields() {
  void resetNonStaticFields() {
    this.moveTile = false;
    this.attackTile = false;
    this.aidTile = false;
    this.dangerTile = false;
    this.unit = null;
    //this.treasure = null;    // Would work the same way as unit, probably.
    this.holdValue = 0;
  }
}