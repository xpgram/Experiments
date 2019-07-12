
class Unit {
  
  Point pos;
  Team team;        // The Team enum is described in TurnMachine. Sorry about that.
  boolean active;
  
  UnitStats stats;
  
  
  Unit(Point p, Team t, UnitStats u) {
    this.pos = new Point(p);
    this.team = t;
    this.stats = u;
    active = false;
  }
  
  
  void show() {
    // Temp
    if (this.stats.HP == 0)
      this.death();
    // /Temp
    if (this.active == false)
      return;
    
    int border = _stdSize / 4;
    int drawX = this.pos.x * _stdSize + border;
    int drawY = this.pos.y * _stdSize + border;
    int drawS = _stdSize - 2*border;
    
    if (team == Team.Allies) fill(63, 127, 255);  // Cyan
    if (team == Team.Enemies) fill(255, 127, 63);  // Orange
    noStroke();
    
    rect(drawX, drawY, drawS, drawS);
    
    //if (Global.UI.showHealthBars == true)
    this.drawHealthBar();
  }
  
  
  private void drawHealthBar() {
    colorMode(HSB, 360);
    int border = _stdSize / 8;
    int barHeight = _stdSize / 16;
    int drawX = this.pos.x * _stdSize;
    int drawY = this.pos.y * _stdSize;
    
    float ratio = this.stats.getHPRatio();
    fill(ratio * 120, 360, 360);
    if (team == Team.Enemies) fill(0, 360, 360);
    
    rect(drawX + border, drawY + _stdSize - barHeight - border, (_stdSize - border*2)*ratio, barHeight);
    
    colorMode(RGB, 255);
  }
  
  
  void death() {
    this.pos.setCoords(-1, -1);
    deactivate();
  }
  
  
  boolean activate() {
    if (stats.HP > 0) {
      this.active = true;
    }
    return this.active;
  }
  
  
  void deactivate() {
    this.active = false;
  }
  
  
  void setPos(int x, int y) {
    this.pos = new Point(x, y);
  }
  void setPos(Point p) {
    this.pos.clone(p);
  }
}