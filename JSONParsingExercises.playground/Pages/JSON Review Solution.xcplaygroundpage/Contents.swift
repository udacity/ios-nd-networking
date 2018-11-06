//: [Previous](@previous)

import Foundation

var json = """
{
    "name": "Earth",
    "type": "rocky",
    "standardGravity": 9.81,
    "hoursInDay": 24
}
""".data(using: .utf8)!

// create a struct called "Planet" that conforms to Codable
// the struct should have properties with matching names and data types to the JSON
struct Planet: Codable {
    let name: String
    let type: String
    let standardGravity: Double
    let hoursInDay: Int
}

// create a JSON decoder
let decoder = JSONDecoder()

// decode the JSON into your model object and print the result
do {
    let earth = try decoder.decode(Planet.self, from: json)
    print(earth)
} catch {
    print(error)
}

//: [Next](@next)
