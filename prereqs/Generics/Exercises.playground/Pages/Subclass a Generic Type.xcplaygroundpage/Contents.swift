//: [Previous](@previous)
//: ### Subclass a Generic Type
//: The following exercises will use the `IntAnalyzer` struct. Notice the name of the property has changed from previous examples. It is now called `value1`.
//:
class IntAnalyzer<T: BinaryInteger> {
    let value1: T
    
    init(value1: T) {
        self.value1 = value1
    }
}

//: - Callout(Exercise):
//: Subclass `IntAnalyzer` to create a new struct called `IntsAnalyzer`. `IntsAnalyzer` will include a new property called `value2` which should use the generic type inherited from `IntAnalyzer`.
//:

//: - Callout(Exercise):
//: Extend `IntsAnalyzer` so that it includes a function called `analyzeInts` which prints if `value1` and `value2` are equal, if they share the same sign, and if they have the same number of trailing zero bits (e.g. `value1.trailingZeroBitCount`).
//:

//: - Callout(Exercise):
//: Create an instance of `IntsAnalyzer`, then call the `analyzeInts` function.
//:

//: [Next](@next)
