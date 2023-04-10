import Foundation

public struct Header {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public static let contentTypeJSON = Header(key: "Content-Type", value: "application/json")
    public static let contentTypeStream = Header(key: "Content-Type", value: "application/octet-stream")
}

extension URLRequest {
    mutating func append(headers: [Header]) {
        headers.forEach {
            append(header: $0)
        }
    }

    mutating func append(header: Header) {
        setValue(header.value, forHTTPHeaderField: header.key)
    }
}
