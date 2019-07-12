
float lSize = 3;

class Line
{
  Point start = new Point();
  Point end = new Point();
  float angle;  // Radians
  float perpAngle; // Radians
  
  Line(Point p1, Point p2) {
    this.start.clone(p1);
    this.end.clone(p2);
    this.angle = this.start.getAngle(this.end);
    this.perpAngle = angle + PI/2;
  }
  
  void show() {
    ellipse(this.start.x, this.start.y, lSize*2, lSize*2);
    ellipse(this.end.x, this.end.y, lSize*2, lSize*2);
    
    Point p = new Point(lSize * cos(perpAngle), lSize * sin(perpAngle));
    
    quad(this.start.x + p.x, this.start.y + p.y,
         this.start.x - p.x, this.start.y - p.y,
         this.end.x - p.x, this.end.y - p.y,
         this.end.x + p.x, this.end.y + p.y);
  }
}