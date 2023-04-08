import Architecture
import Combine
import DesignSystem

final class LoginViewModel: ViewModel {
    struct ViewState: Equatable, BulkApplicable {
        var login: String?
        var password: String?
        var ctaState = ButtonState.disabled
        var isLoginErrorVisible = false
    }

    enum Action {
        case loginInput(String)
        case passwordInput(String)
        case login
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let onSuccessfulLogin: () -> Void
    private var cancellables = Set<AnyCancellable>()

    init(
        onSuccessfulLogin: @escaping () -> Void
    ) {
        self.onSuccessfulLogin = onSuccessfulLogin
        viewStateSubject = .init(.init())
    }

    func send(_ action: Action) {
        switch action {
        case let .loginInput(value):
            viewState.login = value
            validateCTAState()
        case let .passwordInput(value):
            viewState.password = value
            validateCTAState()
        case .login:
            guard let login = viewState.login, let password = viewState.password else { return }
            logIn(login: login, password: password)
        }
    }

    private func validateCTAState() {
        let isInteractice = viewState.login?.isEmpty == false
            && viewState.password?.isEmpty == false
        viewState.ctaState = isInteractice ? .interactive : .disabled
    }

    private func logIn(login: String, password: String) {
        viewState.ctaState = .loading
        
        // TODO: Add logic
        viewState.apply {
            $0.ctaState = .interactive
            $0.isLoginErrorVisible = true
        }
    }
}
