//: [Previous](@previous)
//: ### Propagate Errors
//: - Callout(Exercise):
//: Modify `readFileContents` so that it propagates any errors thrown by the String initializer.
//:
import Foundation

func readFileContents(url: URL) {
    do {
        let content = try String(contentsOf: url, encoding: .utf8)
        print(content)
    } catch {
        print(error)
    }
}

readFileContents(url: Bundle.main.bundleURL)

//: [Next](@next)
