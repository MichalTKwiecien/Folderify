import Architecture
import World
import UIKit

public struct MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let root: Element

    public init(
        navigationController: UINavigationController,
        root: Element
    ) {
        self.navigationController = navigationController
        self.root = root
    }

    public func begin() {
        showFolderScreen(for: root)
    }
}

private extension MainCoordinator {
    func showFolderScreen(for element: Element) {
        let viewModel = FolderViewModel(
            element: element,
            onBack: {
                navigationController.popViewController(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FolderView, FolderViewModel>(viewModel: viewModel)

        if element == root {
            navigationController.setViewControllers([viewController], animated: false)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showFileView(for element: Element) {
        let viewModel = FileViewModel(
            onDismiss: {
                navigationController.dismiss(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FileView, FileViewModel>(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
