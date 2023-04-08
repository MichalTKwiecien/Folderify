import Combine
import SwiftUI

public struct WithObservableViewModel<ViewState: Equatable & BulkApplicable, Action, Content: View>: View {
    @ObservedObject private var observableViewModel: ObservableViewModel<ViewState, Action>

    private let content: (ViewState, @escaping (Action) -> Void) -> Content

    public init(_ adapter: ViewModelAdapter<ViewState, Action>, @ViewBuilder content: @escaping (ViewState, @escaping (Action) -> Void) -> Content) {
        observableViewModel = ObservableViewModel(adapter: adapter)
        self.content = content
    }

    public var body: some View {
        content(observableViewModel.viewState, observableViewModel.send)
    }
}
