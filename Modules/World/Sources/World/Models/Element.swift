import Foundation

public struct Element: Decodable {
    public enum ContentType: String, Decodable {
        case jpg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case tiff = "image/tiff"
        case pdf = "application/pdf"
        case vnd = "application/vnd"
        case plainText = "text/plain"
        case binary = "application/octet-stream"
    }

    public typealias ID = String

    public let id: ID
    public let name: String
    public let isDirectory: Bool
    public let modificationDate: Date
    public let contentType: ContentType?

    /// Size of the element, represented in bytes
    public let size: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, modificationDate, contentType, size
        case isDirectory = "isDir"
    }
}
