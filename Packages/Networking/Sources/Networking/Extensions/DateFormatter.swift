import Foundation

extension DateFormatter {
    static var iso8601WithMilliseconds: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}
