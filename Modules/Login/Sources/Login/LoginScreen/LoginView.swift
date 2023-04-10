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
            Image(systemName: "folder")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.branding)

            Text(Localizable.folderify)
                .font(.title)
                .padding(.bottom, 24)

            TextInput(
                title: Localizable.login,
                value: adapter.binding(
                    get: { $0.login ?? "" },
                    send: Action.loginInput
                )
            ).autocapitalization(.none)

            TextInput(
                title: Localizable.password,
                isSecure: true,
                value: adapter.binding(
                    get: { $0.password ?? "" },
                    send: Action.passwordInput
                )
            )

            PrimaryButton(
                text: Localizable.login,
                state: .constant(viewState.ctaState),
                action: { send(.login) }
            ).padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .alert(isPresented: .constant(viewState.isLoginErrorVisible)) {
            Alert(
                title: Text(Localizable.loginErrorTitle),
                message: Text(Localizable.loginErrorContent),
                dismissButton: .default(Text(Localizable.loginErrorCTA), action: {
                    send(.dismissError)
                })
            )
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
