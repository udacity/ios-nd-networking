//: [Previous](@previous)
//: ### Extract with If
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
//: Write an if statement that extracts and prints the associated value for `effect` when the case is equal to `.pitch`.
//:

//: - Callout(Exercise):
//: Write an if statement that extracts and prints the associated value for `effect` when the case is equal to `.pitch` and the associated value is greater than or equal to 0.5.
//:

//: [Next](@next)
