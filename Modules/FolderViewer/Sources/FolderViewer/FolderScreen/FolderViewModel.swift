import Architecture
import Combine
import World
import Foundation

final class FolderViewModel: ViewModel {
    enum ViewState: Equatable, BulkApplicable {
        struct Idle: Equatable {
            let root: Element
            let items: [Element]
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
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let element: Element
    private let onBack: () -> Void

    init(
        element: Element,
        onBack: @escaping () -> Void
    ) {
        self.element = element
        self.onBack = onBack
        viewStateSubject = .init(.loading(element))
    }

    func send(_ action: Action) {
        switch action {
        case .back:
            onBack()
        case .fetch:
            fetch()
        }
    }
}

private extension FolderViewModel {
    func fetch() {
        viewState = .loading(element)

        // TODO: Add fetching mechanism
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.viewState = .idle(.init(root: self.element, items: [.mockDirectory, .mockFile1, .mockFile2]))
        }
    }
}
