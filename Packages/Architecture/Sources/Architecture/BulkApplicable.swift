import Foundation

public protocol BulkApplicable {
    mutating func apply(_ update: (inout Self) -> Void)
}

public extension BulkApplicable {
    mutating func apply(_ update: (inout Self) -> Void) {
        var mutableSelf = self
        update(&mutableSelf)
        self = mutableSelf
    }
}

// MARK: - Optional + BulkApplicable

// Extensions for common build-in types
extension Optional: BulkApplicable where Wrapped: BulkApplicable {}

// MARK: - String + BulkApplicable

extension String: BulkApplicable {}

// MARK: - Bool + BulkApplicable

extension Bool: BulkApplicable {}

// MARK: - Array + BulkApplicable

extension Array: BulkApplicable where Element: BulkApplicable {}
