
// I'm going to rewrite this (ugh, which means rewriting a handful of other classes that depend on this one and who
// fucking knows which those are) to use Stat objects for each stat instead of using less overall memory.
//
// I'm going to have to keep track of like 10 different xp bars and that's fucking silly.
// Stat objects will wrap all that up, including a grow(xp_amount) function, into one package.

// This class should be for base stats, growth and equips. Meters should be handled by the Unit object (right?).

class UnitStats {
  int HP;
  int maxHP;
  
  int STR;
  int DEF;
  
  int MOV;
  
  ActionData[] equipsList;
  
  
  UnitStats() {
    this.maxHP = 2 + floor(random(5));
    this.HP = this.maxHP;
    this.STR = 1 + floor(random(4));
    this.DEF = floor(random(3));
    
    this.MOV = 3 + floor(random(3));
    
    ActionData[] testAD = {new ActionData(), new ActionData()}; 
    equipsList = testAD;
  }
  
  
  UnitStats(int hp, int mhp, int str, int def) {
    this.HP = hp;
    this.maxHP = mhp;
    this.STR = str;
    this.DEF = def;
  }
  

  void damage(int dam) {
    dam = dam - DEF;
    if (dam < 0) dam = 0;
    this.addHP(dam);
  }
  
  
  float getHPRatio() {
    return float(this.HP) / float(this.maxHP);
  }
  
  
  void addHP(int hp) {
    if (HP > 0) {
      this.HP += hp;
      this.HP = constrain(this.HP, 0, this.maxHP);
    }
    
    if (this.HP == 0) {
      // This is why this metered HP thing should be handled in Unit.
    }
  }
  
  
  int getDEF() {
    int def = 0;
    for (int i = 0; i < equipsList.length; i++) {
      def += equipsList[i].DEF;
    }
    return def;
  }
}