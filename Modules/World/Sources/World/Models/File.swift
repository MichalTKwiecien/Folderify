import Foundation

public struct File {
    public let name: String
    public let url: URL

    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
