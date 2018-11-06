//: [Previous](@previous)
//: ### Cleanup with Defer
//: The following exercises will use the `GrammarError` enum and the `analyzeSentenceGrammar` and `checkSentence` functions.
//:
import Foundation

enum GrammarError: Error {
    case passiveVoice(String)
    case improperTense(String)
}

func analyzeSentenceGrammar() throws {
    throw GrammarError.passiveVoice("The test was taken by the student.")
}

func checkSentence() {
    defer { print("play editing sound") }
    defer { print("reformat sentence for display") }
    defer { print("highlight any problems") }
    
    do {
        try analyzeSentenceGrammar()
    } catch {
        print(error)
    }
}

//: - Callout(Exercise):
//: In what order are the print statements in `checkSentence` executed?
//:
