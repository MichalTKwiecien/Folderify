import SwiftUI

public protocol ViewWithAdapter: View {
    associatedtype ViewState: Equatable, BulkApplicable
    associatedtype Action
    // In the implementation, Content should be replaced with some View in the method.
    // This way there is no need to specify Content and we can skip boilerplate:
    //    var body: some View {
    //        WithObservableViewModel(adapter, content: body)
    //    }
    // It's the same operation which is made for SwiftUI.View's body.
    associatedtype Content: View

    var adapter: ViewModelAdapter<ViewState, Action> { get }

    init(_ adapter: ViewModelAdapter<ViewState, Action>)

    @ViewBuilder func body(viewState: ViewState, send: @escaping (Action) -> Void) -> Content
}

public extension ViewWithAdapter {
    var body: some View {
        WithObservableViewModel(adapter, content: body)
    }
}
