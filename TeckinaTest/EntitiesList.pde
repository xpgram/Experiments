
class EntitiesList {
  int NUM_ALLIES = 3;
  int NUM_ENEMIES = 3;
  
  Unit[] units;
  BattleParty allies;
  BattleParty enemies;
  
  EntitiesList() {
    units = new Unit[NUM_ALLIES + NUM_ENEMIES];
    allies = new BattleParty(Team.Allies, NUM_ALLIES);
    enemies = new BattleParty(Team.Enemies, NUM_ENEMIES);
    
    for (int i = 0; i < allies.units.length; i++) {
      units[i] = allies.units[i];
    }
    for (int i = 0; i < enemies.units.length; i++) {
      units[i+NUM_ALLIES] = enemies.units[i];
    }
  }
  
  void init() {
    allies.spawnAllUnits();
    enemies.spawnAllUnits();
  }
}