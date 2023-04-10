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

    func download(item: Item) async -> Result<URL, NetworkingError> {
        let request = Request<Data>(
            endpoint: Endpoint(
                url: .relative(URL(safe: "/items/\(item.id)/data")),
                method: .get
            )
        )

        switch await client.download(request: request) {
        case let .success(url):
            do {
                let documentsDirectoryURL = FileManager.default.temporaryDirectory
                let previewURL = documentsDirectoryURL.appendingPathComponent(item.name)
                if FileManager.default.fileExists(atPath: previewURL.path) {
                    try FileManager.default.removeItem(at: previewURL)
                }
                try FileManager.default.moveItem(at: url, to: previewURL)
                return .success(previewURL)
            } catch {
                return .failure(.decoding(.dataCorrupted(.init(codingPath: [], debugDescription: ""))))
            }
        case let .failure(error):
            return .failure(error)
        }
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
