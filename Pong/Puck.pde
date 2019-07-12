
class Puck {
  int SIZE = STANDARD_SIZE;
  float startSpeed = 6;
  
  float x = width/2;
  float y = height/2;
  float xspeed;
  float yspeed;
  
  float timer = 0;
  float timerThreshold = 1500;
  float respawnTimer = -40;    // Needs to be negative because I'm a bad programmer
  
  Puck() {
    reset();
  }
  
  void update() {
    this.edges();
    
    if (timer > 0) {    // -timer allows a respawn wait. It's a real bandaid solution.
      x = x + xspeed;
      y = y + yspeed;
    }
    
    timer++;
  }
  
  void checkPaddle(Paddle p) {
    float diff;
    float angle;
    float rad = radians(45);
    
    if (x < p.x+p.w && x+SIZE > p.x && y < p.y+p.h && y+SIZE > p.y) {
      diff = y - p.y;
      angle = map(diff, 0, p.h, -rad, rad);
      
      xspeed = cos(angle) * startSpeed * (1.0 + timer/timerThreshold);  // Puck speeds up with time
      yspeed = sin(angle) * startSpeed * (1.0 + timer/timerThreshold);
      
      if (p.left == false) xspeed *= -1;
    }
  }
  
  void edges() {
    // Bounce off top and bottom
    if (y < 0 || y > height - SIZE)
      yspeed *= -1;
    
    // Reset to center if crossing over score line
    
    if (x > width + SIZE) {
      leftScore++;
      bg.glow();
      reset();
    }
    
    if (x < -SIZE) {
      rightScore++;
      bg.glow();
      reset();
    }
  }
  
  void reset() {
    x = width/2 - SIZE/2;
    y = random(0+height/4, height-height/4);
    timer = respawnTimer;
    serve();
  }
  
  void serve() {
    float range = PI/4;
    float angle = random(-range, range);
    
    xspeed = cos(angle) * startSpeed;
    yspeed = sin(angle) * startSpeed;
    
    if (random(1) < 0.5) xspeed *= -1;  // Determines which player is served to.
  }
  
  void show() {
    fill(255);
    rect(x, y, SIZE, SIZE);
  }
}