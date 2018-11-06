//: [Previous](@previous)

import Foundation

var json = """
{
    "name": "Neha",
    "studentId: 326156,
    "academics": {
        "field": "iOS",
        "grade": "A"
    }
}
""".data(using: .utf8)!

struct Academics: Codable {
    let field: String
    let grade: String
}

struct Student: Codable {
    let name: String
    let studentId: String
    let academics: Academics
}

let decoder = JSONDecoder()
let student: Student

do {
    student = try decoder.decode(Student.self, from: json)
    print(student)
} catch {
    print(error)
}

//: [Next](@next)
