import Foundation

let urlString = "https://itunes.apple.com/us/app/udacity/id819700933?mt=8"
let url = URL(string: urlString)
if let url = url {
    print("URL: \(url)")
}

if let url = url {
    print("URL: \(url)")
    print("scheme:\t\t\(String(reflecting: url.scheme))")
    print("user:\t\t\(String(reflecting: url.user))")
    print("password:\t\(String(reflecting: url.password))")
    print("host:\t\t\(String(reflecting: url.host))")
    print("port:\t\t\(String(reflecting: url.port))")
    print("path:\t\t\(String(reflecting: url.path))")
    print("query:\t\t\(String(reflecting: url.query))")
    print("fragment:\t\(String(reflecting: url.fragment))")
}

var iTunesBaseURLString = "https://itunes.apple.com/"
var simpleURL = URL(string: iTunesBaseURLString)
simpleURL?.appendPathComponent("us")
print("simpleURL: \(simpleURL!)" )
simpleURL?.appendPathComponent("app")
simpleURL?.appendPathComponent("udacity")
simpleURL?.appendPathComponent("id819700933")
print("simpleURL: \(simpleURL!)" )
simpleURL?.appendPathComponent("?mt=8")
print("simpleURL: \(simpleURL!)" )
