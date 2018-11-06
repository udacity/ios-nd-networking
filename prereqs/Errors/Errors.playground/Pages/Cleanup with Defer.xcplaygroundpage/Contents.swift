//: [Previous](@previous)
//: ### Cleanup with Defer
//: The `defer` keyword is often coupled with error handling because it can be used to execute a block of code before an error-generating scope is exited.
//:
import Foundation

enum PurchaseError: Error {
    case invalidAddress
    case cardRejected
    case cartWeightLimitExceeded(Double)
    case insufficientStock(String)
}

func processOrder() throws {
    throw PurchaseError.cardRejected
}

func attemptPurchase() {
    // before this function exits, execute this defer block
    defer {
        print("close the secure purchase session")
    }
    
    do {
        try processOrder()
    } catch {
        print(error)
    }
}

attemptPurchase()
//: - Callout(Watch Out!):
//: A defer block cannot contain code that changes the flow of control, like a break or return statement, or throwing an error.
func attemptPurchaseBadDefer() {
    // before this function exits, execute this defer block
    defer {
        print("close the secure purchase session")
        // uncomment this break to see Xcode complain about flow of control
        //break
    }
    
    do {
        try processOrder()
    } catch {
        print(error)
    }
}
//: Multiple defer blocks may be defined, but are executed in reverse order of when they appear.
func attemptPurchaseWithMultipleDefers() {
    // before this function exits, execute this defer block
    defer { print("then, close the secure purchase session") }
    defer { print("first, clear order") }
    
    do {
        try processOrder()
    } catch {
        print(error)
    }
}

attemptPurchaseWithMultipleDefers()
