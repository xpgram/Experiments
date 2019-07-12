
// This class holds the unit's equipment in memory and has methods to aid in accessing them.
// To getPOW(), for instance, we need to know the action being used ~and~ we need to iterate over all
// the unit's attributes for any POWbonus effects.

class UnitEquipment {
  private int[] equipIDs;
  private String equipNames;    // I think IDs would be more useful, but I have both because I'm not sure yet.
  private Unit parent;          // A reference to the instantiating object.
  
  private ActionData[] commandList;
  private ActionData[] attributeList;
  
  
  public UnitEquipment(Unit _parent) {
    this.parent = _parent;
  }
  
  
  // This is feeling a little ridiculous.
  // I think I should just build representations of the actions with their bonuses already applied.
  // That way, I wouldn't have to build the same for loop over and over again for getPOW, getACC, getRange, getAP, getEffectsList, etc.
  // Of course, that for loop might not be the same exact thing for every one of those methods. getACC probably has different qualifiers for
  // bonuses. Maybe. Oh, you know what? I should just put the for loop in a helper function. I would just need to figure out how to access
  // ACCbonus instead of POWbonus when the appropriate method is called... hm.
  // Anyway, my point is, kinda, that I was probably trying to preserve each action's original dataset for the command window, where the player would see it.
  // But, I don't really need to do that. The player only cares about what POW the action will actually use, even in the menu. Obvious, honestly.
  public int getPOW(int idx) {
    if (! isValidIndex(idx)) { return 0; }
    
    int out = commandList[idx].POW;
    for (int i = 0; i < attributeList.length; i++) {
      //out += attributeList[i].POWbonus;
      // Honestly, I expect the full gamut to be more complicated.
      // POWbonus, for instance, might only apply if the accessory's specified attack type and the action type match up.
      // Like, +2 to explosive weapons. See?
    }
    
    return out;
  }
  
  
  public int getCommandIndex(ActionData action) {
    int idx = -1;
    
    for (int i = 0; i < commandList.length; i++) {
      if (commandList[i] == action) {
        idx = i;
        break;
      }
    }
    
    return idx;
  }
  
  
  public ActionData getAction(int idx) {
    if (! isValidIndex(idx)) { return null; }
    return commandList[idx];
  }
  
  
  public int getNumCommands() {
    return commandList.length;
  }
  
  
  private boolean isValidIndex(int idx) {
    if (idx < 0 || idx >= commandList.length) {
      // Throw exception.
      println("Tried to access invalid commandList index.");
      return false;
    }
    
    return true;
  }
}