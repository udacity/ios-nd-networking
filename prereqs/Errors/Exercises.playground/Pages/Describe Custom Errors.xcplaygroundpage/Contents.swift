//: [Previous](@previous)
//: ### Describe Custom Errors
//: The following exercises will use the `GrammarError` enum and `throwGrammarError` function.
//:
import Foundation

enum GrammarError: Error {
    case passiveVoice(String)
    case improperTense(String)
}

func throwGrammarError() throws {
    throw GrammarError.passiveVoice("The test was taken by the student.")
}

//: - Callout(Exercise):
//: Extend `GrammarError` such that it implements the `LocalizedError` protocol. (Optional) Provide creative values for all `LocalizedError` properties.
//:

//: - Callout(Exercise):
//: Extend `GrammarError` such that it implements the `CustomNSError` protocol. (Optional) Provide creative values for all `CustomNSError` properties.
//:

//: - Callout(Exercise):
//: Call `throwGrammarError` casting any thrown error into an `NSError`. Then, print the error's localized description and the values of all its `NSError` properties.
//:

//: [Next](@next)
