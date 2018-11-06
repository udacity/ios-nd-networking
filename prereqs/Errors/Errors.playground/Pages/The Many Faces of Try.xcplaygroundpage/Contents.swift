//: [Previous](@previous)
//: ### The Many Faces of Try
//: The `try` keyword is used to execute error-prone code. If an error is generated while using the `try` keyword, it must be handled immediately or propagated.
//:
import Foundation

func printFileContents() {
    if let fileURL = Bundle.main.url(forResource: "swift", withExtension: "txt") {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            print(content)
        } catch {
            print("\(error)")
        }
    }
}

printFileContents()
//: Try comes in two other forms: `try?` and `try!`. `try?` executes error-prone code, and if any error is generated, then it is converted into an optional where the underlying value has the same type as the error-prone function or intializer's return type. This can simplify code, but the ability to analyze errors is lost.
//:
func printFileContentsTry() {
    if let fileURL = Bundle.main.url(forResource: "swift", withExtension: "png") {
        let content = try? String(contentsOf: fileURL, encoding: .utf8)
        print(content ?? "content is nil")
        
        // preferably, combine `if let` with `try?`; it's easier to read
        if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
            print(content)
        } else {
            print("could not read contents of file into string")
        }
    }
}

printFileContentsTry()
//: - Callout(Watch Out!):
//: If `try?` is used to set an optional value, but the function that throws but doesn't return a type (returns `Void`), then Xcode will generate a warning.
//:
func readFileIntoString(fileName: String, fileExtension: String) throws {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        print(content)
    }
}

// uncomment the following line to see Xcode generate a warning
// let unknownType = try? readFileIntoString(fileName: "swift", fileExtension: "png")
//: `try!` executes error-prone code while foregoing any opportunity to safely handle an error. If an error-prone function is called using `try!` and it fails, then the entire app or playground crashes.
//:
// try! should only be used if there is no risk of error; generally, this is not advised
if let fileURL = Bundle.main.url(forResource: "swift", withExtension: "txt") {
     let content = try! String(contentsOf: fileURL, encoding: .utf8)
     print(content)
}

// when try! is used and an error occurs, the executable (here, a playground) crashes
if let fileURL = Bundle.main.url(forResource: "swift", withExtension: "png") {
    print("try! reading \(fileURL.lastPathComponent) at your own risk")
    // uncommenting the following lines will crash the playground
    /*
    let content = try! String(contentsOf: fileURL, encoding: .utf8)
    print(content)
    */
}
//: [Next](@next)
