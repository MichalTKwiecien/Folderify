import Foundation

public enum NetworkingError: Error, Equatable {
    case network(URLError)
    case decoding(DecodingError)
    case statusCode(HTTPStatusCode, Data)
    case other(Error)
    case unknown

    public static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {
        case let (.network(lhsError), .network(rhsError)):
            return lhsError == rhsError
        case let (.decoding(lhsError), .decoding(rhsError)):
            return lhsError.failureReason == rhsError.failureReason
        case let (.statusCode(lhsError, _), .statusCode(rhsError, _)):
            return lhsError == rhsError
        case let (.other(lhsError), .other(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
