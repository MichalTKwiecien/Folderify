import Foundation

public extension URL {
    /// Initializer for known URLs. It return non optional URL and crashes the app in case of wrong URL. Use only for known static URLs.
    init(safe url: String) {
        self = URL(string: url)!
    }
}
