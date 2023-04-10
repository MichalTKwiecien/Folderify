import Foundation

public func consoleLog(_ log: String) {
    #if DEBUG
        print(log)
    #endif
}
