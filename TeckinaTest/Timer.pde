
// This is a basic utility class, like Point.
// Its purpose is to make creating and using timers easier, and especially so that I don't have to worry about multiplying
// by dt all the time; it'll just kinda happen.

// Plan events using seconds instead of frames.
// Timer set, update and reset is taken care of.
// You can set the number of cycles as well?

// Dream Feature:
//   Submit to the constructor an event path; that is, a function to call or an object to contact when, and exactly when,
//   the timer runs down all it's cycles, or every time it loops. (Think of it like a keypress event)
//   This doesn't work unless update is called manually.

class Timer {
  private float time;
  private float max;
  private int laps;
  private int cycles;
  private int totalCycles;
  private boolean infiniteCycles;
  private boolean countDown;
  private boolean paused;
  private int lastMillis;
  private float delta;
  
  
  Timer(float seconds) {
    constructor(seconds, 0, false);
  }
  
  
  Timer(float seconds, boolean countDown) {
    constructor(seconds, 0, countDown);
  }
  
  
  Timer(float seconds, int numCycles) {
    constructor(seconds, numCycles, false);
  }
  
  
  Timer(float seconds, int numCycles, boolean countDown) {
    constructor(seconds, numCycles, countDown);
  }
  
  
  private void constructor(float seconds, int numCycles, boolean countDown) {
    this.time = 0;
    this.max = seconds;
    this.laps = 0;
    this.cycles = abs(numCycles);
    this.totalCycles = this.cycles;
    this.infiniteCycles = (cycles < 1);
    this.countDown = countDown;
    this.paused = false;
    
    this.lastMillis = millis();
  }
  
  
  /* Readjusts the timer's watch.
   * This function does not need to be called every frame; it updates itself according to system time.
   */
  void update() {
    if (!this.infiniteCycles && this.cycles == 0) return;
    if (this.paused) return;
    
    // Get delta time
    int curMillis = millis();
    this.delta = float(curMillis - lastMillis) / 1000;
    this.lastMillis = curMillis;
    
    // Update time
    this.time += this.delta;
    
    // Loop timer
    while (this.time >= this.max) {
      this.time -= this.max;
      this.laps++;
      
      // Adjust remaining cycles
      if (! infiniteCycles) {
        this.cycles--;
        
        // Timer ends "full"
        if (this.cycles == 0) {
          this.time = this.max;
          break;
        }
      }
    }
  }
  
  
  // Returns elapsed time.
  float getTime() {
    this.update();
    
    if (this.countDown)
      return this.max - this.time;
    
    return this.time;
  }
  
  
  // Returns elapsed time as a number between 0 and 1.
  float getRatio() {
    this.update();
    
    if (this.countDown)
      return (this.max - this.time) / this.max;
    
    return this.time / this.max;
  }
  
  
  // Returns time the watch is set to.
  float getMax() {
    return this.max;
  }
  
  
  // Returns the number of times the timer has looped since it was started.
  int getLaps() {
    this.update();
    return this.laps;
  }
  
  
  // Returns number of cycles timer has remaining.
  int getRemainingCycles() {
    this.update();
    return this.cycles;
  }
  
  
  // Returns the number of cycles the timer was set to loop through when it was created.
  int getInitialCycles() {
    return this.totalCycles;
  }
  
  
  // Returns whether or not the timer has ended.
  boolean hasFinished() {
    this.update();
    return (this.cycles == 0);
  }
  
  
  // Tells the timer to start counting time.
  void start() {
    if (this.paused) {
      this.paused = false;
      this.lastMillis = millis();
    }
  }
  
  
  // Tells the timer to stop counting time.
  void pause() {
    if (!this.paused) {
      this.update();
      this.paused = true;
    }
  }
  
  
  // Tells the timer to switch between paused and unpaused states.
  void togglePause() {
    if (this.paused)
      this.start();
    else
      this.pause();
  }
  
  
  // Asks if the timer is paused currently.
  boolean isPaused() {
    return this.paused;
  }
  
  
  // Resets the timer to its initial conditions.
  void reset() {
    this.constructor(this.max, this.totalCycles, this.countDown);
  }
  
  
  /* Manually sets the time on the watch.
   * If a value above the timer's maximum is given, the function approximates how many cycles would have passed.
   * If all cycles would have passed, the timer is essentially ended.
   */
  void setTime(float time) {
    this.time = abs(time % this.max);
    
    if (!this.infiniteCycles) {
      this.cycles = this.totalCycles - int(time / this.max);
      this.cycles = constrain(this.cycles, 0, this.totalCycles);
      if (this.cycles == 0) this.time = this.max;
    }
  }
}