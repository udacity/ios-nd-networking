//: [Previous](@previous)
//: ### Raw Values
//: Before looking at associated values, remember that enums can have raw values which are applied to every case. In the example below, each play speed has a raw integer value. Because explicit raw values have not been specified, the raw values begin at 0 (slow) and end with 3 (custom).
//:
enum PlaySpeed: Int {
    case slow, normal, fast, custom
}

print(PlaySpeed.slow.rawValue)
print(PlaySpeed.custom.rawValue)
//: - Callout(Watch Out!):
//: Recall, raw values are immutable (constant) and cannot be changed.
let mySpeed = PlaySpeed.slow
// mySpeed.rawValue = 3 /* causes an error */
//: If an enum uses raw string values, then each case is implicitly assigned a raw string value equal to the case's name.
//:
enum AudioRate: String {
    case slow, normal, fast, custom
}

print(AudioRate.slow.rawValue)
print(AudioRate.custom.rawValue)
//: Raw values can be set explicitly.
//:
enum Power: Int {
    case poor = 10, medium = 20, strong = 30
}

print(Power.poor.rawValue)
print(Power.strong.rawValue)
//: If some raw integer values are explicitly provided, but others are not, then implicit values are assigned as one greater than the previous raw integer value.
//:
enum Endurance: Int {
    case worst, abysmal = 10, poor, medium, strong = 30
}

print(Endurance.worst.rawValue)
print(Endurance.poor.rawValue)
print(Endurance.strong.rawValue)
//: - Callout(Watch Out!):
//: Avoid specifying explicit raw values out of increasing order. It can be confusing to read and cause errors if Xcode tries to use a raw value more than once.
//:
/* uncomment `case g` to see error. */
enum LetterToInt: Int {
    case a = 4, b, c, d, e = 2, f
    // case g /* compiler tries to implicitly set `g = 4` which fails */
}
//: It is possible to create an enum from a raw value. This is useful when a value is generated, and it should represent an enum.
//:
let moderateStrength = Power(rawValue: 20)
//: - Callout(Watch Out!):
//: Since there is no guarantee that a random value has a corresponding raw value, initialize enums from raw values in a safe way.
//:
if let myPace = AudioRate(rawValue: "custom") {
    print(myPace)
}
//: Otherwise, initializing an enum from a raw value will return nil.
//:
let myPace = AudioRate(rawValue: "not a real pace")
//: [Next](@next)
