import Architecture
import Combine
import DesignSystem
import World

final class CreateFolderViewModel: ViewModel {
    struct ViewState: Equatable, BulkApplicable {
        var name: String?
        var ctaState = ButtonState.disabled
        var isErrorVisible = false
    }

    enum Action {
        case nameInput(String)
        case create
        case dismissError
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let parentID: Item.ID
    private let onSuccessfulCreation: () -> Void

    init(
        parentID: Item.ID,
        onSuccessfulCreation: @escaping () -> Void
    ) {
        self.parentID = parentID
        self.onSuccessfulCreation = onSuccessfulCreation
        viewStateSubject = .init(.init())
    }

    func send(_ action: Action) {
        switch action {
        case let .nameInput(value):
            viewState.apply {
                $0.name = value
                $0.validateCTAState()
            }
        case .create:
            guard let name = viewState.name else { return }
            create(with: name, in: parentID)
        case .dismissError:
            viewState.isErrorVisible = false
        }
    }

    private func create(with name: String, in parent: Item.ID) {
        viewState.ctaState = .loading

        Task(priority: .userInitiated) {
            switch await Current.services.items.createFolder((name, parent)) {
            case .success:
                await MainActor.run {
                    viewState.ctaState = .interactive
                    onSuccessfulCreation()
                }
            case .failure:
                await MainActor.run {
                    viewState.apply {
                        $0.ctaState = .interactive
                        $0.isErrorVisible = true
                    }
                }
            }
        }
    }
}

private extension CreateFolderViewModel.ViewState {
    mutating func validateCTAState() {
        guard let name else {
            ctaState = .disabled
            return
        }

        let startsWithDot = name.first == "."
        let disallowedCharacters = ["/", "\\", ":"]
        let doesNotContainDisallowedCharacters = disallowedCharacters.allSatisfy { !name.contains($0) }
        let isInteractice = !startsWithDot && doesNotContainDisallowedCharacters && !name.isEmpty
        ctaState = isInteractice ? .interactive : .disabled
    }
}
