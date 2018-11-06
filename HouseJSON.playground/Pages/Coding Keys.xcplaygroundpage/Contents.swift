import Foundation

let json = """
{
    "type": "colonial",
    "location": "Plainville, MA",
    "bedrooms": 3,
    "bathrooms": 2.5,
    "has air conditioning": false
}
""".data(using: .utf8)!

struct House: Codable {
    let houseType: String
    let location: String
    let beds: Int
    let baths: Float
    let hasAirConditioning: Bool
    
    enum CodingKeys: String, CodingKey {
        case houseType = "type"
        case location = "location"
        case beds = "bedrooms"
        case baths = "bathrooms"
        case hasAirConditioning = "has air conditioning"
    }
}

let decoder = JSONDecoder()
do {
    let house = try decoder.decode(House.self, from: json)
    print(house)
} catch {
    print(error)
}

//: [Next](@next)
