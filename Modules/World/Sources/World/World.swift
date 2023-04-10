@_exported import Prelude

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
public struct AnyAsyncClosure<I, O> {
    public var wrappedValue: (I) async -> O

    public init(wrappedValue: @escaping (I) async -> O, mock: O) {
        #if DEBUG
            self.wrappedValue = World.isConnected ? wrappedValue : { _ in mock }
        #else
            self.wrappedValue = wrappedValue
        #endif
    }
}

@propertyWrapper
public struct AnyAsyncResultClosure<I, O, F: Error> {
    @AnyAsyncClosure public var wrappedValue: (I) async -> Result<O, F>

    public init(wrappedValue: @escaping (I) async -> Result<O, F>, mock: O) {
        _wrappedValue = .init(
            wrappedValue: wrappedValue,
            mock: .success(mock)
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
