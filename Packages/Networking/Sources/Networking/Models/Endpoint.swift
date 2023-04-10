import Foundation

public struct Endpoint {
    public enum TargetURL {
        case full(URL)
        case relative(URL)
    }

    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }

    public let url: TargetURL
    public let method: Method

    public init(url: TargetURL, method: Method) {
        self.url = url
        self.method = method
    }
}
