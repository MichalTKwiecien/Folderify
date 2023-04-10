import UIKit
import World
import Login
import FolderViewer

final class ApplicationBootstrap {
    let navigationController = UINavigationController()

    func start() {
        // If we'd have some way of persisting user session, here we would decide what should be the startup
        // screen for the user. For now we're always showing Login.
        Login.MainCoordinator(
            navigationController: navigationController,
            onSuccessfulLogin: { [weak self] user in
                self?.showFolderScreen(user: user)
            }
        ).begin()
    }

    private func showFolderScreen(user: User) {
        FolderViewer.MainCoordinator(
            navigationController: navigationController,
            root: user.root
        ).begin()
    }
}
