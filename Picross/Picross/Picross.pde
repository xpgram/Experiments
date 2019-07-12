
/*

Picross !

[Update]
THIS SHIT IS PERFECT ALMOST!
The only thing it's missing is the greying out of individual clue numbers when you've found their
only possible position. Like, if there's a [5 3] and you have on the board what is ~clearly~ the
[5] in that clue, my game doesn't inform you. But other than that, I think I accomplished
everything I wrote that I wanted to down below, so hell yeah!

Configure board size.
Tiles on board are either [ ] empty, [#] filled, or [x] blocked.
"Tiles" outside the board, on the left and above, are used to display the Clue numbers.
So, the board does not display over the entire view screen.
The mouse is used to change tiles.
  Left Click : Fill : Empty
  Right Click : Block : Empty
  Middle Click : Empty
You can also hold any of the 3 mouse buttons to paint the board.
When painting, only the first action performed may be performed on other tiles.
This means if the player clicks to fill, holds the button, and move across the board, only empty tiles will be filled.
  Blocked tiles will not be affected, and filled tiles will not be emptied.
So, in terms of controls, the performable actions are:
  Empty -> Filled
  Empty -> Blocked
  Blocked -> Filled
  Filled -> Empty
  Blocked -> Empty

When the player tries to perform [Empty -> Filled] on an incorrect tile, the game will flash the tile red and disallow the move.
When the player has blocked an incorrect tile, the Clue numbers along the relevant row or column turn red to indicate it is incorrect.

Randomly generate this board, bb.

Clue numbers auto write themselves at the beginning of play.
Clue numbers also change color (white -> gray) when they are "completed" on the board.

A counter for "Remaining Unfound Tiles" keeps track of how "unfinished" the picture is.
When the counter reaches 0, the game is completed, and the background turns green why not.
A little animation of a virtual, androgynous human-thing jerking the player off appears, to further congratulate them
and fill them with success and prideful feelings.
*/


// Global Vars
final float fillChance = 0.60;
final int cellSize = 50;
final int numClueNumbers = 5;    // If you can't see all the numbers, I think you just need to ++ this value.
final int boardx = 10;
final int boardy = 10;

final int windowCellX = boardx + numClueNumbers;
final int windowCellY = boardy + numClueNumbers;
Cell[][] board = new Cell[boardx][boardy];
String[] rowClues = new String[boardx];
String[] colClues = new String[boardy];

final int paddingRight = cellSize*2;
final int paddingBottom = cellSize*2;
final int windowWidthInit = windowCellX * cellSize + paddingRight;
final int windowHeightInit = windowCellY * cellSize + paddingBottom;

int lastGridX = -1;
int lastGridY = -1;

boolean gameWon = false;

DrawShapes shape = new DrawShapes();

// Passively setup the screen stuff.
void settings() {
  size(windowWidthInit, windowHeightInit);
}

// Begin, Boys
void setup() {
  
  // Initiate and build the game board.
  for (int x = 0; x < boardx; x++) {
    for (int y = 0; y < boardy; y++) {
      board[x][y] = new Cell();
      board[x][y].randomSetup();
    }
  }
  
  // Build the Clue numbers that pair with each row and column.
  int groupCount;
  
  // Row Clue Numbers
  for (int r = 0; r < boardy; r++) {
    rowClues[r] = "";
    groupCount = 0;
    for (int i = boardx-1; i >= 0; i--) {
      if (board[i][r].hiddenValue == true) {
        // If a filled cell was encountered, add it to our growing count of the current group we're looking at right now at this specific moment in time.
        groupCount++;
      } else {
        // If a space is encountered, and a group was being counted, add it to the clues.
        if (groupCount > 0) {
          rowClues[r] = str(groupCount) + " " + rowClues[r];
          groupCount = 0;
        }
      }
    }
    // Final Addition, if group continued up to boundary.
    if (groupCount > 0)
      rowClues[r] = str(groupCount) + " " + rowClues[r];
  }
  
  // Col Clue Numbers
  for (int c = 0; c < boardx; c++) {
    colClues[c] = "";
    groupCount = 0;
    for (int i = boardy-1; i >= 0; i--) {
      if (board[c][i].hiddenValue == true) {
        // If a filled cell was encountered, add it to our growing count of the current group we're looking at right now at this specific moment in time.
        groupCount++;
      } else {
        // If a space is encountered, and a group was being counted, add it to the clues.
        if (groupCount > 0) {
          colClues[c] = str(groupCount) + " " + colClues[c];
          groupCount = 0;
        }
      }
    }
    // Final Addition, if group continued up to boundary.
    if (groupCount > 0)
      colClues[c] = str(groupCount) + " " + colClues[c];
  }
}

