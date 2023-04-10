import Architecture
import Combine
import World
import Foundation

final class FolderViewModel: ViewModel {
    enum ViewState: Equatable, BulkApplicable {
        struct Idle: Equatable {
            let root: Item
            let items: [Item.ViewState]
        }

        case loading(Item)
        case idle(Idle)
        case error(Item)

        var title: String {
            switch self {
            case .loading(let element), .error(let element): return element.name
            case let .idle(data): return data.root.name
            }
        }
    }

    enum Action {
        case back
        case fetch
        case select(Item)
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let item: Item
    private let onSelect: (Item) -> Void
    private let onBack: () -> Void
    private let mapper = Item.Mapper()

    init(
        item: Item,
        onSelect: @escaping (Item) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.item = item
        self.onSelect = onSelect
        self.onBack = onBack
        viewStateSubject = .init(.loading(item))
    }

    func send(_ action: Action) {
        switch action {
        case .back:
            onBack()
        case .fetch:
            fetch()
        case let .select(element):
            onSelect(element)
        }
    }
}

private extension FolderViewModel {
    func fetch() {
        viewState = .loading(item)

        // TODO: Add fetching mechanism
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let elements: [Item] = [.mockDirectory, .mockFile1, .mockFile2]
            let viewStateElements = elements
                .sorted(by: { $0.modificationDate > $1.modificationDate })
                .map { $0.toViewState(using: self.mapper) }
            self.viewState = .idle(.init(root: self.item, items: viewStateElements))
        }
    }
}
