import UIKit
import Login
import FolderViewer

final class ApplicationBootstrap {
    let navigationController = UINavigationController()

    func start() {
        // If we'd have some way of persisting user session, here we would decide what should be the startup
        // screen for the user. For now we're always showing Login.
        Login.MainCoordinator(
            navigationController: navigationController,
            onSuccessfulLogin: { [weak self] in
                self?.showFolderScreen()
            }
        ).begin()
    }

    private func showFolderScreen() {
        // TODO: Get root ID
        FolderViewer.MainCoordinator(
            navigationController: navigationController,
            root: .mockDirectory // TODO: Replace with real id
        ).begin()
    }
}
