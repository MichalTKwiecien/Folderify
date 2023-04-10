import Foundation

public struct Element: Decodable, Equatable {
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

#if DEBUG
    public extension Element {
        static let mockDirectory = Element(
            id: "directory-1",
            name: "Directory 1",
            isDirectory: true,
            modificationDate: Date.init(timeIntervalSince1970: 1680343200),
            contentType: nil,
            size: nil
        )

        static let mockFile1 = Element(
            id: "file-1",
            name: "File 1",
            isDirectory: false,
            modificationDate: Date.init(timeIntervalSince1970: 1680343200),
            contentType: .jpg,
            size: 500000
        )

        static let mockFile2 = Element(
            id: "file-2",
            name: "File 2",
            isDirectory: false,
            modificationDate: Date.init(timeIntervalSince1970: 1580343200),
            contentType: .png,
            size: 120400
        )
    }
#endif
