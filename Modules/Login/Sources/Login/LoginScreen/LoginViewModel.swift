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
        case dismissError
    }

    let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let onSuccessfulLogin: () -> Void

    init(
        onSuccessfulLogin: @escaping () -> Void
    ) {
        self.onSuccessfulLogin = onSuccessfulLogin
        viewStateSubject = .init(.init())
    }

    func send(_ action: Action) {
        switch action {
        case let .loginInput(value):
            viewState.apply {
                $0.login = value
                $0.validateCTAState()
            }
        case let .passwordInput(value):
            viewState.apply {
                $0.password = value
                $0.validateCTAState()
            }
        case .login:
            guard let login = viewState.login, let password = viewState.password else { return }
            logIn(login: login, password: password)
        case .dismissError:
            viewState.isLoginErrorVisible = false
        }
    }

    private func logIn(login: String, password: String) {
        viewState.ctaState = .loading
        
        // TODO: Add logic
//        viewState.apply {
//            $0.ctaState = .interactive
//            $0.isLoginErrorVisible = true
//        }
        onSuccessfulLogin()
    }
}

private extension LoginViewModel.ViewState {
    mutating func validateCTAState() {
        let isInteractice = login?.isEmpty == false && password?.isEmpty == false
        ctaState = isInteractice ? .interactive : .disabled
    }
}
