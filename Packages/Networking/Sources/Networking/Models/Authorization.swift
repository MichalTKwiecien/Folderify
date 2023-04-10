public enum Authorization {
    case basic(login: String, password: String)

    public var asHeader: Header {
        switch self {
        case let .basic(login, password):
            let authData = (login + ":" + password).data(using: .utf8)?.base64EncodedString() ?? ""
            return Header(key: "Authorization", value: "Basic \(authData)")
        }
    }
}
