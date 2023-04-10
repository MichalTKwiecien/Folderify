import Architecture
import World
import UIKit
import QuickLook

public final class MainCoordinator: Coordinator {
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
            onSelect: { element in
                if element.isDirectory {
                    self.showFolderScreen(for: element)
                } else {
                    self.showFileView(for: element)
                }
            },
            onBack: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
        )
        let viewController = ViewWithAdapterHostingController<FolderView, FolderViewModel>(viewModel: viewModel)

        if isRoot {
            navigationController.setViewControllers([viewController], animated: false)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showFileView(for item: Item) {
        Task(priority: .userInitiated) {
            switch await Current.services.items.download(item) {
            case let .success(url):
                await MainActor.run {
                    previewingURL = url
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    navigationController.present(previewController, animated: true)
                }
            case .failure:
                break
            }
        }
    }
}

extension MainCoordinator: QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewingURL! as QLPreviewItem // If we're in this place, it's safe to assume it's not optional
    }
}
