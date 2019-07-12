
/* This class handles the process of applying an action to a target.
 */

class CombatManager {
  
  
  /* Takes in an action and applies it to a given target.
   */
  void enact(Unit actor, Unit target, ActionData action) {
    Unit[] targets = {target};
    enact(actor, targets, action);
  }
  
  
  /* Takes in an action and applies it to a given list of targets.
   */
  void enact(Unit actor, Unit[] targets, ActionData action) {
    // I'm going to have single-target attacks, AoE-type attacks, line-AoE-type attacks, etc.
    // I wonder if enact should also have an override for Point castLoc or something. Probably.
    
    // Also, I'll leave it just in case I need the actor's stats for some reason, but actor may be a useless field.
    
    for (int i = 0; i < targets.length; i++) {
      targets[i].stats.addHP(-action.POW + targets[i].stats.getDEF());
    }
  }
  
  
  boolean isAffectable(Unit actor, Unit target, ActionData action) {
    // Determines whether or not a target is truly "targetable."
    // Used in enact() and as a public method for determining whether a unit should shine or something,
    // showing that they would process the effect.
    return true;
  }
}