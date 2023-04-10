import Foundation

public final class DefaultHTTPClient: HTTPClient {
    private let baseURL: URL
    private var authorization: Authorization?

    fileprivate static let queue = DispatchQueue(label: "Networking.Session", qos: .userInitiated)
    fileprivate static let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let session = URLSession(configuration: .default)
    private let networkTrafficLogger: Networking.Logger?

    public init(baseURL: URL, authorization: Authorization? = nil, networkTrafficLogger: Networking.Logger? = nil) {
        self.baseURL = baseURL
        self.authorization = authorization
        self.networkTrafficLogger = networkTrafficLogger
    }

    public func set(authorization: Authorization) {
        self.authorization = authorization
    }

    public func send<ResponseType>(
        request: Request<ResponseType>
    ) async -> Result<Response<ResponseType>, NetworkingError> where ResponseType: Decodable {
        let request = prepare(request: request)
        networkTrafficLogger?(request.contents())
        do {
            let (data, response) = try await session.data(for: request)
            networkTrafficLogger?(response.contents(of: data))
            try validate(data: data, response: response)
            let decoded = try decode(data: data, response: response, type: ResponseType.self)
            return .success(decoded)
        } catch {
            return .failure(customized(error: error))
        }
    }

    private func prepare<Response>(request: Request<Response>) -> URLRequest {
        let url: URL
        switch request.endpoint.url {
        case let .relative(path):
            url = baseURL.appendingPathComponent(path.absoluteString)
        case let .full(fullURL):
            url = fullURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.endpoint.method.rawValue
        urlRequest.append(headers: request.headers)
        if let authorization {
            urlRequest.append(header: authorization.asHeader)
        }
        if let body = request.body {
            urlRequest.httpBody = body
        }
        return urlRequest
    }

    private func decode<T: Decodable>(data: Data, response: URLResponse, type: T.Type) throws -> Response<T> {
        guard
            let response = response as? HTTPURLResponse,
            let httpStatusCode = response.httpStatusCode
        else {
            throw NetworkingError.unknown
        }

        do {
            if Data.self == T.self {
                return Response(statusCode: httpStatusCode, value: data as! T)
            } else if EmptyResponse.self == T.self {
                return Response(statusCode: httpStatusCode, value: EmptyResponse() as! T)
            } else {
                let decoded = try DefaultHTTPClient.jsonDecoder.decode(T.self, from: data)
                return Response(statusCode: httpStatusCode, value: decoded)
            }
        } catch {
            guard let error = error as? DecodingError else {
                throw NetworkingError.other(error)
            }
            throw NetworkingError.decoding(error)
        }
    }

    private func validate(data: Data, response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse, let statusCode = response.httpStatusCode else {
            throw NetworkingError.unknown
        }
        guard statusCode.responseType == .success else {
            throw NetworkingError.statusCode(statusCode, data)
        }
    }

    private func customized(error: Error) -> NetworkingError {
        if let error = error as? URLError {
            return NetworkingError.network(error)
        } else if let error = error as? NetworkingError {
            return error
        } else {
            return .unknown
        }
    }
}
