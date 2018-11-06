//: [Previous](@previous)
//: ### Error Handling Summary
//: Below, options for handling errors are summarized.
//:
//: **1. Handle Error with `Do`-`Catch`**
//:
import Foundation

func readFileIntoStringDoCatch(fileName: String, fileExtension: String) {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            print(content)
        } catch {
            print("error handled immediately!")
        }
    }
}

readFileIntoStringDoCatch(fileName: "swift", fileExtension: "png")
//: **2. Convert Error to Optional with `try?`**
//:
func readFileIntoStringOptional(fileName: String, fileExtension: String) {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
            print(content)
        } else {
            print("could not read contents of file into string")
        }
    }
}

readFileIntoStringDoCatch(fileName: "swift", fileExtension: "png")
//: **3. Ignore Error with `try!`**
//:
func readFileIntoStringOrCrash(fileName: String, fileExtension: String) {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        let content = try! String(contentsOf: fileURL, encoding: .utf8)
        print(content)
    }
}

readFileIntoStringOrCrash(fileName: "swift", fileExtension: "txt")
//: **4. Propagate the Error**
//:
func readFileIntoStringOrPropagate(fileName: String, fileExtension: String) throws {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        print(content)
    }
}

do {
    try readFileIntoStringOrPropagate(fileName: "swift", fileExtension: "png")
} catch {
    print("the error was propagated to me, and I handled it!")
}
//: [Next](@next)
