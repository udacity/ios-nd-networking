//: [Previous](@previous)
//: ### The Guard Statement
//: Guards specify conditions that must be true for execution to continue. These conditions may be thought of as *necessary preconditions*. The example below shows how guards could be used to make preflight checks before an airplane takes off. If a guard condition is not met, then its body is executed and the function returns immediately (early exit).
//:
func takeOff(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard passengersSeated else { return }
    guard crewReady else { return }
    guard runwayClear else { return }
    print("✈️ Lifts off runway")
}

// the runway isn't clear, the airplane cannot take off
takeOff(passengersSeated: true, crewReady: true, runwayClear: false)

// all the preconditions are met, the airplane takes off!
takeOff(passengersSeated: true, crewReady: true, runwayClear: true)
//: - Callout(Watch Out!):
//: All guard conditions must be a Bool or resolve to a boolean value (true or false).
//:
// uncomment the function below to see Xcode complain that String ("true") is not a Bool
/*
 func takeOffGuardTypeFailure(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard "true" else { return }
    guard crewReady else { return }
    guard runwayClear else { return }
    print("✈️ Lifts off runway")
 }
*/
//: Guards can be combined together using commas. This can improve readability, especially in cases where conditions are related.
//:
func takeOffCombineGuards(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard passengersSeated, crewReady, runwayClear else { return }
    print("✈️ Lifts off runway")
}

takeOffCombineGuards(passengersSeated: true, crewReady: true, runwayClear: true)
//: - Callout(Watch Out!):
//: Guards must exit scope when conditions are not met. If a guard does not exit scope, then Xcode will complain.
//:
// uncomment the function below to see Xcode complain that the `passengersSeated` guard does not exit scope
/*
 func takeOffGuardFailure(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
 guard passengersSeated else { print("not exiting!") }
 guard crewReady else { return }
 guard runwayClear else { return }
 print("✈️ Lifts off runway")
 }
 */
//: Before returning, guards can execute additional code; here, a debug message is printed.
//:
func takeOffGuardWithCode(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard passengersSeated, crewReady, runwayClear else {
        print("tell passengers there will be a delay")
        return
    }
    print("✈️ Lifts off runway")
}

takeOffGuardWithCode(passengersSeated: false, crewReady: true, runwayClear: true)
//: - Callout(Watch Out!):
//: While combining guards can improve readability, it eliminates the opportunity for per-condition handling. When guards are combined, additional logic would need to be added to determine which condition failed. However, when guards are separated, it is easy to see exactly which condition failed.
//:
func takeOffGuardsPrint(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard passengersSeated else {
        print("passengers are not seated")
        return
    }
    guard crewReady else {
        print("crew is not ready")
        return
    }
    guard runwayClear else {
        print("runway is not clear")
        return
    }
    print("✈️ Lifts off runway")
}

takeOffGuardsPrint(passengersSeated: true, crewReady: false, runwayClear: true)
//: If a guard returns immediately, then consider placing it on a single line. This isn't required, but it improves readability.
//:
func takeOffGuardsSingleLine(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    // for simple guard statements, use a single line
    guard passengersSeated else { return }
    guard crewReady else { return }
    
    // when a simple guard uses multiple lines, it wastes space...
    guard runwayClear else {
        return
    }
    
    print("✈️ Lifts off runway")
}

takeOffGuardsSingleLine(passengersSeated: true, crewReady: true, runwayClear: true)
//: Generally, guard statements appear at the top of a function or block. But, depending on the situation, it may be appropriate to place a guard further down.
//:
func takeOffGuardInMiddle(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool) {
    guard passengersSeated else { return }
    guard crewReady else { return }
    
    print("Passengers, we are almost ready. Once the final check is complete, we will be taking off.")
    
    guard runwayClear else { return }
    
    print("✈️ Lifts off runway")
}

takeOffGuardInMiddle(passengersSeated: true, crewReady: true, runwayClear: true)
//: [Next](@next)
