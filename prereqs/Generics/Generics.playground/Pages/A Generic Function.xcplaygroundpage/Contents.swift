//: [Previous](@previous)
//: ### A Generic Function
//: Generics can be applied to functions and types. To write a generic function, specify a generic type after the function name using the bracket notation (ex. `func myFunction<Type>`). Then, for any arguments that should be generic, use the generic type instead of a concrete type. Below, the generic type is called `T`; `T` can represent any type.
//:
// argument is of type `T`, it can be anything
func printType<T>(_ argument: T) {
    print(type(of: argument))
}

printType(4)
printType("udacity")
printType(4.5)
printType(false)
//: For readability, give a generic type a more descriptive name.
//:
func printTypeWithNamedGenericType<Type>(_ argument: Type) {
    print(type(of: argument))
}

printTypeWithNamedGenericType(4)
printTypeWithNamedGenericType("udacity")
printTypeWithNamedGenericType(4.5)
printTypeWithNamedGenericType(false)
//: Without generics, a developer would have to duplicate code to handle differing types — even if the types are being used the same way!
//:
func printIntType(_ int: Int) {
    print(type(of: int))
}

func printStringType(_ string: String) {
    print(type(of: string))
}

printIntType(4)
printStringType("udacity")
//: A generic type can be bound or constrained such that it can only represent concrete types which adhere to some protocol or inherit from a certain class. In the example below, the generic type is constrained such that it can only represent types which implement the `UnsignedInteger` protocol — essentially, non-negative integers.
//:
func printUIntTypes<Type: UnsignedInteger>(_ argument: Type) {
    print(type(of: argument))
}

let unsignedInt: UInt = 4
let unsignedInt8: UInt8 = 4
let unsignedInt16: UInt16 = 4

printUIntTypes(unsignedInt)
printUIntTypes(unsignedInt8)
printUIntTypes(unsignedInt16)
//: - Callout(Watch Out!):
//: When a generic type is constrained, any concrete types that do not adhere to the constraint will cause Xcode to complain.
//:
// uncomment the lines below to see Xcode complain that 4 (Int), -4 (Int), and "abc" (String) do not implement the `UnsignedInteger` protocol, and cannot be used in place of the generic type
//printUIntTypes(4) /* `Int` is not unsigned because it can store negative values */
//printUIntTypes(-4)
//printUIntTypes("abc")
//: [Next](@next)
