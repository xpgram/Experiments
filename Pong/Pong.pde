
int STANDARD_SIZE = 10;
boolean AI_PLAYER1 = true;
boolean AI_PLAYER2 = true;
int DIFFICULTY = 1;

Puck puck;

Paddle left;
Paddle right;

Background bg;

int leftScore = 0;
int rightScore = 0;

void setup() {
  size(600, 400);
  noStroke();
  
  puck = new Puck();
  left = new Paddle(true);
  right = new Paddle(false);
  bg = new Background();
}

void draw() {
  background(0);
  
  puck.checkPaddle(left);
  puck.checkPaddle(right);
  
  bg.update();
  bg.show();
  
  if (AI_PLAYER1) left.AI();
  left.update();
  if (AI_PLAYER2) right.AI();
  right.update();
  puck.update();
  
  left.show();
  right.show();
  puck.show();
  
  fill(255);
  textSize(32);
  text(leftScore, 132, 48);
  text(rightScore, width-164, 48);
  stroke(255);
  line(width/2, 0, width/2, height);
}

void keyReleased() {
  if (key == 'a' || key == 'z')
    left.move(0);
  if (key == 'j' || key == 'm')
    right.move(0);
}

void keyPressed() {
  if (!AI_PLAYER1) {
    if (key == 'a') {
      left.move(-1);
    } else if (key == 'z') {
      left.move(1);
    }
  }
  
  if (!AI_PLAYER2) {
    if (key == 'j') {
      right.move(-1);
    } else if (key == 'm') {
      right.move(1);
    }
  }
}