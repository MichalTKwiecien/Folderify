import Combine
import SwiftUI

public final class ObservableViewModel<ViewState: Equatable & BulkApplicable, Action>: ObservableObject {
    public var viewState: ViewState {
        viewStatePublisher
    }

    @Published private var viewStatePublisher: ViewState

    private let adapter: ViewModelAdapter<ViewState, Action>
    private var cancellables = Set<AnyCancellable>()

    public init(adapter: ViewModelAdapter<ViewState, Action>) {
        self.adapter = adapter
        viewStatePublisher = adapter.stateSubject.value
        adapter
            .stateSubject
            .assignNoRetain(to: \.viewStatePublisher, on: self)
            .store(in: &cancellables)
    }

    public func send(_ action: Action) {
        adapter.send(action)
    }
}
