public struct User: Decodable {
    public let firstName: String
    public let lastName: String
    public let root: Element

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case root = "rootItem"
    }
}
