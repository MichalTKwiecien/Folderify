import Combine
import Foundation
import Networking
import UIKit

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
        @AnyPublisherClosure var me = userService.me
    }

    struct Items {
        @AnyPublisherClosure var items = itemsService.items
        @AnyPublisherClosure var delete = itemsService.delete
        @AnyPublisherClosure var data = itemsService.data
        @AnyPublisherClosure var createFolder = itemsService.create
        @AnyPublisherClosure var uploadFile = itemsService.upload
    }
}
