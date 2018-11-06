//: [Previous](@previous)
//: ### Associated Values
//: Associated values are defined alongside enum cases. Associated values are not required; some enum cases may have an associated value while others do not. In the example below, `LibraryFee` has three cases with associated values and a case without an associated value.
//:
enum LibraryFee {
    case overdueBook(Int)
    case lostBook(Double)
    case lostLibraryCard(Int)
    case annualDues
}

let fee = LibraryFee.overdueBook(4)
//: It can be very helpful to name associated values so that their intent is easily understood.
//:
enum DescriptiveLibraryFee {
    case overdueBook(days: Int)
    case lostBook(price: Double)
    case lostLibraryCard(timesLost: Int)
    case annualDues
}

let weekLateFee = DescriptiveLibraryFee.overdueBook(days: 7)
//: Associated values are actually tuples. Therefore, an associated value can contain mutliple values. Recall from [Apple's documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID329) that tuples are multiple values grouped into a single compound value.
//:
import UIKit

enum ImageFilter {
    case sepia
    case verticalGradient(from: UIColor, to: UIColor)
    case horizontalGradient(from: UIColor, to: UIColor)
    case sketch(penThickness: Double?)
}

let fadeToBlack = ImageFilter.horizontalGradient(from: .gray, to: .black)
//: - Callout(Watch Out!):
//: If all enum cases have an associated value of the same type, and it is static, then you might consider using a raw value instead.
//:
// the associated values for `AudioRateAssociated` should be raw values
enum AudioRateAssociated {
    case slow(value: Int)
    case normal(value: Int)
    case fast(value: Int)
    case custom(value: Int)
}

enum AudioRateRaw: Int {
    case slow, normal, fast, custom
}
//: [Next](@next)
