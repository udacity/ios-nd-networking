//: [Previous](@previous)

import Foundation

var json = """
{
    "name": "Neha",
    "studentId": 326156,
    "academics": {
        "field": "iOS",
        "grade": "A"
    }
}
""".data(using: .utf8)!

// define model objects here


let decoder = JSONDecoder()
let student: Student

do {
    // decode the JSON into the "student" constant
    print(student)
} catch {
    print(error)
}

//: [Next](@next)
