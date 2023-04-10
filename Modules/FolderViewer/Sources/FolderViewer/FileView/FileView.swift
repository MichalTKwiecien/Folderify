import Architecture
import DesignSystem
import SwiftUI

struct FileView: ViewWithAdapter {
    typealias ViewState = FileViewModel.ViewState
    typealias Action = FileViewModel.Action

    let adapter: ViewModelAdapter<ViewState, Action>

    init(_ adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
    }

    func body(viewState: ViewState, send: @escaping (Action) -> Void) -> some View {
        VStack(alignment: .center) {
            Text("File screen")
        }
        .padding(.horizontal, 24)
    }
}

#if DEBUG
    struct FileView_Previews: PreviewProvider {
        static var previews: some View {
            FileView(
                .just(.init(
                    name: "File"
                ))
            )
        }
    }
#endif
