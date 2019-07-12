
enum StatID {
  None,  // Used for null values
  
  HP,   // Health Points
  AP,   // Ammo Points (Non-Refillable between towns)
  AGI,  // Speed/evasion is your natural defense.
  MOV,  // How far the unit can actually move.
  
  PHY,  // Physical- and strength-based skill knowledge.
  TCH,  // Machinery tinkery knowhow, especially of the Manadrive.
  INT,  // Understanding of advanced concepts.
  DEX,  // How steady your hand is. Used for guns.
  CMP   // Complex skills (vehicles and anything else "complex" might sub-in for).
}

int MAX_LEVEL = 5;
int MAX_XP = 100;

class Stat {
  StatID stat;
  int Lv;
  int XP;
  boolean maxLv;
  
  
  Stat(StatID id) {
    stat = id;
    Lv = 0;
    XP = 0;
    maxLv = false;
  }
  
  
  Stat(StatID id, int Lv) {
    stat = id;
    this.Lv = Lv;
    this.XP = 0;
    maxLv = false;
  }
  
  
  boolean grow(int XP) {
    if (this.maxLv) return false;
    
    this.XP += XP;
    
    if (this.XP >= MAX_XP) {
      this.XP = this.XP % MAX_XP;
      this.Lv++;
      if (this.Lv >= MAX_LEVEL)
        this.maxLv = true;
      
      return true;
    }
    
    return false;
  }
  
  
  void randomize() {
    this.Lv = int(random(3)) + 1;
    this.XP = 0;
  }
}