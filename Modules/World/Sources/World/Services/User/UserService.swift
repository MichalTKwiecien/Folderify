import Combine
import Foundation
import Networking

final class UserService {
    private let client: HTTPClient = httpApiClient

    func me(login: String, password: String) -> AnyPublisher<User, NetworkingError> {
        let authorization = Authorization.basic(login: login, password: password)
        let request = Request<User>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/me")),
                method: .get
            ),
            headers: [authorization.asHeader]
        )

        return client.send(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
