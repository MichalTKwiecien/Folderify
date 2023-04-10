import Combine
import Foundation
import Networking

final class UserService {
    private let client: HTTPClient = httpApiClient

    func login(login: String, password: String) async -> Result<User, NetworkingError> {
        let authorization = Authorization.basic(login: login, password: password)
        let request = Request<User>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/me")),
                method: .get
            ),
            headers: [authorization.asHeader],
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        let result = await client.send(request: request).map(\.value)

        // If request was successfull, we're setting this authorization method as default for networking
        if case .success = result {
            client.set(authorization: authorization)
        }
        return result
    }
}
