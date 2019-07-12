
// I think my next goal should be to reorganize this whole thing a little.
// I should go through each file/class and explain what its supposed role is, and how it relates
// to all the others. Then I should rewrite-them-sorta so they fit it.
//
// If I'm going to rewrite-them-sorta, I should actually create a separate project and go through each class line-by-line.
// That's always how I went about writing second+ drafts of my essays.
// It would help me A) know for sure I'm not skipping over anything by accident
//                  B) keep any new function names or new class features consistent across the entire program
//                  C) apply in my writing a comprehensive style that is less ham-fist and more readable and organized.
// Some of these might be the same. In any case, I'll need to do this on my 4K monitor because my laptop's resolution is barely
// large enough to see all the tab names for this project on one window.

// Also, to make things slightly more professional-feeling, I want to put all these global, "static" objects
// in a wrapper class. I might need 3 or so in total, and I might call them BattleContainer, WorldContainer
// and PlayerContainer. Well, maybe not.
//
// BattleContainer    : Initializes whenever battle mode is entered. It builds the assembles Grid() and all
//                      the other things I have written here.
// WorldContainer     : Initializes whenever you ~leave~ battle mode. It builds all the stuff I haven't actually
//                      written yet.
//                      [The structural bits can be discarded and reloaded as needed (assuming memory footprint is an
//                      issue here), but some elements like enemy position, etc. should be held or at least saved.]
// PlayerContainer    : Initializes when you start the game or load from a save file. It's the piece that transitions
//                      all the relevant bits about the player between the game's two main modes (e.g. team members,
//                      equips, stats, etc.).
// AntagonistContainer: See [] note in WorldContainer entry.


// Constants
int _stdSize = 40;

// Global Objects    --I should make these singletons.
Grid grid;
EntitiesList entitiesList;
Selector select;
Menu cmdMenu;
TurnMachine turnMachine;
CombatManager combatManager;

void setup() {
  size(600, 400);
  
  entitiesList = new EntitiesList();
  grid = new Grid(entitiesList);
  select = new Selector();
  turnMachine = new TurnMachine();
  combatManager = new CombatManager();
  
  entitiesList.init();
  
  cmdMenu = new Menu();
}


void draw() {
  background(0);
  
  turnMachine.update();
  
  grid.show();
  select.show();
  
  for (int i = 0; i < entitiesList.units.length; i++) {
    entitiesList.units[i].show();
  }
  
  cmdMenu.show();
}


void keyPressed() {
  if (select.active) select.keyPressed();
  if (cmdMenu.active) cmdMenu.keyPressed();
}


void _drawReset() {
  fill(255);
  stroke(0);
}