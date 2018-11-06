//: [Previous](@previous)
//: ### Extract with Switch
//: The following exercises will use `AudioEffect`.
//:
enum AudioEffect {
    case rate(value: Double)
    case pitch(value: Double)
    case echo
    case reverb
}

let effect = AudioEffect.pitch(value: 0.5)
//: - Callout(Exercise):
//: Write a switch statement using the `effect` constant that extracts all possible associated values as constants. Print any extracted associated values.
//:
switch effect {
case let .rate(value):
    print("play audio with rate of: \(value)")
case let .pitch(value):
    print("play audio with pitch of: \(value)")
case .echo:
    print("play audio with echo effect")
case .reverb:
    print("play audio with reverb effect")
}
//: - Callout(Exercise):
//: Write a switch statement using the `effect` constant that ignores associated values.
//:
switch effect {
case .rate:
    print("rate effect")
case .pitch:
    print("pitch effect")
case .echo:
    print("echo effect")
case .reverb:
    print("reverb effect")
}
//: - Callout(Exercise):
//: Write a switch statement using the `effect` constant that extracts the associated value for `.rate` or `.pitch` into a variable. Then, divide the variable by half and print the resulting value. All other cases can be ignored using the default case.
//:
switch effect {
case .rate(var value), .pitch(var value):
    value *= 0.5
    print("\(value)")
default:
    break
}
//: - Callout(Exercise):
//: Write a switch statement using the `effect` constant that prints the associated value for `.pitch` only when it is greater than 0.4. Use the `where` keyword to complete this exercise (i.e. don't use an if statement). All other cases can be ignored using the default case.
//:
switch effect {
case let .pitch(value) where value > 0.4:
    print("\(value)")
default:
    break
}
//: [Next](@next)
