
/* This class is a highly-structured data structure, but I think I could do better.
 * I'm not sure how to fix this yet, but the fields just don't seem focused enough.
 * POW is an important value to have handy, but if the action were instead a (perhaps rare) healing item, then POW isn't really useful.
 *
 * Aggressive actions generally need:      Armors generally need:      A healing item needs:      Support actions just need:
 *     - POW                                   - DEF                       - POT (Potency)            - ActionEffects[]
 *     - ACC                                   - RES                       - POT might be a %         - Acc (if target=enemy)
 *     - AP                                    - AGI
 *
 * But, say a special action damages another unit's AP. If I want that ability to exist, I then have to add ~another~ field, for one thing no less!
 *     - APdam
 *
 * If I redesign this class (I'm sure I'll be forced to at some point), the action's type should probably come first.
 * The standard values held within should probably be generic (val1, val2, val3) or even in an array (val[0,1,2]).
 * This should be fine because if you've really equipped a healing spell, then the info on the cmdMenu needs to change anyway.
 * Range can stay because it's pretty important no matter what you're using, unless it's a passive.
 * Most of my boolean values are assumed to be false, they could probably just be ActionEffect flags.
 * TargetType target = .Ally , .Enemy , .Any , .Self ; needs to be added.
 *
 * I don't like seeing val[0] = 3 represent how much damage is done. There's nothing to tell you what 3 or val[0] actually means.
 * Does this mean Action.type should clearly define that type=physical and val[0]=POW is always true? Or should I provide labels?
 * Labels are great, but if you find yourself searching for a POW field on an Armor equip, what exactly should the method return?
 */

String[] pretendNames = {"Iron Sword", "Blowback Pistol", "Gunhilde", "Forked Spear", "Charge", "Fire", "Flameka", "Shove", "Quake"};

class ActionData {
  boolean valid;
  
  TargetType targetType;  // Specifies which kind of tile the fieldSelector is allowed to pick.
  
  String actionName;      // Appears in-game, also searchable in ActionDatabase.
  int POW;                // Damage dealt.
  int ACC;                // Accuracy rating, 0 - 100.
  int AP;                 // AP cost to use, 0 - 9.
  int Range;              // How far the action reaches.
  int nullRange;          // Always less than Range; used to create "range windows," like 2-5.
  int DEF;                // Lowers enemy POW when they're attacking (physical damage).
  int RES;                // Lowers enemy POW when they're attacking (magic damage).
  int AGI;                // Used to lower speed usually, but some equips could raise it too.
  ActionEffects[] effectsList;    // A list of whatever length is necessary to list all the action's secondary effects.
                                  // ActionEffects.None or effectsList[0] is used for no effects.
  boolean passiveEffect;    // If true, ability is not directly useable, but it's effects are permanently active.
  boolean magicDamage;      // If true, ignores DEF (but starts gnoring RES).
  boolean AoE;              // If true, targets an area instead of a target.
  boolean targetAllies;     // If true, effects will be applied to allies only instead of enemies.
      // I think I need a TargetType.Allies / .Enemies / .Any
  int blastRadius;  // How big the AoE "circle" is.  (Could blastRadius = 1 be the minimum? Then bool AoE is redundant.)
  
  Stat firstReq;   // Contains stat name and level requirement needed to equip.
  Stat secondReq;  // Contains a second name and level requirement. (3 is never needed, I believe).
  //Stat firstXP;    // The "trained" stat when used.
  //Stat secondXP;   // Commented out because I need to figure out the best way of modeling this data. :P
  
  String actionDescription;  // A (character limit?) description of what the ability is, what it does, etc.
  int storeValue;            // Base sell/buy value.
  
