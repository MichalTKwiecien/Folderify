import Foundation

public struct Request<Response: Decodable> {
    public let endpoint: Endpoint
    public let headers: [Header]
    public let body: Data?
    public let cachePolicy: URLRequest.CachePolicy
    public let timeoutInterval: TimeInterval

    public init(
        endpoint: Endpoint,
        headers: [Header] = [],
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 20
    ) {
        self.endpoint = endpoint
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
}
