
// Most enums I've written are sort of tied directly to the class they're included with.
// Pretty much all of them are referenced all over the program, however.
// This file is just going to contain all of them to make finding them (editing them, etc.)
// easier to do. It will all be very centralized.


// Created for TurnMachine so it knows which team's turn it is.
// Also used elsewhere as the definition of what team is what team.
enum Team {
  Allies, Enemies
}


// Created for TurnMachine so it knows which state it's currently in.
// Used elsewhere, probably, just to compare where and wheren't it is.
enum TurnState {
  MatchSetup, PreTurnSetup,                  // State 0: Set turn to player's turn.
  PickUnit, PickMoveTile, PickAction,        // The first three things all units do.
  PickEnemy, PickAlly, PickTarget, PickTile, // Different kinds of action qualifiers.
  Confirm, Act,                              // Player confirm and carry out effects.
  CheckUnits, ChangeTurn,                    // If all teamUnits are inactive -> next
  Win, Lose                                  // End of match
}


// Created for Selector so it knows which kind of tile/tile-inhabitant it's looking for.
// Used elsewhere to tell Selector which kind it should look for.
//   (I wonder, actually, if there's a way I could give it something to "sniff" and have it
//   figure out what kind it is on its own.)
enum TargetType {
  NONE,
  Ally,
  Enemy,
  MoveTile,
  OpenTile,
  AnyTile,
  Self
}