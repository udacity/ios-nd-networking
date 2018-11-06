//: [Previous](@previous)
//: ### Propagate Errors
//: - Callout(Exercise):
//: Modify `readFileContents` so that it propagates any errors thrown by the String initializer.
//:
import Foundation

func readFileContents(url: URL) throws {
    let content = try String(contentsOf: url, encoding: .utf8)
    print(content)
}

do {
    try readFileContents(url: Bundle.main.bundleURL)
} catch {
    print(error)
}

//: [Next](@next)
