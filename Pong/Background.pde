
class Background {
  float brightness = 0;
  float brightMax = 120;
  float glowDir = -1;
  float rate = 4;
  
  void update() {
    brightness += glowDir * rate;
    if (brightness < 0) brightness = 0;
    if (brightness > brightMax) brightness = brightMax;
    //if (brightness == brightMax) glowDir = -1;
  }
  
  void glow() {
    //glowDir = 1;
    brightness = brightMax;
  }
  
  void show() {
    float b = sin(brightness/brightMax*HALF_PI) * brightMax;    // Maps brightness to a quarter-circle curve.
    fill(b, b, b*0.3);
    rect(0, 0, width, height);
  }
}