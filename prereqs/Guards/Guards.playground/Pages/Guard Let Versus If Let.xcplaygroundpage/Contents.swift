//: [Previous](@previous)
//: ### Guard Let Versus If Let
//: When optional values are used with `guard let` (or `guard var`) they are bound as non-optional values and available in the rest of the scope where the guard statement appears. This differs from how optionals work with `if let`. With `if let`, optionals are bound as non-optional constants, and they are only available in the body of the `if let` statement.
//:
func takeOff(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool, crewLeader: String?, greeting: String?) {
    guard passengersSeated, crewReady, runwayClear else { return }
    guard let crewLeader = crewLeader else { return }
    
    // the crew leader is available throughout this function
    print("\(crewLeader): \"Takeoff checks complete!\"")
    
    if let greeting = greeting {
        // the greeting is only available as a constant in the body of the if statement
        print("\(crewLeader): \"\(greeting)\"")
    }
    
    // here, the greeting is optional
    if greeting != nil {
        print("greeting = \(greeting!)")
    }
    
    print("✈️ Lifts off runway")
}

takeOff(passengersSeated: true, crewReady: true, runwayClear: true, crewLeader: "👩🏻‍✈️ Natasha", greeting: "Taking off in 3...2...1!")
