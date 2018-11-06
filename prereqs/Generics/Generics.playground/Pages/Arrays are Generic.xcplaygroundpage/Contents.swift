//: [Previous](@previous)
//: ### Arrays are Generic
//: Upon first glance, many do not realize that Swift arrays use generics. Specifically, the type that a Swift array stores is generic — it can be anything. When declaring an array using its more longhand syntax, this becomes apparent.
//:
var intArray = Array<Int>()
intArray.append(4)
intArray.append(2)
print(intArray)
//: The type specified in the brackets (ex. "<String>") is called a "concrete type". When specified, the concrete type takes the place of a generic type.
//:
var stringArray: Array<String> = ["one", "two", "three"]
print(stringArray)
//: Because Swift arrays use generics, they behave the same, regardless of the concrete type.
print(intArray.count)
print(stringArray.count)

intArray.append(6)
stringArray.append("six")

intArray.removeAll()
stringArray.removeAll()

print(intArray.count)
print(stringArray.count)
//: [Next](@next)
