//: [Previous](@previous)
//: ### Enums within Enums
//: An associated value can be an enum that defines more associated values. This makes for some interesting combinations — enums within enums within enums...
//:
import UIKit

enum Thickness: Double {
    case light = 2.0, normal = 5.0, heavy = 8.0
}

enum ImageFilter {
    case sepia
    case verticalGradient(from: UIColor, to: UIColor)
    case horizontalGradient(from: UIColor, to: UIColor)
    case sketch(penThickness: Thickness)
}

let normalSketch = ImageFilter.sketch(penThickness: .normal)
//: While enums within enums may feel extraneous, it can map nicely to real-world situations. Imagine a clothing app that needs a simple search feature. It could be implemented using enums within enums.
//:
enum ShirtSize {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
}

enum Search {
    case forShirts(sizes: [ShirtSize])
    case forName(name: String)
}

let searchForBigShirts = Search.forShirts(sizes: [.large, .extraLarge])
let searchForHenleys = Search.forName(name: "henley")
