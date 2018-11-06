//: [Previous](@previous)
//: ### Subclass a Generic Type
//: A generic type can be subclassed, assuming it is a class and not a struct. To setup the following example, the `Animal`, `Whale`, and `ZooExhibit` types are defined.
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

class ZooExhibit<AnimalType: Animal> {
    let animals: [AnimalType]
    
    init(animals: [AnimalType]) {
        self.animals = animals
    }
    
    func tourTheExhibit() {
        print("Welcome to the \(AnimalType.commonName) Exhibit \(AnimalType.emoji)!")
        for animal in animals {
            print("Say hello to \(animal.name) \(AnimalType.emoji).")
        }
    }
}
//: To subclass the generic type `ZooExhibit`, one must define a new class with a generic type that can be substituted for `AnimalType` (any type that implements the `Animal` protocol). In the subclass below, the generic type `A` is constrained such that it must implement the `Animal` protocol. Hence, when `ZooExhibit` is specified as the superclass, the type `A` can be used without error.
//:
class TravelingExhibit<A: Animal>: ZooExhibit<A> {
    var location: String
    
    init(location: String, animals: [A]) {
        self.location = location
        super.init(animals: animals)
    }
    
    override func tourTheExhibit() {
        print("Welcome to the \(A.commonName) Exhibit \(A.emoji) at \(location)!")
        for animal in animals {
            print("Say hello to \(animal.name) \(A.emoji).")
        }
    }
}

let exhibit1 = TravelingExhibit(location: "Oakland Zoo", animals: [Whale(name: "Watson"), Whale(name: "Wren")])
exhibit1.tourTheExhibit()

// change exhibit location
exhibit1.location = "San Francisco Zoo"
exhibit1.tourTheExhibit()
//: - Callout(Watch Out!):
//: If a generic type constraint is not fulfilled when subclassing a generic type, then Xcode will complain.
//:
// uncomment the class definition below to see Xcode complain that `TankExhibit`'s generic type `A` does not confirm to the `Animal` protocol.
/*
class TankExhibit<B>: ZooExhibit<B> {
    let volume: Double
    
    init(volume: Double, animals: [B]) {
        self.volume = volume
        super.init(animals: animals)
    }
}
*/
//: [Next](@next)
