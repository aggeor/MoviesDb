

import Foundation

// Helper to get the API key from the Info.plist, which inherits from the xcconfig
var apiKey: String {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
        fatalError("API_KEY is missing from Info.plist / Please create Secrets.plist with an API_KEY")
    }
    return key
}


func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd" // adjust if your string has time too
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMMM dd, yyyy"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return dateString // fallback if parsing fails
    }
}
