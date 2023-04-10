import Combine
import Foundation

public protocol HTTPClient {
    func set(authorization: Authorization)
    func send<ResponseType>(request: Request<ResponseType>) async -> Result<Response<ResponseType>, NetworkingError>
    func download<ResponseType>(request: Request<ResponseType>) async -> Result<URL, NetworkingError>
    func upload<ResponseType>(request: Request<ResponseType>, file: URL) async -> Result<Response<ResponseType>, NetworkingError>
}
