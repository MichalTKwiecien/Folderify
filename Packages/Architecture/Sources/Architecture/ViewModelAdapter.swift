import Combine
import SwiftUI

public struct ViewModelAdapter<ViewState: Equatable & BulkApplicable, Action> {
    public let stateSubject: CurrentValueSubject<ViewState, Never>
    public let send: (Action) -> Void

    public var viewState: ViewState {
        stateSubject.value
    }

    private var cancellables = Set<AnyCancellable>()

    public init(
        initialViewState: ViewState,
        statePublisher: AnyPublisher<ViewState, Never> = Empty().eraseToAnyPublisher(),
        send: @escaping (Action) -> Void
    ) {
        stateSubject = .init(initialViewState)
        self.send = send
        statePublisher
            .share()
            .removeDuplicates()
            .assignNoRetain(to: \.value, on: stateSubject)
            .store(in: &cancellables)
    }

    /// The method used for creating a custom binding between SwiftUI.Binding and Architecture
    /// - Parameters:
    ///   - get: Returns local view state
    ///   - toAction: Transforms view state change to Action
    /// - Returns: Binding for bidirectional data-flow
    public func binding<LocalViewState>(
        get: @escaping (ViewState) -> LocalViewState,
        send toAction: @escaping (LocalViewState) -> Action
    ) -> Binding<LocalViewState> {
        Binding(
            get: {
                get(stateSubject.value)
            },
            set: { newValue, transaction in
                transaction.animate {
                    self.send(toAction(newValue))
                }
            }
        )
    }

    /// Extracts low-level view state from high-level one.
    /// This method allows to take a piece of high-level view state and pass it to low-level as an adapter
    /// without a need to create ViewModel for low-level view.
    /// **It doesn't provide mapping for an action**. It sets low-level action equal to high-level action.
    /// - Parameter stateMapper: Transforms high-level view state into low-level one
    /// - Returns: Adapter of the low-level view
    public func scope<LocalViewState>(_ stateMapper: @escaping (ViewState) -> LocalViewState) -> ViewModelAdapter<LocalViewState, Action> {
        scope(stateMapper) { $0 }
    }

    /// Extracts low-level view state from high-level one.
    /// This method allows to take a piece of high-level view state and pass it to low-level as an adapter
    /// without a need to create ViewModel for low-level view.
    /// **It doesn't provide mapping for an Action because it's Never**
    public func scopeWithNeverAction<LocalViewState>(_ stateMapper: @escaping (ViewState) -> LocalViewState) -> ViewModelAdapter<LocalViewState, Never> {
        ViewModelAdapter<LocalViewState, Never>(
            initialViewState: stateMapper(stateSubject.value),
            statePublisher: stateSubject.map(stateMapper).eraseToAnyPublisher(),
            send: { _ in }
        )
    }

    /// Extracts low-level view state from high-level one while passing low-level actions to high-level ones.
    /// This method allows to take a piece of high-level view state and pass it to low-level as an adapter
    /// without a need to create ViewModel for low-level view.
    /// - Parameters:
    ///   - stateMapper: Transforms high-level view state into low-level one
    ///   - actionMapper: Transforms low-level actions into high-level ones
    /// - Returns: Adapter of the low-level view
    public func scope<LocalViewState, LocalAction>(
        _ stateMapper: @escaping (ViewState) -> LocalViewState,
        _ actionMapper: @escaping (LocalAction) -> Action
    ) -> ViewModelAdapter<LocalViewState, LocalAction> {
        ViewModelAdapter<LocalViewState, LocalAction>(
            initialViewState: stateMapper(stateSubject.value),
            statePublisher: stateSubject.map(stateMapper).eraseToAnyPublisher(),
            send: { send(actionMapper($0)) }
        )
    }

    /// Returns an "actionless" adapter by erasing action to `Never`.
    public var actionless: ViewModelAdapter<ViewState, Never> {
        scopeWithNeverAction { $0 }
    }
}

public extension ViewModelAdapter {
    static func just(_ viewState: ViewState) -> Self {
        .init(
            initialViewState: viewState,
            send: { _ in }
        )
    }

    func scope<LocalAction>(_ actionMapper: @escaping (LocalAction) -> Action) -> ViewModelAdapter<EmptyViewState, LocalAction> {
        scope({ _ in .init() }, actionMapper)
    }
}

private extension Transaction {
    func animate(_ action: () -> Void) {
        switch animation {
        case .none:
            action()
        case .some:
            withTransaction(self, action)
        }
    }
}
