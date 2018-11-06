//: [Previous](@previous)
//: ### Multiple Generic Types
//: Generic functions and types can specify multiple generic types, simply use a comma to separate them.
//:
// `Type1` and `Type2` can represent any type
func printCombineTypesOf<Type1, Type2>(a: Type1, b: Type2) {
    print("\(type(of: a))\(type(of: b))")
}

printCombineTypesOf(a: "abc", b: 4)
printCombineTypesOf(a: 3, b: false)
printCombineTypesOf(a: "ios", b: "android")
//: Swift dictionaries use multiple generic types; one type for keys, one type of values.
//:
var bandMembers: [String: Int] = [
    "🎷": 6,
    "🎸": 1,
    "🎺": 4,
    "🎻": 12
]

// the longhand syntax
var fruitMap: Dictionary<String, String> = [
    "apple": "the round fruit of a tree of the rose family",
    "orange": "a round juicy citrus fruit with a tough bright reddish-yellow rind",
    "strawberry": "a sweet soft red fruit with a seed-studded surface"
]
//: Regardless of a dictionary's types (keys and values), they always behave the same.
//:
print(fruitMap.count)
print(bandMembers.count)

fruitMap["grape"] = "a berry, typically green (classified as white), purple, red, or black, growing in clusters on a grapevine, eaten as fruit, and used in making wine"
bandMembers["🎤"] = 1

fruitMap.updateValue("yummy", forKey: "grape")
bandMembers.updateValue(2, forKey: "🎸")
//: With multiple generic types, the same rules apply for generic constraints.
//:
// `Type1` must implement the `UnsignedInteger` protocol
func combineUInt<Type1: UnsignedInteger, Type2>(_ int: Type1, withString string: Type2) -> String {
    return "\(int) \(string)"
}

let unsignedInt: UInt = 4
print(combineUInt(unsignedInt, withString: "zebras"))

// the first argument must be a type which implements `UnsignedInteger`
let integer = 4
//combineUInt(integer, withString: "horses")
//: Below, is an example with multiple generic types called `DualExhibit`. Note, this is just a teaching example; in practice, an implementation for `DualExhibit` might differ based on application needs.
//:
protocol Animal {
    var name: String { get }
    static var commonName: String { get }
    static var emoji: String { get }
}

struct Whale: Animal {
    let name: String
    static let commonName = "Whale"
    static let emoji = "🐳"
}

struct Dolphin: Animal {
    let name: String
    static let commonName = "Dolphin"
    static let emoji = "🐬"
}

struct DualExhibit<A1: Animal, A2: Animal> {
    let group1: [A1]
    let group2: [A2]
    
    func tourTheExhibit() {
        print("Welcome to this shared exhibit. Here you can see \(A1.commonName) \(A1.emoji) and \(A2.commonName) \(A2.emoji)!")
        for animal in group1 { print("Say hello to \(animal.name) \(A1.emoji).") }
        for animal in group2 { print("Say hello to \(animal.name) \(A2.emoji).") }
    }
}

let exhibit1 = DualExhibit(
    group1: [Whale(name: "Warren"), Whale(name: "Winona")],
    group2: [Dolphin(name: "Diego"), Dolphin(name: "Dawud")]
)
exhibit1.tourTheExhibit()

// the longhand initialization syntax can still be used
let exhibit2 = DualExhibit<Whale, Dolphin>(
    group1: [Whale(name: "Wayne"), Whale(name: "Wit")],
    group2: [Dolphin(name: "Diana"), Dolphin(name: "Demetria")]
)
exhibit2.tourTheExhibit()
