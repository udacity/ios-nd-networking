//: [Previous](@previous)
//: ### Create Custom Errors
//: - Callout(Exercise):
//: Define a enum called `GrammarError` that implements the `Error` protocol and has two cases `passiveVoice` and `improperTense`. Each case should have an associated `String` value.
//:
enum GrammarError: Error {
    case passiveVoice(String)
    case improperTense(String)    
}

//: - Callout(Exercise):
//: Define a function called `throwGrammarError` that immediately throws the error `GrammarError.passiveVoice`. (Optional) For the error's associated value, pass a string that contains an example of passive voice.
//:
func throwGrammarError() throws {
    throw GrammarError.passiveVoice("The test was taken by the student.")
}

do {
    try throwGrammarError()
} catch {
    print(error)
}

//: [Next](@next)
