import Foundation

public extension World {
    struct System {
        /// Always use this instead of Date(), unless creating static mocks in World module - in that case use Date.mock.
        @AnyAutoClosure(mock: .mock) public var now = { Date() }
        @AnyAutoClosure(mock: .mock) public var timeZone = { TimeZone.autoupdatingCurrent }
        @AnyAutoClosure(mock: .mock) public var locale = { Locale.autoupdatingCurrent }
    }
}

extension Date {
    // Matching currently used mock: 2022-01-27
    static let mock = Date(timeIntervalSince1970: 1643241600)
}

private extension TimeZone {
    static let mock = TimeZone(abbreviation: "CST")!
}

private extension Locale {
    static let mock = Locale(identifier: "en_US")
}
