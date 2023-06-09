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
        .navigationTitle(viewState.root.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { send(.createFolder) }) {
                    Image(systemName: "folder.badge.plus").foregroundColor(.branding)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewState.root.isDeleteAllowed {
                    Button(action: { send(.delete) }) {
                        Image(systemName: "trash").foregroundColor(.danger)
                    }
                }
            }
        }
        .onAppear { send(.fetch) }
    }

    @ViewBuilder
    func idle(viewState: ViewState.Idle, send: @escaping (Action) -> Void) -> some View {
        ZStack(alignment: .center) {
            if viewState.items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "eye.slash.fill").foregroundColor(.branding)
                    Text(Localizable.folderViewEmpty).font(.title3)
                    Button(action: { send(.uploadFile) }) {
                        HStack {
                            Image(systemName: "plus.rectangle.fill.on.rectangle.fill").foregroundColor(.branding)

                            Text(Localizable.folderUploadFileCTA)
                                .foregroundColor(.branding)
                        }
                    }.padding(.top, 32)
                }
            } else {
                List {
                    Button(action: { send(.uploadFile) }) {
                        HStack {
                            Image(systemName: "plus.rectangle.fill.on.rectangle.fill").foregroundColor(.branding)

                            Text(Localizable.folderUploadFileCTA)
                                .foregroundColor(.branding)
                        }
                    }
                    ForEach(viewState.items) { item in
                        Button(action: { send(.select(item.raw)) }) {
                            HStack(alignment: .center, spacing: 16) {
                                switch item.kind {
                                case .directory:
                                    Image(systemName: "folder")
                                        .foregroundColor(.branding)
                                        .frame(width: 24, height: 24)
                                case .file:
                                    Image(systemName: "doc")
                                        .foregroundColor(.branding)
                                        .frame(width: 24, height: 24)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .foregroundColor(.dark)
                                    if let size = item.size {
                                        Text(size)
                                            .font(.caption)
                                            .foregroundColor(.branding)
                                    }
                                }

                                Spacer()
                                if let modificationDate = item.modificationDate {
                                    Text(modificationDate)
                                        .font(.caption)
                                        .foregroundColor(.dark)
                                }
                                if item.kind == .directory {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.branding)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .disabled(viewState.isExecutingOperation)
            }

            if viewState.isExecutingOperation {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }
        }
    }

    func loading(viewState: Item, send: @escaping (Action) -> Void) -> some View {
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
            Text(Localizable.folderViewErrorTitle)
                .font(.title)
            SecondaryButton(
                text: Localizable.folderViewErrorCTA,
                state: .constant(.interactive),
                action: { send(.fetch) }
            ).padding(.top, 32)
        }.padding(.horizontal, 24)
    }
}

#if DEBUG
    struct FolderView_Previews: PreviewProvider {
        static var previews: some View {
            FolderView(
                .just(.idle(.init(
                    root: .mockDirectory,
                    items: [Item.mockDirectory, .mockFile1, .mockFile1]
                        .map { $0.toViewState(using: .init()) },
                    isExecutingOperation: false
                )))
            )
            .previewDisplayName("Idle")

            FolderView(
                .just(.idle(.init(
                    root: .mockDirectory,
                    items: [Item.mockDirectory, .mockFile1, .mockFile1]
                        .map { $0.toViewState(using: .init()) },
                    isExecutingOperation: false
                )))
            )
            .previewDisplayName("Idle - downloading file")

            FolderView(
                .just(.idle(.init(
                    root: .mockDirectory,
                    items: [],
                    isExecutingOperation: false
                )))
            )
            .previewDisplayName("Idle - empty")

            FolderView(
                .just(.loading(.mockDirectory))
            ).previewDisplayName("Loading")

            FolderView(
                .just(.error(.mockDirectory))
            ).previewDisplayName("Error")
        }
    }
#endif
