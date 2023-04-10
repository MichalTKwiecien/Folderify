import Architecture
import Combine
import World
import Foundation

final class FolderViewModel: ViewModel {
    enum ViewState: Equatable, BulkApplicable {
        struct Idle: Equatable {
            let root: Element
            let items: [Element.ViewState]
        }

        case loading(Element)
        case idle(Idle)
        case error(Element)

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
        case select(Element)
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let element: Element
    private let onSelect: (Element) -> Void
    private let onBack: () -> Void
    private let mapper = Element.Mapper()

    init(
        element: Element,
        onSelect: @escaping (Element) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.element = element
        self.onSelect = onSelect
        self.onBack = onBack
        viewStateSubject = .init(.loading(element))
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
        viewState = .loading(element)

        // TODO: Add fetching mechanism
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let elements: [Element] = [.mockDirectory, .mockFile1, .mockFile2]
            let viewStateElements = elements
                .sorted(by: { $0.modificationDate > $1.modificationDate })
                .map { $0.toViewState(using: self.mapper) }
            self.viewState = .idle(.init(root: self.element, items: viewStateElements))
        }
    }
}
