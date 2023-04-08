import Architecture
import DesignSystem
import SwiftUI

struct LoginView: ViewWithAdapter {
    typealias ViewState = LoginViewModel.ViewState
    typealias Action = LoginViewModel.Action

    let adapter: ViewModelAdapter<ViewState, Action>

    init(_ adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
    }

    func body(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center) {
            TextField(
                "Login",
                text: adapter.binding(
                    get: { $0.login ?? "" },
                    send: Action.loginInput
                )
            )
            TextField(
                "Password",
                text: adapter.binding(
                    get: { $0.password ?? "" },
                    send: Action.passwordInput
                )
            )

            Button("Login", action: { send(.login) })
        }
    }
}

#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(
                .just(.init(
                    login: nil,
                    password: nil,
                    ctaState: .disabled,
                    isLoginErrorVisible: false
                ))
            )
            .previewDisplayName("Empty")

            LoginView(
                .just(.init(
                    login: "login",
                    password: nil,
                    ctaState: .disabled,
                    isLoginErrorVisible: false
                ))
            )
            .previewDisplayName("Partialy filled")

            LoginView(
                .just(.init(
                    login: "login",
                    password: "password",
                    ctaState: .interactive,
                    isLoginErrorVisible: false
                ))
            )
            .previewDisplayName("Fully filled")

            LoginView(
                .just(.init(
                    login: "login",
                    password: "password",
                    ctaState: .loading,
                    isLoginErrorVisible: false
                ))
            )
            .previewDisplayName("Fully filled - loading")

            LoginView(
                .just(.init(
                    login: "login",
                    password: "password",
                    ctaState: .interactive,
                    isLoginErrorVisible: true
                ))
            )
            .previewDisplayName("Fully filled - error")
        }
    }
#endif
