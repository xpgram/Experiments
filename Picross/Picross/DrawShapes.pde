class DrawShapes {
  public DrawShapes() {
  }
  
  public void drawX(int x, int y) {
    // If game is won, uh, don't draw these ugly shits.
    if (gameWon)
      return;
    
    // Draw an orange X shape within a cellSize sized box.
    noStroke();
    fill(240, 160, 0);
    x = x * cellSize;
    y = y * cellSize;
    
    quad(x+(cellSize*0.2), y+(cellSize*0.7), x+(cellSize*0.3), y+(cellSize*0.8), x+(cellSize*0.8), y+(cellSize*0.3), x+(cellSize*0.7), y+(cellSize*0.2));
    quad(x+(cellSize*0.2), y+(cellSize*0.3), x+(cellSize*0.3), y+(cellSize*0.2), x+(cellSize*0.8), y+(cellSize*0.7), x+(cellSize*0.7), y+(cellSize*0.8));
  }
  
  public void drawFill(int x, int y) {
    // Draw a blue box the size of cellSize.
    noStroke();
    fill(0, 160, 240);
    x = x * cellSize;
    y = y * cellSize;
    
    rect(x+(cellSize*0.1), y+(cellSize*0.1), (cellSize*0.80), (cellSize*0.80));
  }
  
  public void drawFlash(int x, int y, float o) {
    // Draw a red box the size of cellSize with transparency given by var o.
    noStroke();
    fill(240, 0, 0, 255*o);
    x = x * cellSize;
    y = y * cellSize;
    
    rect(x+1, y+1, cellSize-2, cellSize-2);
  }
  
  public void drawSquare(int x, int y) {
    noStroke();
    fill(255);
    x = x * cellSize;
    y = y * cellSize;
    int border = (int)(cellSize*0.1);
    
    rect(x+border, y+border, cellSize-border, cellSize-border);
  }
  
  public void drawHighlight(int x, int y) {
    noStroke();
    fill(40);
    x = x * cellSize;
    y = y * cellSize;
    int b = 1;
    
    rect(x+b, y+b, cellSize-b, cellSize-b);
  }
  
  public void drawVictoryScreen() {
    fill(255);
    
    int[] drawing = {0, 1, 1, 1, 0,
                     1, 0, 0, 0, 1,
                     1, 0, 0, 0, 1,
                     1, 0, 0, 0, 1,
                     0, 1, 1, 1, 0,
                     1, 1, 1, 1, 1,
                     1, 0, 0, 0, 1,
                     1, 0, 1, 0, 1,
                     1, 0, 1, 0, 1,
                     1, 1, 1, 0, 1,
                     0, 1, 1, 1, 0,
                     1, 0, 0, 0, 1,
                     1, 0, 0, 0, 1,
                     1, 0, 0, 0, 1,
                     1, 0, 0, 0, 1};
    // Iterate over the matrix and draw dat hot stuff.
    int y = -1;
    int x = 0;
    for (int i = 0; i < drawing.length; i++) {
      if (i % 5 == 0) {
        y++;
        x = 0;
      } else
        x++;
      
      // Only draw when a 1 is present.
      if (drawing[x + y*5] == 1)
        shape.drawSquare(x, y);
    }
    
    // Now congratulate the player on unlocking their fine art piece.
    textSize(cellSize*2);
    textAlign(LEFT, TOP);
    text("YOU WIN", cellSize*6, cellSize);
    textSize(cellSize*0.5);
    text("BE FUCKING HAPPY ABOUT IT", cellSize*6.8, cellSize*3);
  }
}