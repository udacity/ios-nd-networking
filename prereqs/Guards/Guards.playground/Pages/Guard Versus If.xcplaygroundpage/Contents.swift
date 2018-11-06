//: [Previous](@previous)
//: ### Guard Versus If
//: While `guard` and `if` are similar, they should not be used interchangeably. Instead, it is recommended that **guard is used for preconditions (and early exit)** and **if is used for changing the execution path**. Using the flight example from before, notice the difference in how `guard` and `if` are used.
//:
func takeOff(passengersSeated: Bool, crewReady: Bool, runwayClear: Bool, runwayShort: Bool) {
    // are all preconditions met?
    guard passengersSeated, crewReady, runwayClear else { return }
    
    // (optional) if the runway is short, then enable high speed takeoff mode
    if runwayShort {
        print("💥 High speed takeoff enabled")
    }
    
    print("✈️ Lifts off runway")
}

takeOff(passengersSeated: true, crewReady: true, runwayClear: true, runwayShort: true)
//: Of course, there are situations where using `guard` or `if` may be less clear, and that's ok — this isn't an exact science. The best rule of thumb is to make sure code is readable and concise!
//:
enum Experience {
    case novice, expert
}

struct Pilot {
    var name: String
    var formerExperience: Experience
    var completedFlights: Int
}

func checkPilot1(_ pilot: Pilot) {
    // here, checking for experience creates multiple code paths
    if pilot.formerExperience == .novice {
        // guard is a precondition to check if the pilot is ready, otherwise early exit!
        guard pilot.completedFlights > 20 else { return }
        print("ready to fly, rookie?")
    } else if pilot.formerExperience == .expert {
        guard pilot.completedFlights > 5 else { return }
        print("you're up chief")
    }
}

func checkPilot2(_ pilot: Pilot) {
    // for conciseness, experience and completed flights could be checked at the same time
    if pilot.formerExperience == .novice && pilot.completedFlights > 20 {
        print("ready to fly, rookie?")
    } else if pilot.formerExperience == .expert && pilot.completedFlights > 5 {
        print("you're up chief")
    }
}

func checkPilot3(_ pilot: Pilot) {
    // a switch statement could also be used
    switch pilot.formerExperience {
    case .novice:
        guard pilot.completedFlights > 20 else { return }
        print("ready to fly, rookie?")
    case .expert:
        guard pilot.completedFlights > 5 else { return }
        print("you're up chief")
    }
}

let teddy = Pilot(name: "Teddy", formerExperience: .novice, completedFlights: 22)

checkPilot1(teddy)
checkPilot2(teddy)
checkPilot3(teddy)
//: [Next](@next)
