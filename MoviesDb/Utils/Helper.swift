

import Foundation

/// Helper var to get the API key from the Secrets.plist
var apiKey: String {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
        fatalError("API_KEY is missing from Info.plist / Please create Secrets.plist with an API_KEY")
    }
    return key
}

/// Helper func to convert string date format to be more readable
/// Takes date as yyyy-MM-dd and returns as MMMM dd, yyyy
/// Ex. 09-03-2025 -> September 03, 2025
/// If conversion fails returns the input date
func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
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
