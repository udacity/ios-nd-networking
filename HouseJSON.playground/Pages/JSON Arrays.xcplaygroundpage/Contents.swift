//: [Previous](@previous)
import Foundation

let json = """
[
    {
        "type": "colonial",
        "location": "Plainville, MA",
        "bedrooms": 3,
        "bathrooms": 2.5,
        "has air conditioning": false,
        "amenities": ["basement", "garden"]
    },
    {
        "type": "condo",
        "location": "San Francisco, CA",
        "bedrooms": 1,
        "bathrooms": 1,
        "has air conditioning": true,
        "amenities": []
    }
]
""".data(using: .utf8)!

struct House: Codable {
    let houseType: String
    let location: String
    let beds: Int
    let baths: Float
    let hasAirConditioning: Bool
    let amenities: [String]
    
    enum CodingKeys: String, CodingKey {
        case houseType = "type"
        case location = "location"
        case beds = "bedrooms"
        case baths = "bathrooms"
        case hasAirConditioning = "has air conditioning"
        case amenities
    }
}

let decoder = JSONDecoder()
do {
    let house = try decoder.decode([House].self, from: json)
    print(house)
} catch {
    print(error)
}

//: [Next](@next)
