import Foundation

#if DEBUG
    extension URL {
        static let mock = URL(string: "www.something.com")!
    }
#endif
