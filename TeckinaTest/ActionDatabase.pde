
// This class should be static, but processing doesn't really like those.
// It remembers the data for each and every active/passive equip and doles it out to whomever may be asking.
// The idea is to keep this massive amount of information in one place in memory--no duplicates.

// It could also load by request and clear() whenever a battle is over to reduce its memory footprint.

class ActionDatabase {
  
  ActionData nullAction;
  ActionData[] actionsList;
  
  
  ActionDatabase() {
    nullAction = new ActionData();
    this.emptyList();
  }
  // Destructor? I don't even know.
  
  
  /* One way or another, when loading assets, units are going to need to know the name and not all the little details.
   * This method will return an ActionData object the unit/etc. can hold a pointer to, and if one doesn't exist it will load one.
   * The ActionData object is where the actual FileIO happens, though.
   */
  ActionData search(String name) {
    ActionData action;
    
    // Search memory for the request
    int idx;
    for (idx = 0; idx < actionsList.length; idx++) {
      if (name.equals(actionsList[idx].actionName))
        break;
    }
    
    // If request was found:
    if (idx < actionsList.length) {
      action = actionsList[idx];
    } else {
      // A valid action wasn't found.
      
      // Try to load one.
      action = new ActionData();
      action.load(name);
      
      if (action.valid) {
        // Push action into the actionsList array
      } else {
        // The action could not be loaded.
        action = nullAction;  // Single-memory location for [action.valid = false] object.
      }
    }
    
    return action;
  }
  
  
  // Dumps details, freeing memory (in theory).
  void emptyList() {
    actionsList = new ActionData[0];
    // How do I know old info was deleted? If references exist elsewhere, it may not have been.
    // Perhaps units need know their equip's names, and another object which gets built for battlemode and destroyed afterward
    // is what actually holds the references to its action data?
  }
}