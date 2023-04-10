import Architecture
import DesignSystem
import SwiftUI

struct FolderView: ViewWithAdapter {
    typealias ViewState = FolderViewModel.ViewState
    typealias Action = FolderViewModel.Action

    let adapter: ViewModelAdapter<ViewState, Action>

    init(_ adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
    }

    func body(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center) {
            Text("Folder screen")
        }
        .padding(.horizontal, 24)
    }
}

#if DEBUG
    struct FolderView_Previews: PreviewProvider {
        static var previews: some View {
            FolderView(
                .just(.init(
                    name: "Documents"
                ))
            )
        }
    }
#endif
