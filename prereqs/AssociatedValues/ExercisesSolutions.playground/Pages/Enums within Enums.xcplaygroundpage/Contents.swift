//: [Previous](@previous)
//: ### Enums within Enums
//: - Callout(Exercise):
//: Define an enum called `SConfig` representing the different configurations for the 2017 Tesla Model S vehicle. Use a raw type (Double) to represent its starting price in USD. The following image contains the possible configurations:
//:
//: ![model-s](/modelS.png)
//:
enum SConfig: Double {
    case sixty = 68000, sixtyD = 73000
    case seventyFive = 69500, seventyFiveD = 74500
    case ninetyD = 87500
    case oneHundredD = 94000, pOneHundredD = 135000
}
//: - Callout(Exercise):
//: Define an enum called `XConfig` representing the different configurations for the 2017 Tesla Model X vehicle. Use a raw type (Double) to represent its starting price in USD. The following image contains the possible configurations:
//:
//: ![model-s](/modelX.png)
//:
enum XConfig: Double {
    case seventyFiveD = 79500
    case ninetyD = 93500
    case oneHundredD = 96000, pOneHundredD = 140000
}
//: - Callout(Exercise):
//: Define an enum called `ThreeType` representing the different types for the 2017 Tesla 3 vehicle. Use a raw type (Double) to represent its starting price in USD. The following image contains the possible types:
//:
//: ![model-s](/model3.png)
//:
enum ThreeType: Double {
    case standard = 35000, longRange = 44000
}
//: - Callout(Exercise):
//: Define an enum called `Tesla2017` representing Tesla's cars for 2017 — the Model S, Model X, and Model 3. Each case (car) should have an associated value for the different configuration or type for that model. Create a constant called `newCar` that is a Standard Tesla 2017 Model 3.
//:
enum Tesla2017 {
    case modelS(config: SConfig)
    case modelX(config: XConfig)
    case model3(type: ThreeType)
}

let newCar = Tesla2017.model3(type: .standard)
//: - Callout(Exercise):
//: Use a switch statement to extract and print the starting the value for `newCar`. The switch statement should be able to handle any type of Tesla 2017 model.
//:
switch newCar {
case .modelS(let config):
    print(config.rawValue)
case .modelX(let config):
    print(config.rawValue)
case .model3(let type):
    print(type.rawValue)
}
