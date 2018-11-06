//: [Previous](@previous)
//: ### Handle Errors
//: - Callout(Exercise):
//: Modify the error handling for `whatsThatError` so it catches the specific error being thrown when the `url` is set to the main bundle URL.
//:
import Foundation

func whatsThatError(url: URL) {
    do {
        let content = try String(contentsOf: url, encoding: .utf8)
        print(content)
    } catch {
        print(error)
    }
}

whatsThatError(url: Bundle.main.bundleURL)
//: [Next](@next)

