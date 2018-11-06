//: [Previous](@previous)
//: ### A Generic Type
//: Generics can be applied to an object's properties to create what is known as a generic type. Similar to generic functions, a generic type is created by specifying the object's name followed by a generic type using the bracket notation (ex. `struct MyType<Type>`). Then, for any properties that should be generic, use the generic type instead of a concrete type.
//:
import UIKit

struct TypeAnalyzer<T> {
    let value: T
    
    // represents the sub-structure of the generic type
    var mirror: Mirror {
        return Mirror(reflecting: value)
    }
    
    // print information about the type
    func analyze() {
        print("Type: \(type(of: value))")
        print("Value: \(value)")
        if let superClassMirror = mirror.superclassMirror {
            print("Superclass: \(superClassMirror.subjectType)")
        }
    }
}

let x = TypeAnalyzer(value: 2)
x.analyze()

let view = TypeAnalyzer<UIView>(value: UIView(frame: CGRect.zero))
view.analyze()
//: Like generic functions, the generic type can be named and constained. In the example below, `ZooExhibit` is defined where its animals property is generic and constrained to any type that implements the `Animal` protocol.
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

struct ZooExhibit<AnimalType: Animal> {
    let animals: [AnimalType]

    func tourTheExhibit() {
        print("Welcome to the \(AnimalType.commonName) Exhibit \(AnimalType.emoji)!")
        for animal in animals {
            print("Say hello to \(animal.name) \(AnimalType.emoji).")
        }
    }
}

let exhibit1 = ZooExhibit(animals: [Whale(name: "Wendy"), Whale(name: "Wu")])
exhibit1.tourTheExhibit()

// the longhand syntax can be used to specify the concrete type
let exhibit2 = ZooExhibit<Dolphin>(animals: [Dolphin(name: "Dilbert"), Dolphin(name: "Dezeri")])
exhibit2.tourTheExhibit()
//: - Callout(Watch Out!):
//: A single generic type can only be substituted with one concrete type. If Xcode is unable to determine the concrete type that should be substituted for a generic type, it will complain.
//:
// which type should be used? whale or dolphin? Xcode isn't sure, so it complains
// let exhibit3 = ZooExhibit(animals: [Whale(name: "Wilber"), Dolphin(name: "Daphnie")])
//: Extensions can be combined with generics for truly powerful effects. With an extension, it is possible to specify functionality that should only apply to a generic type when the concrete type meets inherits from a specific protocol.
//:
protocol Feedable {
    static var favoriteFood: String { get }
}

extension Dolphin: Feedable {
    static let favoriteFood = "🐟"
}

extension ZooExhibit where AnimalType: Feedable {
    func feedTheAnimals() {
        for animal in animals {
            print("You feed \(animal.name) \(AnimalType.emoji) some \(AnimalType.favoriteFood).")
        }
    }
}

exhibit2.feedTheAnimals()

// because `Whale` is not `Feedable`, the `feedTheAnimals()` function doesn't exist for the whale exhibit
//exhibit1.feedTheAnimals()
//: [Next](@next)
