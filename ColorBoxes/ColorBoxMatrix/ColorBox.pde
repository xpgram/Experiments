float s = stdSize;

// These are helpful drawing points: vertices on the cube.
Point p1 = new Point(     0.0,     0.0).mult(s);
Point p2 = new Point(-1.0/2.0, 1.0/4.0).mult(s);
Point p3 = new Point( 1.0/2.0, 1.0/4.0).mult(s);
Point p4 = new Point(     0.0, 1.0/2.0).mult(s);
Point p5 = new Point(-1.0/2.0, 3.0/4.0).mult(s);
Point p6 = new Point( 1.0/2.0, 3.0/4.0).mult(s);
Point p7 = new Point(     0.0,     1.0).mult(s);

class ColorBox {
  float lift = 0;
  float liftM = stdSize;
  float hue = 0;
  
  ColorBox() {
  }
  
  
  void update(float seed) {
    hue = (atan(tan(seed / 2)) / 3 + .5) * 360;    // Jesus, finally. I wish I'd built this with HSB in mind from the beginning.
    lift = sin(seed) * liftM;
  }
  
  
  void show(float x, float y) {
    y = y - lift;
    
    colorMode(HSB, 360);
    fill(hue, 360, 360);
    stroke(360);
    
    quad(x + p1.x, y + p1.y, x + p2.x, y + p2.y, x + p4.x, y + p4.y, x + p3.x, y + p3.y);
    quad(x + p2.x, y + p2.y, x + p5.x, y + p5.y, x + p7.x, y + p7.y, x + p4.x, y + p4.y);
    quad(x + p3.x, y + p3.y, x + p4.x, y + p4.y, x + p7.x, y + p7.y, x + p6.x, y + p6.y);
  }
}