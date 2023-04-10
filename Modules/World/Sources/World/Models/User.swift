public struct User: Decodable {
    public let firstName: String
    public let lastName: String
    public let root: Item

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case root = "rootItem"
    }
}

#if DEBUG
    public extension User {
        static let mock = User(
            firstName: "John",
            lastName: "Doe",
            root: .mockDirectory
        )
    }
#endif
