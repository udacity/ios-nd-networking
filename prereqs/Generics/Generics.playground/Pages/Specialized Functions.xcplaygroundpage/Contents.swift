//: [Previous](@previous)

import Foundation

//: Like before, this function uses a generic. But instead of passing in a value when calling the function, we pass in a specific type. In this case the `UnsignedInteger` that we want to conver the `UInt8` into.
func convertUInt8<T: UnsignedInteger>(_ argument: UInt8, toType: T.Type) -> T {
    return T(clamping: argument)
}

let unsignedInt8: UInt8 = 4
//: passing in `UInt8.self` for the type means we want to convert this `UInt8` into a `UInt16`.
let unsignedInt16 = convertUInt8(unsignedInt8, toType: UInt16.self)
//: the value is 4, but the type is now `UInt16`
print(unsignedInt16)
print(type(of: unsignedInt16))

//: [Next](@next)
