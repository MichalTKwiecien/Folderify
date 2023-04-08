import Combine

public protocol ViewModel: AnyObject {
    associatedtype ViewState: Equatable, BulkApplicable = EmptyViewState
    associatedtype Action

    var adapter: ViewModelAdapter<ViewState, Action> { get }
    var viewStateSubject: CurrentValueSubject<ViewState, Never> { get }

    func send(_ action: Action)
}

public extension ViewModel {
    var adapter: ViewModelAdapter<ViewState, Action> {
        .init(
            initialViewState: viewStateSubject.value,
            statePublisher: viewStateSubject.eraseToAnyPublisher(),
            send: { [weak self] action in
                self?.send(action)
            }
        )
    }

    var viewState: ViewState {
        get {
            viewStateSubject.value
        }
        set {
            viewStateSubject.value = newValue
        }
    }
}
