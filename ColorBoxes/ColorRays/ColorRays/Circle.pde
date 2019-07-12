
class Circle
{
  float radius;
  float brightness = 0;
  
  Circle(float radius) {
    this.radius = radius;
  }
  
  void pulse() {
    brightness = 1;
  }
  
  void show() {
    stroke(200, 360, 360*brightness);
    noFill();
    
    ellipse(rayOrigin.x, rayOrigin.y, radius*2, radius*2);
    
    brightness -= .01;
    if (brightness < 0) brightness = 0;
  }
}