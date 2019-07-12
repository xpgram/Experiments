
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
  
  Point plus(Point p) {
    Point newP = new Point();
    newP.x = this.x + p.x;
    newP.y = this.y + p.y;
    return newP;
  }
  
  Point mag(float n) {
    Point p = new Point();
    p.clone(this);
    float angle = atan2(p.y, p.x);
    p.x *= n * cos(angle);
    p.y *= n * sin(angle);
    return p;
  }
  
  Point setMag(float n) {
    Point p = new Point();
    p.clone(this);
    float angle = atan2(p.y, p.x);
    p.x = n * cos(angle);
    p.y = n * sin(angle);
    return p;
  }
  
  Point setMag(float n, Point origin) {
    Point p = new Point();
    p.clone(this);
    p.x -= origin.x;
    p.y -= origin.y;
    float angle = atan2(p.y, p.x);
    p.x = n * cos(angle);
    p.y = n * sin(angle);
    p.x += origin.x;
    p.y += origin.y;
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
  
  float getAngle(Point p) {
    return atan2(p.y - this.y, p.x - this.x);
  }
}