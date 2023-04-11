import Architecture
import DesignSystem
import SwiftUI

struct CreateFolderView: ViewWithAdapter {
    typealias ViewState = CreateFolderViewModel.ViewState
    typealias Action = CreateFolderViewModel.Action

    let adapter: ViewModelAdapter<ViewState, Action>

    init(_ adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
    }

    func body(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center) {
            Image(systemName: "folder.badge.plus")
                .resizable()
                .frame(width: 48, height: 38)
                .foregroundColor(.branding)


            Text(Localizable.createFolderTitle)
                .font(.title2)
                .padding(.bottom, 24)

            TextInput(
                title: Localizable.createFolderNamePlaceholder,
                value: adapter.binding(
                    get: { $0.name ?? "" },
                    send: Action.nameInput
                )
            ).autocapitalization(.none)

            PrimaryButton(
                text: Localizable.createFolderCTA,
                state: .constant(viewState.ctaState),
                action: { send(.create) }
            ).padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .alert(isPresented: .constant(viewState.isErrorVisible)) {
            Alert(
                title: Text(Localizable.createFolderErrorTitle),
                message: Text(Localizable.createFolderErrorContent),
                dismissButton: .default(Text(Localizable.createFolderErrorCTA), action: {
                    send(.dismissError)
                })
            )
        }
    }
}

#if DEBUG
    struct CreateFolderView_Previews: PreviewProvider {
        static var previews: some View {
            CreateFolderView(
                .just(.init(
                    name: nil,
                    ctaState: .disabled,
                    isErrorVisible: false
                ))
            )
            .previewDisplayName("Empty")

            CreateFolderView(
                .just(.init(
                    name: "Folder name",
                    ctaState: .interactive,
                    isErrorVisible: false
                ))
            )
            .previewDisplayName("Fully filled")

            CreateFolderView(
                .just(.init(
                    name: "Folder name",
                    ctaState: .loading,
                    isErrorVisible: false
                ))
            )
            .previewDisplayName("Fully filled - loading")

            CreateFolderView(
                .just(.init(
                    name: "Folder name",
                    ctaState: .interactive,
                    isErrorVisible: true
                ))
            )
            .previewDisplayName("Fully filled - error")
        }
    }
#endif
