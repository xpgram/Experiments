// Okay, tall order here because this is where ~most~ of the battle system happens.
// I think.
//
// So, my vision for it this:
// TurnState kinda lays it all out in sequence already, but
// TurnMachine should always know what the player is doing. Or the AI too, I guess.
//
// It handles pre-turn setup
// it tells the game to activate the field cursor or open the action menu
// it (depending on chosen action) knows what kind of target the action needs to work
// it waits for the player to confirm choices
// it tells the engine to carry out effects
// it checks each team to make sure they still have active units
// if not, changes turns and reenters pre-turn setup
// it also checks if each team has any living units
// if not, determines a winner and tells the game to display the outcome


// I need cancel and rollback features!
// Sorta easy to implement, I just gotta set targetPos and curUnit and all that shit to null. And then change states back, obviously.
// Damn this shit's getting complicated. I'm still hanging in there though.


//     States (defined in "Enums")
// MatchSetup, PreTurnSetup,                   // State 0: Set turn to player's turn.
// PickUnit, PickMoveTile, PickAction,         // The first three things all units do.
// PickEnemy, PickAlly, PickTarget, PickTile,  // Different kinds of action qualifiers.
// Confirm, Act,                               // Player confirm and carry out effects.
// CheckUnits, ChangeTurn,                     // If all teamUnits are inactive -> next
// Win, Lose                                   // End of match


//   State Machine v2
// v2 will use interfaces instead of functions.
// Each interface will need these methods:
//   init()      Called once when state is opened.
//   update()    Called every frame so long as state is active.
//   advance()   Called once when the state is being progressed into the next one.
//   recede()    Called once when the state is being retrogressed into the previous one.
//   close()     Called once when either advance() or recede() is called, or when changeState(state s) is called. Ensures opened things are properly closed.
// Should I learn about push() and pop()? Or, how to invoke them, anyway.
// Each state, when advanced, should push itself onto the stack, I think, and pop when receded back to.
// When the turn sequence is returned to PickUnit, each intermediary state gets popped and discarded to save memory.
  

class TurnMachine {
  Team curTeam;            // Which team is currently taking their turn.
  Unit curUnit;            // Which unit is being handled (useful when one has been selected).
  Point oldPos;            // The selected unit's old position (necessary for B-cancel).
  Point newPos;            // Where the unit is moving this turn. (Not sure I actually need this).
  ActionData turnAction;   // What action will be executed against the target unit/tile.
  Point targetPos;         // Where an AoE/other attack is being directed. Not always used.
  Unit targetUnit;         // Which unit is being attacked, healed, etc.
  
  TurnState state;
  boolean stateInit;
  
  ActionData waitCmd;      // Defines the "Wait" command always present on every unit's command list.
  
  
  TurnMachine() {
    this.stateInit = false;
    matchSetup();
  }
  
  
  void update() {
    
    switch(state) {
      case PreTurnSetup:
        preTurnSetup();
        break;
      case PickUnit:
        pickUnit();
        break;
      case PickMoveTile:
        pickMoveTile();
        break;
      case PickAction:
        pickAction();
        break;
      case PickTarget:
        pickTarget();
        break;
      case Confirm:
        confirm();
        break;
      case Act:
        act();
        break;
      //case CheckUnits:
      default:
        changeState(TurnState.PreTurnSetup);
        break;
    }
  }
  
  
  void changeState(TurnState s) {
    if (this.state != s) {
      this.state = s;
      stateInit = true;
    }
  }
  
  
  void matchSetup() {
    // Build entity list?
    curTeam = Team.Allies;
    waitCmd = new ActionData();     // waitCmd is also waitCmd.valid == false.
    waitCmd.actionName = "Wait";    // I think ActionData should know what Wait is, and there should be a way to set it (without loading it from a file).
    changeState(TurnState.PreTurnSetup);
  }
  
  
  void preTurnSetup() {
    activateAllTeamUnits();    // This needs to happen at start of turn.
    
    // vvv This and below needs to happen everytime you need to pick a new unit.
    
    curUnit = null;
    oldPos = null;
    newPos = null;
    turnAction = null;
    targetPos = null;
    targetUnit = null;
    grid.buildNew();
    
    changeState(TurnState.PickUnit);
  }
  
  
  void pickUnit() {
    if (stateInit == true) {
      select.createNew(TargetType.Ally);
      stateInit = false;
    }
    
    if (this.curUnit != null)
      changeState(TurnState.PickMoveTile);
  }
  
  
  void pickMoveTile() {
    if (stateInit == true) {
      select.createNew(TargetType.MoveTile);
      grid.generateMoveTiles(this.curUnit.pos, this.curUnit.stats.MOV);
      stateInit = false;
    }
    
    if (this.newPos != null) {
      select.active = false;
      grid.eraseMoveTiles();
      changeState(TurnState.PickAction);
    }
  }
  
  
  void pickAction() {
    if (stateInit == true) {
      boolean leftSide = ((this.curUnit.pos.x * grid.cellSize) > (width / 2));
      cmdMenu.createNew(curUnit.stats.equipsList, leftSide);
      stateInit = false;
    }
    
    if (this.turnAction != null) {
      cmdMenu.active = false;
      
      if (this.turnAction != this.waitCmd) {
        changeState(TurnState.PickTarget);
      } else {    // Player picked "Wait"
        changeState(TurnState.CheckUnits);
      }
    }
  }
  
  
  void pickTarget() {
    if (stateInit == true) {
      select.createNew(this.turnAction.targetType);
      grid.generateActionTiles(this.curUnit.pos, this.turnAction);
      stateInit = false;
    }
    
    if (this.targetPos != null) {
      select.active = false;
      grid.eraseActionTiles();
      changeState(TurnState.Confirm);
    }
  }
  
  
  void confirm() {
    changeState(TurnState.Act);
  }
  
  
  void act() {
    combatManager.enact(this.curUnit, grid.getUnit(this.targetPos), this.turnAction);
    changeState(TurnState.CheckUnits);
  }
  
  
  void activateAllTeamUnits() {
    // iterate over global entity list, setting all with same team to active.
  }
  
  
  void declareCurUnit(Unit u) {
    this.curUnit = u;
    this.oldPos = new Point(this.curUnit.pos);
  }
  
  
  void declareMoveTile(Point p) {
    this.newPos = new Point(p);
    this.curUnit.setPos(p);
  }
  
  
  void declareTargetLoc(Point p) {
    this.targetPos = new Point(p);
  }
  
  
  void cmdSubmitOption(int n) {
    if (n < this.curUnit.stats.equipsList.length) {
      this.turnAction = this.curUnit.stats.equipsList[n];
    } else {  // Player selected "Wait" command.
      this.turnAction = this.waitCmd;
    }
  }
}