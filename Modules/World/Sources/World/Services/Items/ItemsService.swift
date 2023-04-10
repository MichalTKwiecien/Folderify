import Combine
import Foundation
import Networking

final class ItemsService {
    private let client: HTTPClient = httpApiClient
    private let bodyEncoder = JSONEncoder()

    func items(id: Item.ID) async -> Result<[Item], NetworkingError> {
        let request = Request<[Item]>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)")),
                method: .get
            )
        )

        return await client.send(request: request).map(\.value)
    }

    func delete(id: Item.ID) async -> Result<EmptyResponse, NetworkingError> {
        let request = Request<EmptyResponse>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)")),
                method: .delete
            )
        )

        return await client.send(request: request).map(\.value)
    }

    func data(id: Item.ID) async -> Result<Data, NetworkingError> {
        let request = Request<Data>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(id)/data")),
                method: .get
            )
        )

        return await client.send(request: request).map(\.value)
    }

    func create(folder: String, in root: Item.ID) async -> Result<[Item], NetworkingError> {
        struct Body: Encodable {
            let name: String
        }

        let request = Request<[Item]>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(root)")),
                method: .post
            ),
            headers: [.contentTypeJSON],
            body: try? bodyEncoder.encode(Body(name: folder))
        )

        return await client.send(request: request).map(\.value)
    }

    func upload(file: File, in root: Item.ID) async -> Result<[Item], NetworkingError> {
        let request = Request<[Item]>(
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

        return await client.send(request: request).map(\.value)
    }
}
