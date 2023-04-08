import Combine

public extension ViewModel where ViewState == EmptyViewState {
    var viewStateSubject: CurrentValueSubject<EmptyViewState, Never> { .init(.init()) }
}

public struct EmptyViewState: Equatable, BulkApplicable {
    public init() {}
}