void update() {
  // Update all Cell's timers
  for (int x = 0; x < boardx; x++) {
  for (int y = 0; y < boardy; y++) {
    board[x][y].update();
  }}
  
  checkForVictory();
}

void draw() {
  update();
  
  background(0);
  
  // Draw Victory Green Background
  if (gameWon)
    background(0, 40, 80);
  
  // Draw highlight on the square the player is looking at.
  if (gridPointIsValid(mouseX/cellSize, mouseY/cellSize))
    shape.drawHighlight(mouseX/cellSize, mouseY/cellSize);
    // Also draw one on the row and col headers for nice-ness hav-ing.
  
  // Draw Playfield
  if (!gameWon) {
    noFill();
    stroke(255);
    for (int i = numClueNumbers; i <= max(windowCellX, windowCellY); i++) {
      // Every 5 lines on the playfield, use thicker lines for a nice visual aid.
      if ((i - numClueNumbers) % 5 == 0)
        strokeWeight(3);
      else
        strokeWeight(1);
    
      if (i <= windowCellX)                         // Column Lines
        line(i*cellSize, 0, i*cellSize, height);
      if (i <= windowCellY)                         // Row Lines
        line(0, i*cellSize, width, i*cellSize);
    }
    strokeWeight(1);  // Reset, just in case.
  }
  
  // Draw Board Contents
  for (int x = 0; x < boardx; x++) {
  for (int y = 0; y < boardy; y++) {
    if (board[x][y].state == CellState.filled)
      shape.drawFill(x+numClueNumbers, y+numClueNumbers);
    if (board[x][y].state == CellState.blocked)
      shape.drawX(x+numClueNumbers, y+numClueNumbers);
    if (board[x][y].isFlashing())
      shape.drawFlash(x+numClueNumbers, y+numClueNumbers, board[x][y].getFlashOpacity());
  }}
  
  // Draw Clue Numbers
  textSize(cellSize*0.75);
  
  // Row Numbers
  textAlign(RIGHT, CENTER);
  for (int r = 0; r < boardy; r++) {
    // Change the color for clue numbers to make them sexier.
    if (checkRowCorrectness(r)) {
      if (checkRowFull(r))
        fill(60);
      else
        fill(255);
    } else {
      fill(200, 0, 0);
    }
    if (gameWon)
      fill(0, 0, 0, 0);
    
    text(rowClues[r], numClueNumbers*cellSize, (r+numClueNumbers)*cellSize + cellSize/2);
  }
  
  // Col Numbers
  textAlign(CENTER, TOP);
  String[] nums;
  for (int c = 0; c < boardx; c++) {
    // Change the color for clue numbers if the col is wrong.
    if (checkColCorrectness(c)) {
      if (checkColFull(c))
        fill(60);
      else
        fill(255);
    } else {
      fill(200, 0, 0);
    }
    if (gameWon)
      fill(0, 0, 0, 0);
      
    // Get an array of each number.
    nums = convertStringToArray(colClues[c]);
    
    // Now draw all those numbers as a tower.
    for (int i = nums.length-1; i >= 0; i--) {
      text(nums[i], (c + numClueNumbers)*cellSize + cellSize/2, (numClueNumbers - (nums.length-1) + i)*cellSize);
    }
  }
  
  // Draw Victory Graphics
  if (gameWon) {
    shape.drawVictoryScreen();
  }
}

