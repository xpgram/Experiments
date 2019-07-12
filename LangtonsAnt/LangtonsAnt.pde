// Langton's Ant

Point _startLoc;
int _stepsPerCycle = 10;
boolean _pause = false;
int _pathMax = 5000;
Ant ant;
Point[] path;
PImage map;

void setup() {
  size(1200, 800);
  noSmooth();
  _startLoc = new Point(width/2, height/2);
  
  // Create map image and set all pixels to white, the default state.
  map = createImage(width,height,RGB);
  map.loadPixels();
  for (int i =0; i < map.pixels.length; i++) {
    map.pixels[i] = color(255);
  }
  map.updatePixels();
  
  ant = new Ant();
  
  path = new Point[_pathMax];
  for (int i = 0; i < _pathMax; i++) path[i] = new Point(_startLoc.x, _startLoc.y);
}

void draw() {
  background(255);
  drawMap();
  ant.update();
}

void drawMap() {
  image(map,0,0);
  
  // Draw path
  for (int i = 0; i < _pathMax; i++) {
    stroke(255, 255, 0);
    point(path[i].x, path[i].y);
  }
}

void keyPressed() {
  if (key == ' ') {
    _pause = !_pause;
  }
  
  if (keyCode == UP) {
    _stepsPerCycle += 10;
  } else if (keyCode == DOWN) {
    _stepsPerCycle -= 10;
  } else if (keyCode == LEFT) {
    _stepsPerCycle -= 100;
  } else if (keyCode == RIGHT) {
    _stepsPerCycle += 100;
  }
  if (_stepsPerCycle < 1) _stepsPerCycle = 1;
}