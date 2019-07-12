
// Menu() is an object which, essentially, gathers user input and returns a number.
// It should always be called by a ManuManager() of some kind to both build the menu when it's activated
// and to interpret it when the user selects something.

// I got it working. Or drawn, I mean. The arrow moves.
// Anyway, I need to revamp it a bit.
// I need to prettify it, add more information to each selection (which I'm going to do with ActionData, which which, is
// honestly a little further down the line but I went ahead and added the class for it already anyway), and somehow
// marry that ActionData list with a normal "Wait" command placed at the bottom of every menu.
// Oh, and unit AP should be displayed somewhere on it to so you can see what you're up to.

//    | Iron Sword        |
//    | Pow 3  AP --  90% |
//  And a little description window, I guess, prints the desc. of what the action is/does.
//  Unless we assume the player knows because they equipped it to him and POW, ACC and AP Cost are all they need to be told.

// Checking unit equips could be as simple as opening their menu.
// Passive abilities are greyed out a little and unselectable, but their descriptions and stats are still available to see
// from the command menu. So if you clicked on an enemy, you wouldn't be able to hit space and do anything, but you could
// still see what you were up against.

class Menu {
  boolean active = true;
  int MAX_CHARS = 12;
  int animTimer = 0;
  int animLimit = 100;
  
  int nameHeight    = 24;
  int detailsHeight = 18;
  int spacer        = 2;
  int boxHeight     = nameHeight + detailsHeight + spacer*3;
  int border        = 8;
  int menuWidth     = 180;
  int menuHeight; //= boxHeight * listItems.length;
  PFont fontL = loadFont("Latha-24.vlw");
  PFont fontS = loadFont("Latha-18.vlw");
  
  ActionData[] listItems;
  Point pos;
  boolean leftSide = false;  // Not yet implemented. Tries to get the menu out of the player's way; the menu is a bigass motherfucker.
  
  int selector;        // 0 is first option, -1 ("return value") is null.
  int endOfList;
  
  
  Menu() {
    active = false;
  }
  
  
  void createNew(ActionData[] actions, boolean leftSide) {
    active = true;
    listItems = actions;
    
    selector = 0;
    endOfList = listItems.length + 1;    // Shorthand for where the selector stops. +1 is for wait command.
    
    menuHeight = boxHeight * (listItems.length + 1);
    
    this.leftSide = leftSide;    // ?
    if (leftSide) {          // Should I make it about corners instead of just sides?
      pos = new Point(border*2, height - menuHeight - border*2);
    } else {
      pos = new Point(width - menuWidth - border*2, height - menuHeight - border*2);
    }
  }
  
  
  void show() {
    if (active == false) return;
    
    Point boxPos = pos;
    float align;
    noStroke();
    
    // Draw Background
    fill(64);
    rect(pos.x - border, pos.y - border, menuWidth + border*2, menuHeight + border*2);
    
    fill(128);
    rect(pos.x - border, pos.y - border, menuWidth + border*2, border);
    rect(pos.x - border, pos.y + menuHeight, menuWidth + border*2, border);
    
    // Draw highlighted list item
    fill(96, 96, 128);
    rect(pos.x - border, pos.y + boxHeight*selector, menuWidth + border*2, boxHeight);
    drawArrow(pos.x - border, pos.y + boxHeight * selector);
    
    // Draw text
    
    // Draw Equips information
    for (int i = 0; i < listItems.length; i++) {
      boxPos = new Point(pos.x, pos.y + i*boxHeight);
      
      // Set passiveEquip textcolor to look unchoosable
      if (listItems[i].passiveEffect == false) {
        fill(255);
      } else {
        fill(192, 192, 192);
      }
      
      // Separator lines
      stroke(64);
      line(boxPos.x - border, boxPos.y, boxPos.x + menuWidth + border, boxPos.y);
      line(boxPos.x - border, boxPos.y + boxHeight, boxPos.x + menuWidth + border, boxPos.y + boxHeight);
      noStroke();
      
      // Top line
      //textSize(nameHeight);
      textFont(this.fontL);
      textAlign(LEFT, CENTER);
      align = nameHeight / 2 + spacer;
      text(listItems[i].actionName, boxPos.x, boxPos.y + align);
      if (listItems[i].AP > 0) {
        textAlign(RIGHT, CENTER);
        text(listItems[i].AP, boxPos.x + menuWidth, boxPos.y + align);
      }
      
      // Bottom line
      //textSize(detailsHeight);
      textFont(this.fontS);
      textAlign(LEFT, CENTER);
      align = nameHeight + spacer*2 + detailsHeight / 2;
      text("Pow " + listItems[i].POW, boxPos.x, boxPos.y + align);
      text("Acc " + listItems[i].ACC, boxPos.x + menuWidth / 3, boxPos.y + align);
      if (listItems[i].Range > 1)
        text("R " + (listItems[i].nullRange + 1) + "-" + listItems[i].Range, boxPos.x + menuWidth * 2/3, boxPos.y + align);
    }
    
    // Draw Wait command
    boxPos = new Point(pos.x, pos.y + listItems.length*boxHeight);
    fill(255);
    textFont(this.fontL);
    textAlign(LEFT, CENTER);
    align = boxHeight / 2;
    text("Wait", boxPos.x, boxPos.y + align);
  }
  
  
  void drawArrow(int x, int y) {
    fill(255, 255, 0);  // Yellow
    
    int s = 5;  // size
    
    x += 1 * animateArrow();  // HorShift for timed animation
    y += boxHeight/2;        // Move origin from CENTER,TOP to CENTER,CENTER
    
    triangle(x - s, y - s*2, x - s, y + s*2, x + s, y);
  }
  int animateArrow() {
    animTimer++;
    if (animTimer > animLimit) animTimer = 0;
    
    return (animTimer < animLimit/2) ? -1 : 1;
  }
  
  
  void selectOption() {
    turnMachine.cmdSubmitOption(this.selector);
  }
  
  
  void keyPressed() {
    if (active == false) return;
    
    if (keyCode == UP)    selector--;
    if (keyCode == DOWN)  selector++;
    
    if (key == ' ') this.selectOption();
    
    selector = (selector + endOfList) % (endOfList);    // Makes sure selector is only a valid number, also allows looping from top to bottom.
  }
}