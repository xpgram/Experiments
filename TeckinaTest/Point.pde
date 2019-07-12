
class Point {
  int x;
  int y;
  
  Point() {
    this.x = 0;
    this.y = 0;
  }
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Point(Point p) {
    this.x = p.x;
    this.y = p.y;
  }
  
  int taxiCabDistance(Point p) {
    return abs(this.x - p.x) + abs(this.y - p.y);
  }
  
  void clone(Point p) {
    this.x = p.x;
    this.y = p.y;
  }
  
  void setCoords(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Point move(int x, int y) {
    return new Point(this.x + x, this.y + y);
  }
  
  void print() {
    println("x: " + this.x + " y: " + this.y);
  }
  
  boolean equals(Point p) {
    return (this.x == p.x && this.y == p.y);
  }
}