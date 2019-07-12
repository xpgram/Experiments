
// All right, I did this on a whim, trying to kill some time while my dad was bitching about something or other.
// This actually turned out fucking rad. I love it.
// For extra fun, turn one of the sin/cos in mathFunc to tan.


int gridLen = 20;
ColorBox[][] boxes = new ColorBox[gridLen][gridLen];
float seed = 0;
float stdSize = 32.0;
Point origin;

void setup() {
  size(800, 600);
  
  origin = new Point(width/2.0, height/4.0);
  
  for (int x = 0; x < boxes.length; x++) {
    for (int y = 0; y < boxes.length; y++) {
      boxes[x][y] = new ColorBox();
    }
  }
}

void draw() {
  background(0);
  
  seed += 0.01;
  if (seed > 1.0) seed = 0;
  
  float x;
  float y;
  float xshift = stdSize/2;
  float yshift = stdSize/4;
  for (int i = 0; i < boxes.length; i++) {
    for (int j = 0; j < boxes.length; j++) {
      x = origin.x - (i * xshift) + (j * xshift);
      y = origin.y + (i * yshift) + (j * yshift);
      boxes[i][j].update(seed * TWO_PI + mathFunc(i, j));
      boxes[i][j].show(x, y);
    }
  }
}

float mathFunc(float x, float y) {
  x = x / gridLen;
  y = y / gridLen;
  return sin(x*TWO_PI) - cos(y*TWO_PI);// + tan(x*TWO_PI * y*TWO_PI);
}