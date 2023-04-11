import Architecture
import World
import UIKit
import QuickLook

public struct MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let root: Item
    private var previewingURL: URL?

    public init(
        navigationController: UINavigationController,
        root: Item
    ) {
        self.navigationController = navigationController
        self.root = root
    }

    public func begin() {
        showFolderScreen(for: root, isRoot: true)
    }
}

private extension MainCoordinator {
    func showFolderScreen(for item: Item, isRoot: Bool = false) {
        let viewModel = FolderViewModel(
            item: item,
            onSelectFolder: { element in
                showFolderScreen(for: element)
            },
            onPreviewURL: { url in
                showPreview(for: url)
            },
            onCreateFolder: { refresher in
                showCreateFolder(parentID: item.id, refresher: refresher)
            },
            onDeleted: {
                navigationController.popViewController(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FolderView, FolderViewModel>(viewModel: viewModel)

        if isRoot {
            navigationController.setViewControllers([viewController], animated: false)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showCreateFolder(parentID: Item.ID, refresher: @escaping () -> Void) {
        let viewModel = CreateFolderViewModel(
            parentID: parentID,
            onSuccessfulCreation: {
                navigationController.dismiss(animated: true)
                refresher()
            }
        )
        let viewController = ViewWithAdapterHostingController<CreateFolderView, CreateFolderViewModel>(viewModel: viewModel)
        navigationController.present(viewController, animated: true)
    }

    func showPreview(for url: URL) {
        let viewControler = PreviewViewController(url: url)
        navigationController.present(viewControler, animated: true)
    }
}
