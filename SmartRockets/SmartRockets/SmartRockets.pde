Rocket rocket;
Population pop;

void setup() {
  size(800, 600);
  rocket = new Rocket();
  pop = new Population();
}

void draw() {
  background(0);
  //rocket.update();
  //rocket.show();
  pop.run();
}

class Population {
  Rocket[] rockets;
  int popsize = 100;
  
  public Population() {
    this.rockets = new Rocket[popsize];
    
    for (int i = 0; i < this.popsize; i++) {
      this.rockets[i] = new Rocket();
    }
  }
  
  public void run() {
    for (int i = 0; i < this.popsize; i++) {
      this.rockets[i].update();
      this.rockets[i].show();
    }
  }
}

class Rocket {
  PVector pos, vel, acc;
  
  public Rocket() {
    this.pos = new PVector(width/2, height);
    this.vel = PVector.random2D();
    this.acc = new PVector();
  }
  
  public void applyForce(PVector force) {
    this.acc.add(force);
  }
  
  public void update() {
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  public void show() {
    pushMatrix();
    
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading());
    rectMode(CENTER);
    rect(0, 0, 50, 10);
    
    popMatrix();
  }
}