  //Anim anim;    // Not a thing, this is just where I would (probably) put such a thing.
  
  
  // Creates a blank action.
  ActionData() {
    valid = false;  // Until action is loaded, declare itself unuseable.
    targetType = TargetType.Enemy;
    
    // Dummy data
    actionName = pretendNames[int(random(pretendNames.length))]; //"Big Punch";
    POW = int(random(6)); //3;
    ACC = int(random(5)) * 10 + 50; //100;
    AP = int(random(4));
    DEF = 0;
    RES = 0;
    AGI = 0;
    Range = (int(random(3)) == 0) ? 1 : int(random(3)) + 2; //1;
    nullRange = (Range < 2) ? 0 : int(random(Range - 1)); //0;
    effectsList = new ActionEffects[0];  // Empty list: no effects.  I'm gonna try this instead of ActionEffects.None.
    
    passiveEffect = (int(random(4)) == 0);
    magicDamage = false;
    AoE = false;
    blastRadius = 0;
  
    firstReq = new Stat(StatID.None, 0);
    secondReq = null;    // Is StatID.None or null better? I think in general, null shouldn't be used, but... eh.
    //Stat firstXP;    // The "trained" stat when used.
    //Stat secondXP;   // Commented out because I need to figure out the best way of modeling this data. :P
  
    actionDescription = "A really big punch that, like, really fucks the bones up, and stuff.";
    storeValue = 0;
  }
  
  
  boolean load(String name) {
    // In the future, it might be more sensible to give every item in the game a number (like block-types in Minecraft).
    // Units would just remember what numbers their equips were, and using them I could skip all this string-comparison searching.
    // That does mean that if I want to add things I need to be careful; either I add them to the end, or I sort them and then
    // go into my hardcoded program and re-enter all the numbers for what units have.
    // And actually, what might make more sense is writing the names of what they have, converting those (through a method in
    // ActionDatabase, maybe) into numbers, and then giving the numbers to the units; which, in an abstract kind of way, is how
    // developer-made tools work. Tiled, for instance, gives you all the visual information you need when building, but it saves
    // things as a tilemap with a number-reference system.
    
    // Anyway, sorry about the long paragraph.
    // For ~now,~ I'm just going to use a name lookup system.
    
    String[] lines = loadStrings("ActionDatabaseInfo.txt");
    String line;
    
    int cur;
    int next = 4;
    int eof = lines.length;
    int start = 0;
    int end = 0;
    String[] data = new String[21];      // 21 is the number of relevant datapoints each action has.
    
    // FileIO: search for name's values.
    for (cur = 0; cur < eof; cur += next) {
      line = lines[cur];
      
      if (line.substring(1, line.length() - 1).equals(name)) {
        // If the name matches an entry
        // Load all dat good stuff
        line = lines[cur+1];
        
        // Parse line for relevant bits. Order, as you can see, is important because labels are not preserved.
        for (int i = 0; i < data.length; i++) {
          start = line.indexOf(":", end);
          end = line.indexOf(",", start);
          data[i] = line.substring(start+1, end);
        }
        
        actionName = name;
        POW = int(data[0]);
        ACC = int(data[1]);
        AP  = int(data[2]);
        DEF = int(data[3]);
        RES = int(data[4]);
        AGI = int(data[5]);
        Range = int(data[6]);
        nullRange = int(data[7]);
        passiveEffect = boolean(data[8]);
        magicDamage = boolean(data[9]);
        AoE = boolean(data[10]);
        blastRadius = int(data[11]);
        storeValue = int(data[12]);
  
        /* These are related to features I'm not even close to adding yet.
         * firstReq = new Stat(StatID.None, 0);
         * secondReq = null;    // Is StatID.None or null better? I think in general, null shouldn't be used, but... eh.
         * Stat firstXP;    // The "trained" stat when used.
         * Stat secondXP;   // Commented out because I need to figure out the best way of modeling this data. :P
         */
  
        // I'm not ~quite~ sure how to turn a string into an enum. I'll handle this one later.
        effectsList = new ActionEffects[0];  // Empty list: no effects.  I'm gonna try this instead of ActionEffects.None.
        
        actionDescription = lines[cur+3];
        
        this.valid = true;
        break;
      }
    }
    
    // If not found, valid will still be false.
    return this.valid;
  }
}


// This is the list of all equippable-action secondary effects.
// It's here instead of enums because this shit be long as hell, yo.
enum ActionEffects {
  None,    // Only necessary if effectsList is empty. And actually, not even sure about that. Does new int[0] work?
  
  // Physical Special Attributes
  PierceDEF,      // Hammers, specifically.
  BreakDEF,       // Also Hammers, specifically.  This one is more permenant.
  
  FireCast,       // How specific elements are recognized.
  IceCast,        // Does extra damage against weaknesses,
  LightningCast,  // May have extraneous effects if used on
  WaterCast,      // other things (e.g. fire burns forests).
  
  // Elemental Weaknesses
  FireWeak,
  IceWeak,
  LightningWeak,
  WaterWeak,
  
  // Elemental Strengths
  FireHalved,
  IceHalved,
  LightningHalved,
  WaterHalved,
  
  // Status Effect Inflictors
  InflictPoison,
  
  // Super Weird Special Effects
  QuantumSplit    // Split into two units until something collapses your wave function.
}