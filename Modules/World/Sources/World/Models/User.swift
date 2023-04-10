public struct User: Decodable {
    public let root: Item

    enum CodingKeys: String, CodingKey {
        case root = "rootItem"
    }
}

#if DEBUG
    public extension User {
        static let mock = User(
            root: .mockDirectory
        )
    }
#endif
