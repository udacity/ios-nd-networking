//: [Previous](@previous)

import Foundation

var json = """
{
    "food_name": "Lemon",
    "taste": "sour",
    "number of calories": 17
}
""".data(using: .utf8)!

struct Food: Codable {
    let name: String
    let taste: String
    let calories: Int
    
    // add CodingKeys enum here
}

let decoder = JSONDecoder()
let food: Food

do {
    
    food = try decoder.decode(Food.self, from: json)
    print(food)
} catch {
    print(error)
}

//: [Next](@next)
