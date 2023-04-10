import Combine
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
    ) -> AnyPublisher<Response<ResponseType>, NetworkingError> where ResponseType: Decodable {
        Deferred { [unowned self] in
            prepare(request: request, baseURL: baseURL, authorization: authorization)
                .logRequest(with: networkTrafficLogger)
                .flatMap(session.dataTaskPublisher)
                .timeout(.seconds(request.timeoutInterval), scheduler: Self.queue)
                .logResponse(with: networkTrafficLogger)
                .validate()
                .decode(type: ResponseType.self)
                .customizeError()
                .first()
        }.eraseToAnyPublisher()
    }

    private func prepare<Response>(
        request: Request<Response>,
        baseURL: URL,
        authorization: Authorization?
    ) -> Just<URLRequest> {
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
        return Just(urlRequest)
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func validate() -> Publishers.TryMap<Self, Output> {
        tryMap { data, response in
            guard let response = response as? HTTPURLResponse, let statusCode = response.httpStatusCode else {
                throw NetworkingError.unknown
            }
            guard statusCode.responseType == .success else {
                throw NetworkingError.statusCode(statusCode, data)
            }
            return (data, response)
        }
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func decode<T: Decodable>(type: T.Type) -> Publishers.TryMap<Self, Response<T>> {
        tryMap { data, response in
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
    }
}

private extension Publisher {
    func customizeError() -> Publishers.MapError<Self, NetworkingError> {
        mapError {
            if let error = $0 as? URLError {
                return NetworkingError.network(error)
            } else if let error = $0 as? NetworkingError {
                return error
            } else {
                return .unknown
            }
        }
    }
}
