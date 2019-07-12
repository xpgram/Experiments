
// There is no way I'm going to be able to understand how this works when I read it later.
// Commenting is hard because I barely knew what I was doing while writing it.
// I just make it work. :P
// The core principles aren't diffictult to figure out, though. atan2(y,x) and getting the lines
// draw properly and at the right angle were the most complex parts for me.

Ray[] rays;
Line line;
Circle[] circles;
int time = 0;

void setup() {
  size(800, 600);
  
  rays = new Ray[40];
  for (int i = 0; i < rays.length; i++) {
    rays[i] = new Ray();
  }
  
  circles = new Circle[12];
  float totalLen = longLength + shortLength + spaceLength*2;
  for (int i = 0; i < circles.length; i += 2) {
    circles[i] = new Circle(i/2*totalLen + longLength + spaceLength/2);
    circles[i+1] = new Circle(i/2*totalLen + longLength + shortLength + spaceLength*3/2);
  }
}

void draw() {
  background(0);
  time++;
  if (time > 200) time = 0;
  
  for (int i = 0; i < rays.length; i++) {
    rays[i].drift();
    rays[i].show();
  }
  
  for (int i = 0; i < circles.length; i++) {
    if (time == i*5) circles[i].pulse();
    circles[i].show();
  }
}