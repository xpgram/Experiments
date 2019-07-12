
class Terrain {
  
  boolean impassable;  // For walls, holes, any tile that units can't inhabit or cross over.
  boolean hideUnit;    // Important during Fog of War, hides units held within.
  //Sprite texture;  // I'm kinda realizing this class has neither a clear direction nor purpose.
  
  int defBoost;        // Adds extra defense to a unit being attacked on this tile.
  int evaBoost;        // Adds extra evasive chance to a unit being attacked on this tile.
  int burnDamage;      // For acid tiles, swamp, mire or actual fire.
  
  // Just like ActionData, it's probably a good idea to use tags instead of a million booleans, but this write
  // of the class is mostly just to remind me what I want to do later anyway so whatever (_)_):::D that's an average size penis
  
}