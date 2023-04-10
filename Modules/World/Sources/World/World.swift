@_exported import Prelude
import Foundation
import Combine

#if DEBUG
    public var Current = World()
#else
    public private(set) var Current = World()
#endif

public struct World {
    public var system = System()
    public var services = Services()

    /// The flag indicating whether World uses external resources or mocked ones
    static var isConnected = false

    /// Preconfigures World so it can connect with the external resources
    public static func start() {
        // 1. Preconfigure only once
        if !isConnected {
            // 2. The environment is ready to connect with the external resources
            isConnected = true
            // 3. Connect World to the environment by refreshing it
            Current = World()
        }
    }

    #if DEBUG
        /// Forces World to be disconnect from the external resources
        /// Use only for Unit Tests!
        public static func disconnect() {
            // 1. The environment is ready to disconnect from the external resources
            isConnected = false
            // 2. Disconnect World
            Current = World()
        }
    #endif
}

// Property wrappers used for mapping the methods into the closures
// They're responsible for choosing proper implementation of the components based on isConnected

@propertyWrapper
public struct AnyClosure<I, O> {
    public var wrappedValue: (I) -> O

    public init(wrappedValue: @escaping (I) -> O, mock: O) {
        #if DEBUG
            self.wrappedValue = World.isConnected ? wrappedValue : { _ in mock }
        #else
            self.wrappedValue = wrappedValue
        #endif
    }
}

@propertyWrapper
public struct AnyPublisherClosure<I, O, F: Error> {
    @AnyClosure public var wrappedValue: (I) -> AnyPublisher<O, F>

    public init(wrappedValue: @escaping (I) -> AnyPublisher<O, F>, mock: O? = nil) {
        _wrappedValue = .init(
            wrappedValue: wrappedValue,
            mock: {
                if let mock {
                    return Just(mock)
                        .setFailureType(to: F.self)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
            }()
        )
    }
}

@propertyWrapper
public struct AnyAutoClosure<O> {
    public var wrappedValue: () -> O

    public init(wrappedValue: @escaping () -> O, mock: O) {
        #if DEBUG
            self.wrappedValue = World.isConnected ? wrappedValue : { mock }
        #else
            self.wrappedValue = wrappedValue
        #endif
    }
}
