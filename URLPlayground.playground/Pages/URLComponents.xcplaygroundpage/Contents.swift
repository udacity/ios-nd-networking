import Foundation

let urlString = "https://itunes.apple.com/us/app/udacity/id819700933?mt=8"

let urlComponents = URLComponents(string: urlString)

if let urlComponents = urlComponents {
    print("scheme:\t\t\(String(reflecting: urlComponents.scheme))")
    print("user:\t\t\(String(reflecting: urlComponents.user))")
    print("password:\t\(String(reflecting: urlComponents.password))")
    print("host:\t\t\(String(reflecting: urlComponents.host))")
    print("port:\t\t\(String(reflecting: urlComponents.port))")
    print("path:\t\t\(String(reflecting: urlComponents.path))")
    print("query:\t\t\(String(reflecting: urlComponents.query))")
    print("fragment:\t\(String(reflecting: urlComponents.fragment))")
}

struct AppStore {
    static let scheme = "https"
    static let host = "itunes.apple.com"
    static let udacityPath = "/us/app/udacity/id819700933"
    
    enum ParameterKey: String {
        case mediaType = "mt"
    }
    
    enum MediaType: String {
        case music = "1",
        podcasts = "2",
        audiobooks = "3",
        tvShows = "4",
        musicVideos = "5",
        movies = "6",
        iPodGames = "7",
        mobileApps = "8",
        ringTones = "9",
        iTunesU = "10",
        ebooks = "11",
        desktopApps = "12"
    }

}

var udacityAppURL = URLComponents()
udacityAppURL.scheme = AppStore.scheme
udacityAppURL.host = AppStore.host
udacityAppURL.path = AppStore.udacityPath

udacityAppURL.queryItems = [URLQueryItem(name: AppStore.ParameterKey.mediaType.rawValue, value: AppStore.MediaType.mobileApps.rawValue)]
print(udacityAppURL)

