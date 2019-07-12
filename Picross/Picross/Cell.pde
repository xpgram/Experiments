/*

*/

class Cell {
  // Basic Vars
  boolean hiddenValue;  // True if the secret image includes this tile.
  CellState state;      // One of three possible values, representing the tile's form as a result of play on the board.
  
  // Error-Flash Animation Vars
  int anim_flashCounter;
  final int anim_flashTimer = 60;
  
  public Cell() {
    reset();
  }
  
  public Cell(boolean fill) {
    reset();
    this.hiddenValue = fill;
  }
  
  public void reset() {
    this.hiddenValue = false;
    this.state = CellState.empty;
  }
  
  public void randomSetup() {
    reset();
    this.hiddenValue = (random(1) < fillChance) ? true : false;
  }
  
  public boolean actionFill() {
    return actionFill(false);
  }
  
  public boolean actionFill(boolean onlyFill) {
    boolean result = false;
    
    // Filled -> Empty
    if (this.state == CellState.filled && !onlyFill) {
      this.state = CellState.empty;
      result = true;
      
    // Empty -> Filled || Blocked -> Filled
    } else if (this.hiddenValue == true) {
      this.state = CellState.filled;
      result = true;
      
    // HiddenValue = False --- Disallow
    } else {
      flash();
    }
    
    return result;
  }
  
  public boolean actionBlock() {
    return actionBlock(false);
  }
  
  public boolean actionBlock(boolean onlyBlock) {
    boolean result = false;
    
    // Blocked -> Empty
    if (this.state == CellState.blocked && !onlyBlock) {
      this.state = CellState.empty;
      result = true;
      
    // Empty -> Blocked
    } else if (this.state == CellState.empty) {
      this.state = CellState.blocked;
      result = true;
    }
    
    // Filled -> Blocked --- Disallow
      // Leave result = false
    
    return result;
  }
  
  public boolean actionEmpty() {
    this.state = CellState.empty;
    return true;
  }
  
  public boolean isIncorrect() {
    boolean result = false;
    
    if (this.state == CellState.filled &&
        this.hiddenValue == false)
      result = true;
    
    if (this.state == CellState.blocked &&
        this.hiddenValue == true)
      result = true;
    
    return result;
  }
  
  public void flash() {
    this.anim_flashCounter = anim_flashTimer;
  }
  
  public void update() {
    if (anim_flashCounter > 0)
      anim_flashCounter--;
  }
  
  public boolean isFlashing() {
    return (anim_flashCounter > 0) ? true : false;
  }
  
  public float getFlashOpacity() {
    return pow(((float)anim_flashCounter / anim_flashTimer), 2);
  }
}

enum CellState {
  empty,
  filled,
  blocked
}