import UIKit
import Architecture
import Login

final class ApplicationBootstrap {
    let navigationController = UINavigationController()
    private var currentCoordinator: Coordinator?

    func start() {
        // If we'd have some way of persisting user session, here we would decide what should be the startup
        // screen for the user. For now we're always showing Login.
        let coordinator = Login.MainCoordinator(
            navigationController: navigationController,
            onSuccessfulLogin: { [weak self] in
                self?.showFolderScreen()
            }
        )
        currentCoordinator = coordinator
        coordinator.begin()
    }

    private func showFolderScreen() {
        // TODO: Open folder screen
    }
}
