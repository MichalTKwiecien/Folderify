import Architecture
import Combine
import World
import Foundation

final class FolderViewModel: ViewModel {
    enum ViewState: Equatable, BulkApplicable {
        struct Idle: Equatable {
            let root: Item
            let items: [Item.ViewState]
            var isExecutingOperation: Bool
        }

        case loading(Item)
        case idle(Idle)
        case error(Item)

        var root: Item {
            switch self {
            case .loading(let item), .error(let item): return item
            case let .idle(data): return data.root
            }
        }
    }

    enum Action {
        case fetch
        case delete
        case select(Item)
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let item: Item
    private let onSelectFolder: (Item) -> Void
    private let onPreviewURL: (URL) -> Void
    private let onDeleted: () -> Void
    private let mapper = Item.Mapper()

    init(
        item: Item,
        onSelectFolder: @escaping (Item) -> Void,
        onPreviewURL: @escaping (URL) -> Void,
        onDeleted: @escaping () -> Void
    ) {
        self.item = item
        self.onSelectFolder = onSelectFolder
        self.onPreviewURL = onPreviewURL
        self.onDeleted = onDeleted
        viewStateSubject = .init(.loading(item))
    }

    func send(_ action: Action) {
        switch action {
        case .fetch:
            fetch()
        case .delete:
            delete()
        case let .select(item):
            if item.isFolder {
                onSelectFolder(item)
            } else {
                downloadFile(for: item)
            }
        }
    }
}

private extension FolderViewModel {
    func fetch() {
        viewState = .loading(item)

        Task(priority: .userInitiated) {
            switch await Current.services.items.items(item.id) {
            case let .success(items):
                let itemViewStates = items
                    .sorted(by: { $0.modificationDate > $1.modificationDate })
                    .map { $0.toViewState(using: mapper) }
                await MainActor.run {
                    viewState = .idle(.init(root: item, items: itemViewStates, isExecutingOperation: false))
                }
            case .failure:
                await MainActor.run {
                    viewState = .error(item)
                }
            }
        }
    }

    func downloadFile(for item: Item) {
        guard case var .idle(data) = viewState else { return }
        data.isExecutingOperation = true
        viewState = .idle(data)

        Task(priority: .userInitiated) {
            let result = await Current.services.items.download(item)
            await MainActor.run {
                finishExecutingOperation()
            }
            guard case let .success(url) = result else { return }
            await MainActor.run {
                onPreviewURL(url)
            }
        }
    }

    private func delete() {
        guard case var .idle(data) = viewState else { return }
        data.isExecutingOperation = true
        viewState = .idle(data)

        let root = data.root
        Task(priority: .userInitiated) {
            switch await Current.services.items.delete(root.id) {
            case .success:
                await MainActor.run {
                    finishExecutingOperation()
                    onDeleted()
                }
            case .failure:
                await MainActor.run {
                    viewState = .error(root)
                }
            }
        }
    }

    private func finishExecutingOperation() {
        guard case var .idle(data) = viewState else { return }
        data.isExecutingOperation = true
        viewState = .idle(data)
    }
}

extension Item {
    var isDeleteAllowed: Bool { !parentID.isEmpty }
}
