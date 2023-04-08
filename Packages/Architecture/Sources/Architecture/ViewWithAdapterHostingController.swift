import SwiftUI

public final class ViewWithAdapterHostingController<V: ViewWithAdapter, VM>: UIHostingController<V> {
    let viewModel: VM

    public init(viewModel: VM, _ mapping: (VM) -> ViewModelAdapter<V.ViewState, V.Action>) {
        self.viewModel = viewModel
        let rootView = V(mapping(viewModel))
        super.init(rootView: rootView)
    }

    public convenience init(viewModel: VM) where VM: ViewModel, VM.ViewState == V.ViewState, VM.Action == V.Action {
        self.init(viewModel: viewModel, \.adapter)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
