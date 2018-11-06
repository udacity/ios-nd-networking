//: [Previous](@previous)
//: ### Create Custom Errors
//: To create a custom error, define a type that inherits from the `Error` protocol. Often, enums are used for this purpose.
//:
enum SimplePurchaseError: Error {
    case invalidAddress
    case cardRejected
    case cartWeightLimitExceeded
    case insufficientStock
}

func makeBadPurchase() throws {
    throw SimplePurchaseError.cardRejected // throw a custom error
}

do {
    try makeBadPurchase()
} catch {
    print(error)
}
//: When using an enum to define a custom error, use associated values to add helpful debugging information.
//:
enum ComplexPurchaseError: Error {
    case invalidAddress
    case cardRejected
    case cartWeightLimitExceeded(Double)
    case insufficientStock(String)
}

func attemptPurchase(withWeight weight: Double) throws {
    if weight > 100 {
        // throw a custom error with an associated value
        throw ComplexPurchaseError.cartWeightLimitExceeded(-1 * (100 - weight))
    } else {
        print("purchase succeeded!")
    }
}

do {
    try attemptPurchase(withWeight: 125.6)
} catch let error as ComplexPurchaseError {
    switch error {
    case let .cartWeightLimitExceeded(weight): /* extract the associated value */
        print("purchase failed. weight exceeds limit by: \(weight)")
    default:
        print(error)
        break
    }
} catch {
    print(error)
}
//: [Next](@next)
