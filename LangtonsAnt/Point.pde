
class Point {
  public int x;
  public int y;
  
  public Point() {
    this.x = 0;
    this.y = 0;
  }
  
  public Point(int x, int y) {
    teleport(x, y);
  }
  
  public void move(int x, int y) {
    this.x += x;
    this.y += y;
  }
  
  public void teleport(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void clone(Point p) {
    this.x = p.x;
    this.y = p.y;
  }
}