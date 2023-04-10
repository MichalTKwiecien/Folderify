import Architecture
import Combine
import DesignSystem

final class FolderViewModel: ViewModel {
    struct ViewState: Equatable, BulkApplicable {
        let name: String
    }

    enum Action {
        case back
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let onBack: () -> Void

    init(
        onBack: @escaping () -> Void
    ) {
        self.onBack = onBack
        viewStateSubject = .init(.init(name: "test"))
    }

    func send(_ action: Action) {
        switch action {
        case .back:
            onBack()
        }
    }
}
