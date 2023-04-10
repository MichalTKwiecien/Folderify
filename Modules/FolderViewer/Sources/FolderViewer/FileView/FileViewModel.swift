import Architecture
import Combine
import DesignSystem

final class FileViewModel: ViewModel {
    struct ViewState: Equatable, BulkApplicable {
        let name: String
    }

    enum Action {
        case dismiss
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let onDismiss: () -> Void

    init(
        onDismiss: @escaping () -> Void
    ) {
        self.onDismiss = onDismiss
        viewStateSubject = .init(.init(name: "test"))
    }

    func send(_ action: Action) {
        switch action {
        case .dismiss:
            onDismiss()
        }
    }
}
