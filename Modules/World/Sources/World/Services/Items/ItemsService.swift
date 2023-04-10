//@AnyPublisherClosure var items = itemsService.items
//@AnyPublisherClosure var delete = itemsService.delete
//@AnyPublisherClosure var data = itemsService.details
//@AnyPublisherClosure var createFolder = itemsService.createFolder
//@AnyPublisherClosure var uploadFile = itemsService.uploadFile

import Combine
import Foundation
import Networking

final class ItemsService {
    private let client: HTTPClient = httpApiClient
    private let bodyEncoder = JSONEncoder()

    func items(id: Element.ID) -> AnyPublisher<[Element], NetworkingError> {
        let request = Request<[Element]>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)")),
                method: .get
            )
        )

        return client.send(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func delete(id: Element.ID) -> AnyPublisher<Never, NetworkingError> {
        let request = Request<EmptyResponse>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)")),
                method: .delete
            )
        )

        return client.send(request: request)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func data(id: Element.ID) -> AnyPublisher<Data, NetworkingError> {
        let request = Request<Data>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)/data")),
                method: .get
            )
        )

        return client.send(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func create(folder: String, in root: Element.ID) -> AnyPublisher<[Element], NetworkingError> {
        struct Body: Encodable {
            let name: String
        }

        let request = Request<[Element]>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(root)")),
                method: .post
            ),
            headers: [.contentTypeJSON],
            body: try? bodyEncoder.encode(Body(name: folder))
        )

        return client.send(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func upload(file: File, in root: Element.ID) -> AnyPublisher<[Element], NetworkingError> {
        let request = Request<[Element]>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(root)")),
                method: .post
            ),
            headers: [
                .contentTypeStream,
                .init(key: "Content-Disposition", value: "attachment;filename*=utf-8''\(file.name)")
            ],
            body: file.data
        )

        return client.send(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
