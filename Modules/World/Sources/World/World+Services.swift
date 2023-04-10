import Foundation
import Networking

// Initialize the services used by World here
private let userService = UserService()
private let itemsService = ItemsService()

public extension World {
    struct Services {
        public var user = User()
        public var items = Items()
    }
}

public extension World.Services {
    struct User {
        @AnyAsyncResultClosure(mock: .mock) public var login = userService.login
    }

    struct Items {
        @AnyAsyncResultClosure(mock: .mock) public var items = itemsService.items
        @AnyAsyncResultClosure(mock: .mock) public var delete = itemsService.delete
        @AnyAsyncResultClosure(mock: .mock) public var download = itemsService.download
        @AnyAsyncResultClosure(mock: .mock) public var createFolder = itemsService.create
        @AnyAsyncResultClosure(mock: .mock) public var uploadFile = itemsService.upload
    }
}
