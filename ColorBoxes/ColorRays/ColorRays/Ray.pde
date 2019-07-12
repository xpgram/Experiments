
float longLength = 60;
float shortLength = 10;
float spaceLength = 20;
Point rayOrigin;

class Ray
{
  float angle = random(PI/2) + PI/4;
  float dir = (floor(random(2)) == 0) ? -1 : 1;
  float speed = random(.75) + .25;
  Point lineStart;
  Point vector;
  Line line;
  
  Ray() {
    rayOrigin = new Point(width/2, 10);
  }
  
  void show() {
    colorMode(HSB, 360);
    noStroke();
    int c = int(angle*120 + 260);
    if (c > 360) c -= 360;
    fill(c, sin(angle)*240, 240);
    
    vector = new Point(cos(angle), sin(angle));
    lineStart = new Point(rayOrigin).plus(vector);
    
    int state = 0;
    float totalLen = 0;
    float curLen = 0;
    while (lineStart.y < height)
    {
      if (state == 0) {
        curLen = longLength;
        state = 1;
      } else { // (state == 1)
        curLen = shortLength;
        state = 0;
      }

      line = new Line(lineStart, vector.setMag(curLen).plus(lineStart));
      line.show();
      
      totalLen += curLen + spaceLength;

      lineStart = lineStart.setMag(totalLen, rayOrigin);
    }
  }
  
  void drift() {
    // Constrain angle between PI/2 +/- PI/4
    if (angle < PI/4 || angle > PI*3/4) dir *= -1;
    
    angle += dir * speed * PI/512;
  }
}