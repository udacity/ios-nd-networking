//: [Previous](@previous)
//: ### Extract with If
//: Using a switch statement can be cumbersome if only a single case needs to be checked and extracted. To extract the associated value for a single case, use `if case`.
//:
import UIKit

enum ImageFilter {
    case sepia
    case verticalGradient(from: UIColor, to: UIColor)
    case horizontalGradient(from: UIColor, to: UIColor)
    case sketch(penThickness: Double?)
}

let filter1 = ImageFilter.horizontalGradient(from: .gray, to: .black)
let filter2 = ImageFilter.horizontalGradient(from: .white, to: .black)
//: `if case` works alongside the equals operator (=) to check and extract an associated value from an enum. While the syntax may look strange, the equals operator still behaves in an intuitive way; that is, the associated value on the left-hand side (containing `color1` and `color2`) is set equal to the associated value for the enum on the right-hand side (`filter1`).
//:
if case ImageFilter.horizontalGradient(let color1, var color2) = filter1 {
    color2 = .red
    print("horizontal gradient with \(color1) and \(color2)")
}
//: To extract all values as constants use `if case let`.
//:
if case let ImageFilter.horizontalGradient(color1, color2) = filter1 {
    print("horizontal gradient with \(color1) and \(color2)")
}
//: Complex conditionals can be formed using `if case` and conditional statements separated by commas. If the conditional statements are held true, then the values are extracted and usable from within the `if case` block.
//:
if case let ImageFilter.horizontalGradient(_, color2) = filter1, color2 == .black {
    print("the horizontal gradient's second color is \(color2)")
}
//: A single associated value can also be extracted as a computed property. By using a computed property, you may avoid duplicate `if case` statements.
//:
extension ImageFilter {
    var hasHeavyPenThickness: Bool {
        if case let ImageFilter.sketch(penThickness) = self, let thickness = penThickness, thickness > 5.0 {
            return true
        } else {
            return false
        }
    }
}

filter1.hasHeavyPenThickness
//: To learn more about extraction techniques, read [Pattern Matching, Part 4: if case, guard case, for case](http://alisoftware.github.io/swift/pattern-matching/2016/05/16/pattern-matching-4/) on Crunchy Development.
//:
//: [Next](@next)
