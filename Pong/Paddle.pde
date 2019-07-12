
class Paddle {
  int w = STANDARD_SIZE;
  int h = STANDARD_SIZE * 8;
  float x;
  float y = height/2 - h/2;
  
  float vDir = 0;
  float speed = 10;
  boolean left;
  float yFuzzing = 0;
  
  Paddle(boolean left) {
    this.left = left;
    
    if (left) {
      x = STANDARD_SIZE;
    } else {
      x = width - 2*STANDARD_SIZE;
    }
  }
  
  void update() {
    y += speed * vDir;
    y = constrain(y, 0, height-h);
  }
  
  void move(float vDir_) {
    vDir = vDir_;
  }
  
  void AI() {
    float intersect = width;
    if (left) intersect = 0;
    
    float centerY = this.y + this.h/2;
    float b = puck.y - puck.yspeed / puck.xspeed * puck.x;
    float destY = puck.yspeed / puck.xspeed * intersect + b;
    float speed = 0.25*DIFFICULTY;
      
    if (destY < 0) destY = 0;
    if (destY < -height*0.25) destY = height/4;
    if (destY > height) destY = height;
    if (destY > height * 1.25) destY = 3*height/4;
    if (!left && puck.xspeed < 0 || left && puck.xspeed > 0) destY = height/2;
    
    // When the puck is on the other side of the field, randomize the fuzzing value.
    if (!left && puck.x < width/8 || left && puck.x > 7*width/8) {
      yFuzzing = round(random(-this.h/2, this.h/2));
    }
    destY += yFuzzing;
    
    //if (abs(centerY - destY) < STANDARD_SIZE) destY = centerY;
    
    destY = floor(destY);
    centerY = floor(centerY);
    
    // Move paddle's velocity toward its destination.
    if (destY - centerY < -1) {
      vDir = -speed;
    } else if (destY - centerY > 1) {
      vDir = speed;
    } else {
      vDir = 0;
    }
  }
  
  void show() {
    fill(255);;
    rect(x, y, w, h);
  }
}