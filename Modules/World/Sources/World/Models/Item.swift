import Foundation

public struct Item: Decodable, Equatable {
    public typealias ID = String

    public let id: ID
    public let name: String
    public let isFolder: Bool
    public let modificationDate: Date
    public let parentID: ID

    /// Size of the element, represented in bytes
    public let size: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, modificationDate, size
        case isFolder = "isDir"
        case parentID = "parentId"
    }
}

#if DEBUG
    public extension Item {
        static let mockDirectory = Item(
            id: "directory-1",
            name: "Directory 1",
            isFolder: true,
            modificationDate: Date(timeIntervalSince1970: 1680343200),
            parentID: "directory-0",
            size: nil
        )

        static let mockFile1 = Item(
            id: "file-1",
            name: "File 1",
            isFolder: false,
            modificationDate: Date(timeIntervalSince1970: 1580343200),
            parentID: "directory-0",
            size: 500000
        )

        static let mockFile2 = Item(
            id: "file-2",
            name: "File 2",
            isFolder: false,
            modificationDate: Date(timeIntervalSince1970: 1480343200),
            parentID: "directory-0",
            size: 120400
        )
    }

    public extension Array where Element == Item {
        static let mock: [Item] = [.mockDirectory, .mockFile1, .mockFile2]
    }
#endif
