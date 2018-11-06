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
extension GrammarError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .passiveVoice:
            return "Passive voice is used. It is unclear who is doing what. Use active voice instead."
        case .improperTense:
            return "The subject and verb tenses do not agree."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .passiveVoice:
            return "The subject of the sentence does not perform the verb."
        case .improperTense:
            return "The subject and verb tenses do not agree."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .passiveVoice:
            return "Modify the sentence so the subject performs the verb."
        case .improperTense:
            return "If the subject is singular, use a singular verb (e.g. \"The dog runs.\"). If the subject is plural, use a plural verb (e.g. \"The dogs run.\")"
        }
    }
    
    public var helpAnchor: String? {
        switch self {
        case .passiveVoice:
            return "Oh no! Not passive voice!"
        case .improperTense:
            return "In English, the tense of a subject or verb can often be changed by adding or removing the letter 's' (e.g. \"The dog run\" becomes \"The dog runs\")."
        }
    }
}

//: - Callout(Exercise):
//: Extend `GrammarError` such that it implements the `CustomNSError` protocol. (Optional) Provide creative values for all `CustomNSError` properties.
//:
extension GrammarError: CustomNSError {
    public static var errorDomain: String {
        return "GrammarPolice"
    }
    
    public var errorCode: Int {
        switch self {
        case .passiveVoice:
            return 0
        case .improperTense:
            return 1
        }
    }
    
    public var errorUserInfo: [String: Any] {
        switch self {
        case let .passiveVoice(sentence), let .improperTense(sentence):
            return [
                "length": sentence.count
            ]
        }
    }
}

//: - Callout(Exercise):
//: Call `throwGrammarError` casting any thrown error into an `NSError`. Then, print the error's localized description and the values of all its `NSError` properties.
//:
do {
    try throwGrammarError()
} catch let error as NSError {
    print(error.localizedDescription)
    print(error.domain)
    print(error.code)
    print(error.userInfo)
} catch {
    print(error)
}

//: [Next](@next)
