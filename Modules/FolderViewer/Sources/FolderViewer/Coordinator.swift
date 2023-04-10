import Architecture
import World
import UIKit

public struct MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let rootID: Element.ID

    public init(
        navigationController: UINavigationController,
        rootID: Element.ID
    ) {
        self.navigationController = navigationController
        self.rootID = rootID
    }

    public func begin() {
        showFolderScreen(with: rootID)
    }
}

private extension MainCoordinator {
    func showFolderScreen(with id: Element.ID) {
        let viewModel = FolderViewModel(
            onBack: {
                navigationController.popViewController(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FolderView, FolderViewModel>(viewModel: viewModel)

        if id == rootID {
            navigationController.setViewControllers([viewController], animated: true)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showFileView(with id: Element.ID) {
        let viewModel = FileViewModel(
            onDismiss: {
                navigationController.dismiss(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FileView, FileViewModel>(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
