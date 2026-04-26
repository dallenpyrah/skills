import { Effect, Console } from "effect";

// Turnstile Machine?

/*
    Logic:

    State: The machine can be Unlocked or Locked
    Events: InsertCoin -> Unlocks
    Push -> Locked

    State: Locked
    Event: InsertCoin
    Transition: Unlocked

    State: Unlocked
    Event: InsertCoin
    Transition: Unlocked

    State: Unlocked
    Event: Invalid Operation
    Transition: Unlocked
*/
