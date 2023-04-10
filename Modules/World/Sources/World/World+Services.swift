import Foundation

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
        @AnyAsyncResultClosure(mock: .mock) var me = userService.me
    }

    struct Items {
        @AnyAsyncResultClosure(mock: .mock) var items = itemsService.items
        @AnyAsyncResultClosure(mock: .mock) var delete = itemsService.delete
        @AnyAsyncResultClosure(mock: Data()) var data = itemsService.data
        @AnyAsyncResultClosure(mock: .mock) var createFolder = itemsService.create
        @AnyAsyncResultClosure(mock: .mock) var uploadFile = itemsService.upload
    }
}
