//: [Previous](@previous)
//: ### Extract with Switch
//: To use an associated value, it must be extracted. See the following examples for different extraction techniques.
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
//: Most often, associated values are extracted in a switch block. For cases that have an associated value, the `let` keyword followed by a name will extract each  value from an associated value.
//:
switch filter1 {
case .sepia:
    print("sepia")
case .verticalGradient(let color1, let color2):
    print("vertical gradient with \(color1) and \(color2)")
case .horizontalGradient(let color1, let color2):
    print("horizontal gradient with \(color1) and \(color2)")
case .sketch(let penThickness):
    if let thickness = penThickness {
        print("sketch using \(thickness) thickness")
    } else {
        print("sketch using default thickness")
    }
}
//: Associated values can also be extracted as variables using the `var` keyword. Values extracted as variables are only available in the case where they are declared.
//:
switch filter1 {
case .horizontalGradient(var color1, let color2):
    color1 = .blue
    print("horizontal gradient with \(color1) and \(color2)")
default:
    break
}
//: To extract all values from an associated value as constants, use the `case let` syntax.
//:
switch filter1 {
case let .horizontalGradient(color1, color2):
    print("horizontal gradient with \(color1) and \(color2)")
default:
    break
}
//: To extract all values from an associated value as variables, use the `case var` syntax.
//:
switch filter1 {
case var .horizontalGradient(color1, color2):
    color1 = .red
    color2 = .blue
    print("horizontal gradient with \(color1) and \(color2)")
default:
    break
}
//: - Callout(Watch Out!):
//: Remember, switch statements must be exhaustive or Xcode will complain.
//:
// uncomment the switch statement below to see Xcode complain about a non-exhaustive switch statement.
/*
 switch filter1 {
 case .horizontalGradient(var color1, let color2):
 color1 = .blue
 print("horizontal gradient with \(color1) and \(color2)")
 }
 */
//: If it is possible to treat two cases exactly the same, even when they have associated values, then you can combine cases. Note, the associated values must be the same type.
//:
switch filter1 {
case .verticalGradient(let color1, let color2), .horizontalGradient(let color1, let color2):
    print("a gradient from \(color1) to \(color2)")
default:
    break
}
//: - Callout(Watch Out!):
//: If two cases are specified with a single case statement, then the tuple element names must match.
//:
 switch filter1 {
    // uncomment the case statement below to see Xcode complain that `color2` and `color3` must be used in every pattern (i.e. the tuple element names don't match)
    /*
    case .verticalGradient(let color1, let color3), .horizontalGradient(let color1, let color2):
        print("a gradient from \(color1) to \(color2)")
     */
 default:
    break
 }
//: If associated values are not needed for computation, then they can be ignored. The example below ignores the associated value for the horizontal gradient.
//:
switch filter1 {
case .horizontalGradient:
    print("the filter is a horizontal gradient!")
default:
    break
}
//: It is also possible to partially ignore values in an associated value, while extracting others.
//:
switch filter1 {
case .horizontalGradient(let color1, _):
    print("the horizontal gradient's first color is \(color1)")
default:
    break
}
//: - Callout(Watch Out!):
//: Note, Xcode will complain if a value is extracted, but not used.
//:
// comment the print statement with `color1` to see Xcode complain about an unused  value.
switch filter1 {
case .horizontalGradient(let color1, _):
    print("a horizontal gradient with...")
    print("\(color1)")
default:
    break
}
//: Associated values may also be extracted based on conditions specified using the `where` keyword. If all conditions are held, then the values are extracted and the case statement is executed.
//:
switch filter1 {
case .horizontalGradient(let color1, _) where color1 == .white:
    print("the horizontal gradient's first color is white")
case .horizontalGradient(_, let color2) where color2 == .black:
    print("the horizontal gradient's second color is black")
default:
    break
}
//: Associated values can be extracted using computed properties. By using a computed property, you may avoid duplicate switch statements.
extension ImageFilter {
    var colors: (from: UIColor, to: UIColor)? {
        switch self {
        case .verticalGradient(let from, let to),
             .horizontalGradient(let from, let to):
            return (from, to)
        default:
            return nil
        }
    }
    
    var penThickness: Double? {
        switch self {
        case .sketch(let penThickness):
            return penThickness
        default:
            return nil
        }
    }
}

let filter3 = ImageFilter.sketch(penThickness: 4.0)

filter1.colors?.from
filter1.colors?.to
filter3.colors

filter1.penThickness
filter3.penThickness
//: [Next](@next)
