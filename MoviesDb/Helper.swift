

import Foundation

// Helper to get the API key from the Info.plist, which inherits from the xcconfig
var apiKey: String {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
        fatalError("API_KEY is missing from Info.plist / Please create Secrets.plist with an API_KEY")
    }
    return key
}
