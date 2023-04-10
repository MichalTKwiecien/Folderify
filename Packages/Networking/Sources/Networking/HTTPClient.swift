import Combine
import Foundation

public protocol HTTPClient {
    func set(authorization: Authorization)
    func send<ResponseType>(request: Request<ResponseType>) async -> Result<Response<ResponseType>, NetworkingError>
}
