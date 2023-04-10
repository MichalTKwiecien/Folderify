import Architecture
import DesignSystem
import SwiftUI
import World

struct FolderView: ViewWithAdapter {
    typealias ViewState = FolderViewModel.ViewState
    typealias Action = FolderViewModel.Action

    let adapter: ViewModelAdapter<ViewState, Action>

    init(_ adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
    }

    func body(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        Group {
            switch viewState {
            case let .loading(element):
                loading(viewState: element, send: send)
            case .error:
                error(viewState: viewState, send: send)
            case let .idle(data):
                idle(viewState: data, send: send)
            }
        }
        .navigationTitle(viewState.title)
        .padding(.horizontal, 24)
        .onAppear { send(.fetch) }
    }

    func idle(viewState: ViewState.Idle, send: @escaping (Action) -> Void) -> some View {
        Text("Idle")
    }

    func loading(viewState: Element, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center) {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }

    func error(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.branding)
            Text("Error")
                .font(.title)
            SecondaryButton(
                text: "Try again",
                state: .constant(.interactive),
                action: { send(.fetch) }
            ).padding(.top, 32)
        }
    }
}

#if DEBUG
    struct FolderView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                FolderView(
                    .just(.idle(.init(root: .mockDirectory, items: [.mockDirectory, .mockFile1, .mockFile2])))
                )
            }
            .previewDisplayName("Idle")

            FolderView(
                .just(.loading(.mockDirectory))
            ).previewDisplayName("Loading")

            FolderView(
                .just(.error(.mockDirectory))
            ).previewDisplayName("Error")
        }
    }
#endif