void mousePressed() {
  if (gameWon == true)
    return;
  
  int gridX = mouseX / cellSize;
  int gridY = mouseY / cellSize;
  lastGridX = gridX;
  lastGridY = gridY;
  
  // If mouse was not clicked on the board, ignore and exit.
  if (gridPointIsValid(gridX, gridY) != true)
    return;
    
  // Now let's just consider the board itself.
  gridX = gridX - numClueNumbers;
  gridY = gridY - numClueNumbers;
  
  // ### Bring on them interactive flavors, son!
  
  if (mouseButton == LEFT) {
    // Flip cell from empty to filled and back.
    board[gridX][gridY].actionFill();
  }
  
  if (mouseButton == RIGHT) {
    board[gridX][gridY].actionBlock();
  }
  
  if (mouseButton == CENTER) {
    board[gridX][gridY].actionEmpty();
  }
}

void mouseDragged() {
  if (gameWon == true)
    return;
  
  int gridX = mouseX / cellSize;
  int gridY = mouseY / cellSize;
  boolean moved = false;
  
  // If the mouse moved from one cell to another, remember that like TellTale.
  if (gridX != lastGridX || gridY != lastGridY) {
    moved = true;
    lastGridX = gridX;
    lastGridY = gridY;
  }
    
  // If mouse has not moved cells, ignore the rest, save cycles.
  if (moved == false)
    return;
    
  // If grid point is invalid (not on the board), ignore the rest, save cycles.
  if (gridPointIsValid(gridX, gridY) != true)
    return;
    
  // Convert grid coordinates to board-only coordinates.
  gridX -= numClueNumbers;
  gridY -= numClueNumbers;
  
  // Make stuff happen with da buttons.
  if (mouseButton == CENTER) {        // ActionEmpty() has priority.
    board[gridX][gridY].actionEmpty();
  } else if (mouseButton == RIGHT) {  // ActionBlock() has 2nd priority.
    board[gridX][gridY].actionBlock(true);
  } else if (mouseButton == LEFT) {   // ActionFill() has least priority.
    board[gridX][gridY].actionFill(true);
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {}
  if (mouseButton == RIGHT) {}
  if (mouseButton == CENTER) {}
}

boolean gridPointIsValid(int x, int y) {
  boolean result = false;
  
  if (x >= numClueNumbers && x < windowCellX &&
      y >= numClueNumbers && y < windowCellY)
    result = true;
    
  return result;
}

String[] convertStringToArray(String source) {
  // Figure out how many spaces are in the hint string.
  int numHints = 1;
  for (int i = 0; i < source.length(); i++) {
    if (source.charAt(i) == ' ')
      numHints++;
  }
    
  // Create a receptacle
  String[] nums = new String[numHints];
    
  // Plug them boys into the receptacle.
  source = source + " ";
  for (int i = 0; i < nums.length; i++) {
    nums[i] = source.substring(0, source.indexOf(' '));
    source = source.substring(source.indexOf(' ')+1, source.length());
  }
    
  return nums;
}

void checkForVictory() {
  // Iterate over all cells. If ~one~ is found to not be filled that should be, then return and do not set gameWon = true;
  for (int x = 0; x < boardx; x++) {
  for (int y = 0; y < boardy; y++) {
    if (board[x][y].hiddenValue == true && board[x][y].state == CellState.empty)
      return;
  }}
  
  gameWon = true;
}

boolean checkRowCorrectness(int r) {
  boolean result = true;
  
  // Just confirm no X's exist on cells with hiddenValue=true.
  for (int i = 0; i < boardx; i++) {
    if (board[i][r].hiddenValue == true && board[i][r].state == CellState.blocked)
      result = false;
  }
  
  return result;
}

boolean checkColCorrectness(int c) {
  boolean result = true;
  
  // Just confirm no X's exist on cells with hiddenValue=true.
  for (int i = 0; i < boardy; i++) {
    if (board[c][i].hiddenValue == true && board[c][i].state == CellState.blocked)
      result = false;
  }
  
  return result;
}

boolean checkRowFull(int r) {
  boolean result = true;
  
  for (int i = 0; i < boardy; i++) {
    if (board[i][r].state == CellState.empty)
      result = false;
  }
  
  return result;
}

boolean checkColFull(int c) {
  boolean result = true;
  
  for (int i = 0; i < boardx; i++) {
    if (board[c][i].state == CellState.empty)
      result = false;
  }
  
  return result;
}