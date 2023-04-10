@dynamicMemberLookup
public struct Response<T: Decodable> {
    public let statusCode: HTTPStatusCode
    public let value: T

    public subscript<N>(dynamicMember keyPath: KeyPath<T, N>) -> N {
        value[keyPath: keyPath]
    }
}

public struct EmptyResponse: Decodable {
    public static let mock = EmptyResponse()
}
