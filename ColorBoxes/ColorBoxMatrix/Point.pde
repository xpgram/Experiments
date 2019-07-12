
class Point {
  float x;
  float y;
  
  Point() {
    this.x = 0;
    this.y = 0;
  }
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Point(Point p) {
    this.x = p.x;
    this.y = p.y;
  }
  
  float taxiCabDistance(Point p) {
    return abs(this.x - p.x) + abs(this.y - p.y);
  }
  
  Point mult(float n) {
    Point p = new Point();
    p.clone(this);
    p.x *= n;
    p.y *= n;
    return p;
  }
  
  void clone(Point p) {
    this.x = p.x;
    this.y = p.y;
  }
  
  Point move(float x, float y) {
    return new Point(this.x + x, this.y + y);
  }
  
  void print() {
    println("x: " + this.x + " y: " + this.y);
  }
  
  boolean equals(Point p) {
    return (this.x == p.x && this.y == p.y);
  }
}